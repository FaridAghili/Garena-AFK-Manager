<?php
require_once '../server/Header.php';
require_once '../server/ZarinPal.php';

session_start();

if (!isset($_GET['Status'], $_GET['Authority'], $_SESSION['authority'], $_SESSION['amount'])) {
    exit();
}

$result = verify(MERCHANT_ID, $_SESSION['authority'], $_SESSION['amount']);
if (empty($result)) {
    $messsage = 'Payment failed.';
} elseif ($result->Status == 100) {
    $messsage = 'Payment successed.<br>Id: ' . $result->RefID;
} else {
    $messsage = 'Payment failed.';
}

session_destroy();
echo $messsage;