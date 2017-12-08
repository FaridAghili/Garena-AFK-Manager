<?php
require_once '../server/Database.php';
require_once '../server/ZarinPal.php';
require_once '../management/Functions.php';

session_start();

if (!isset($_GET['Status'], $_GET['Authority'], $_SESSION['authority'], $_SESSION['amount'])) {
    header('Location: AccountPurchase');
    exit();
}

$database = databaseConnect();
if ($database == NULL) {
    $style    = 'danger';
    $messsage = 'متاسفانه خطایی در برقراری ارتباط با پایگاه داده رخ داده است.<br><br>چنانچه مبلغی از حساب شما کسر شده باشد، حداکثر ظرف مدت 72 ساعت توسط بانک برگشت داده خواهد شد.';
} else {
    $result = verify(MERCHANT_ID, $_SESSION['authority'], $_SESSION['amount']);
    if (empty($result)) {
        $style    = 'danger';
        $messsage = 'متاسفانه قادر به ارتباط با سرور بانک نیستیم.<br><br>چنانچه مبلغی از حساب شما کسر شده باشد، حداکثر ظرف مدت 72 ساعت توسط بانک برگشت داده خواهد شد.';
    } elseif ($result->Status == 100) {
        $username     = strtolower($_SESSION['username']);
        $password     = $_SESSION['password'];
        $passwordHash = md5($_SESSION['password']);
        $expiryDate   = date('Y-m-d H:i:s', time() + $_SESSION['days'] * 86400);
        $users        = $_SESSION['users'];
        $email        = mysqli_real_escape_string($database, strtolower($_SESSION['email']));
        $mobile       = $_SESSION['mobile'];
        $resellerId   = $_SESSION['resellerId'];

        $query = "INSERT INTO accounts "
               . "(username, password, expiry_date, max_users, proxy, email, mobile) "
               . "VALUES "
               . "('{$username}', '{$passwordHash}', '{$expiryDate}', {$users}, 1, '{$email}', '{$mobile}')";
        mysqli_query($database, $query);

        if (strlen($resellerId) == 32) {
            $query = "UPDATE resellers "
                   . "SET credits = credits - 1 "
                   . "WHERE id = '{$resellerId}'";
            mysqli_query($database, $query);
        }

        $body = "Please DO NOT reply to this email.\n\nUsername: {$username}\nPassword: {$password}\nExpiry Date: {$expiryDate}\nMax Users: {$users}\n\nwww.AFK-Manager.ir";
        sendMail('account@afk-manager.ir', 'AFK Manager', $email, 'AFK Manager - Account', $body);

        $style    = 'success';
        $messsage = 'اکانت شما هم اکنون ایجاد و فعال شده است.<br>اطلاعات اکانت به ایمیل شما ارسال شد.<br><br>از خرید شما سپاسگذاریم...';
    } else {
        $style    = 'warning';
        $messsage = 'عملیات پرداخت موفقیت آمیز نبود.';
    }

    session_destroy();
}

require_once('../includes/Header.php');
require_once('../includes/Navigation.php');
require_once('../includes/Sidebar.php');
?>
<h3 class="title3">خرید اکانت</h3>
<div class="alert alert-<?php echo $style; ?>"><?php echo $messsage; ?></div>
<?php require_once('../includes/Footer.php'); ?>