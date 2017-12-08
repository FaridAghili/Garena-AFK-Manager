<?php
require_once '../server/Header.php';
require_once 'Functions.php';

session_start();

if (!isset($_POST['fullName'],
    $_POST['email'],
    $_POST['message'],
    $_POST['captcha'],
    $_SESSION['captcha'])
) {
    exit();
}

$fullName = trim($_POST['fullName']);
$email    = trim($_POST['email']);
$message  = trim($_POST['message']);
$captcha  = trim($_POST['captcha']);

if (   strlen($fullName) == 0
    || filter_var(filter_var($email, FILTER_SANITIZE_EMAIL), FILTER_VALIDATE_EMAIL) == FALSE
    || strlen($message) == 0
    || strlen($captcha) != 5
    || !is_numeric($captcha)
) {
    exit();
}

if (intval($captcha, 10) != $_SESSION['captcha']) {
    exit('1');
}

$message .= "\n\n{$email}";

sendMail('kingretailer@gmail.com', $fullName, 'kingsiren@yahoo.com', 'AFK Manager - Ticket', $message);
exit('2');