<?php
require_once '../server/Database.php';
require_once '../server/ZarinPal.php';
require_once '../management/Functions.php';

session_start();

if (!isset($_GET['Status'], $_GET['Authority'], $_SESSION['authority'], $_SESSION['amount'])) {
    header('Location: AccountRenew');
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
        $username   = $_SESSION['username'];
        $email      = $_SESSION['email'];
        $mobile     = $_SESSION['mobile'];
        $resellerId = $_SESSION['resellerId'];

        $query = "SELECT expiry_date "
               . "FROM accounts "
               . "WHERE username = '{$username}'";
        $result = mysqli_query($database, $query);

        $account    = mysqli_fetch_assoc($result);
        $expiryDate = $account['expiry_date'];

        $currentTime = time();

        if ($currentTime > strtotime($expiryDate)) {
            $newExpiryDate = date('Y-m-d H:i:s', $currentTime + $_SESSION['days'] * 86400);
        } else {
            $newExpiryDate = date('Y-m-d H:i:s', strtotime($expiryDate) + $_SESSION['days'] * 86400);
        }

        $query = "UPDATE accounts "
               . "SET expiry_date = '{$newExpiryDate}' "
               . "WHERE username = '{$username}'";
        mysqli_query($database, $query);

        if (strlen($resellerId) == 32) {
            $query = "UPDATE resellers "
                   . "SET credits = credits - 1 "
                   . "WHERE id = '{$resellerId}'";
            mysqli_query($database, $query);
        }

        $style    = 'success';
        $messsage = 'اکانت شما هم اکنون تمدید شده است.<br><br>از خرید شما سپاسگذاریم...';
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
<h3 class="title3">تمدید اکانت</h3>
<div class="alert alert-<?php echo $style; ?>"><?php echo $messsage; ?></div>
<?php require_once('../includes/Footer.php'); ?>