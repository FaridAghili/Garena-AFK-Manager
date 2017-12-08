<?php
require_once '../server/Database.php';
require_once 'Functions.php';

session_start();

if (!isset($_POST['username'],
    $_POST['currentPassword'],
    $_POST['newPassword'],
    $_POST['captcha'],
    $_SESSION['captcha'])
) {
    exit();
}

$username        = trim($_POST['username']);
$currentPassword = trim($_POST['currentPassword']);
$newPassword     = trim($_POST['newPassword']);
$captcha         = trim($_POST['captcha']);

if (   strlen($username) < 1
    || strlen($username) > 16
    || strlen($currentPassword) < 1
    || strlen($currentPassword) > 31
    || strlen($newPassword) < 1
    || strlen($newPassword) > 31
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

$username            = mysqli_real_escape_string($database, $username);
$currentPasswordHash = md5($currentPassword);
$newPasswordHash     = md5($newPassword);

$query = "SELECT email "
       . "FROM accounts "
       . "WHERE username = '{$username}' AND password = '{$currentPasswordHash}'";
$result = mysqli_query($database, $query);

if (mysqli_num_rows($result) != 1) {
    exit('2');
}

$account = mysqli_fetch_assoc($result);
$email   = $account['email'];

$query = "UPDATE accounts "
       . "SET password = '{$newPasswordHash}' "
       . "WHERE username = '{$username}'";
mysqli_query($database, $query);

$body = "Please DO NOT reply to this email.\n\nUsername:\t{$username}\nPassword:\t{$newPassword}\n\nwww.AFK-Manager.ir";
sendMail('account@afk-manager.ir', 'AFK Manager', $email, 'AFK Manager - Password Change', $body);
exit('3');