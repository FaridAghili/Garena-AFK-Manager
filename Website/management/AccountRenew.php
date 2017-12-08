<?php
require_once '../server/Database.php';
require_once '../server/ZarinPal.php';
require_once 'Functions.php';

session_start();

if (!isset($_POST['username'],
    $_POST['days'],
    $_POST['resellerId'],
    $_POST['captcha'],
    $_SESSION['captcha'])
) {
    exit();
}

$username   = trim($_POST['username']);
$days       = intval(trim($_POST['days']), 10);
$resellerId = trim($_POST['resellerId']);
$captcha    = trim($_POST['captcha']);

if (   strlen($username) < 1
    || strlen($username) > 16
    || $days < 30
    || $days > 180
    || strlen($captcha) != 5
    || !is_numeric($captcha)
) {
    exit();
}

if (intval($captcha, 10) != $_SESSION['captcha']) {
    exit('1');
}

if (strcasecmp($username, 'test') == 0) {
    exit();
}

$database = databaseConnect();
if ($database == NULL) {
    header('HTTP/1.1 500 Internal Error');
    exit();
}

$username = mysqli_real_escape_string($database, $username);

$query = "SELECT max_users, proxy, email, mobile "
       . "FROM accounts "
       . "WHERE username = '{$username}'";
$result = mysqli_query($database, $query);

if (mysqli_num_rows($result) != 1) {
    exit('2');
}

$account = mysqli_fetch_assoc($result);
$users   = intval($account['max_users'], 10);
$bypass  = $account['proxy'] == '1' ? true : false;
$email   = $account['email'];
$mobile  = $account['mobile'];

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
$callbackUrl = 'http://' . $_SERVER['SERVER_NAME'] . '/AccountRenewCallback';
$result = request(MERCHANT_ID, $amount, "tamdid | {$username} | {$days} day | {$users} user", $email, $mobile, $callbackUrl);
if ($result->Status != 100 || strlen($result->Authority) != 36) {
    header('HTTP/1.1 500 Internal Error');
    exit();
}

$_SESSION['username']   = $username;
$_SESSION['email']      = $email;
$_SESSION['mobile']     = $mobile;
$_SESSION['days']       = $days;
$_SESSION['resellerId'] = $resellerId;
$_SESSION['amount']     = $amount;
$_SESSION['authority']  = $result->Authority;

echo "<form action='https://www.zarinpal.com/pg/StartPay/" . $result->Authority . "/ZarinGate'></form>";