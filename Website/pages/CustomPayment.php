<?php
require_once '../server/Header.php';
require_once '../server/ZarinPal.php';

if (!isset($_GET['a']) || !is_numeric($_GET['a'])) {
    exit();
}

$amount = intval($_GET['a'], 10);
if ($amount < 100) {
    exit();
}

$callbackUrl = 'http://' . $_SERVER['SERVER_NAME'] . '/CustomPaymentCallback';
$result = request(MERCHANT_ID, $amount, 'پرداخت سفارشی', NULL, NULL, $callbackUrl);
if ($result->Status != 100 || strlen($result->Authority) != 36) {
    exit();
}

session_start();
$_SESSION['amount']    = $amount;
$_SESSION['authority'] = $result->Authority;

Header('Location: https://www.zarinpal.com/pg/StartPay/' . $result->Authority . '/ZarinGate');