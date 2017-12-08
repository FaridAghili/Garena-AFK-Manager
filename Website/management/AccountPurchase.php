<?php
require_once '../server/Database.php';
require_once '../server/ZarinPal.php';
require_once 'Functions.php';

session_start();

if (!isset($_POST['username'],
    $_POST['password'],
    $_POST['days'],
    $_POST['users'],
    $_POST['email'],
    $_POST['mobile'],
    $_POST['resellerId'],
    $_POST['captcha'],
    $_SESSION['captcha'])
) {
    exit();
}

$username   = trim($_POST['username']);
$password   = trim($_POST['password']);
$email      = trim($_POST['email']);
$mobile     = trim($_POST['mobile']);
$days       = intval(trim($_POST['days']), 10);
$users      = intval(trim($_POST['users']), 10);
$bypass     = true;
$resellerId = trim($_POST['resellerId']);
$captcha    = trim($_POST['captcha']);

if (   strlen($username) < 1
    || strlen($username) > 16
    || strlen($password) < 1
    || strlen($password) > 31
    || filter_var(filter_var($email, FILTER_SANITIZE_EMAIL), FILTER_VALIDATE_EMAIL) == FALSE
    || !preg_match('^9[0123]\d{8}$^', $mobile)
    || $days < 30
    || $days > 180
    || $users < 1
    || $users > 3
    || strlen($captcha) != 5
    || !is_numeric($captcha)
) {
    exit();
}

if (intval($captcha, 10) != $_SESSION['captcha']) {
    exit('1');
}

$database = databaseConnect();
if ($database == NULL) {
    header('HTTP/1.1 500 Internal Error');
    exit();
}

$username = mysqli_real_escape_string($database, $username);

$query = "SELECT username "
       . "FROM accounts "
       . "WHERE username = '{$username}'";
$result = mysqli_query($database, $query);

if (mysqli_num_rows($result) != 0) {
    exit('2');
}

$discountPercent = 0;

if (strlen($resellerId) == 32) {
    $query = "SELECT discount_percent, credits "
           . "FROM resellers "
           . "WHERE id = '{$resellerId}'";
    $result = mysqli_query($database, $query);

    if (mysqli_num_rows($result) == 1) {
        $reseller = mysqli_fetch_assoc($result);
        $credits  = intval($reseller['credits'], 10);

        if ($credits > 0) {
            $discountPercent = intval($reseller['discount_percent'], 10);
        }
    }
}

$amount      = getPrice($days, $users, $bypass, $discountPercent);
$callbackUrl = 'http://' . $_SERVER['SERVER_NAME'] . '/AccountPurchaseCallback';
$result = request(MERCHANT_ID, $amount, "kharid | {$username} | {$days} day | {$users} user", $email, $mobile, $callbackUrl);
if ($result->Status != 100 || strlen($result->Authority) != 36) {
    header('HTTP/1.1 500 Internal Error');
    exit();
}

$_SESSION['username']   = $username;
$_SESSION['password']   = $password;
$_SESSION['email']      = $email;
$_SESSION['mobile']     = $mobile;
$_SESSION['days']       = $days;
$_SESSION['users']      = $users;
$_SESSION['bypass']     = $bypass;
$_SESSION['resellerId'] = $resellerId;
$_SESSION['amount']     = $amount;
$_SESSION['authority']  = $result->Authority;

echo "<form action='https://www.zarinpal.com/pg/StartPay/" . $result->Authority . "/ZarinGate'></form>";