<?php
require_once '../server/Database.php';
require_once 'Functions.php';

session_start();

if (!isset($_POST['username'],
    $_POST['email'],
    $_POST['captcha'],
    $_SESSION['captcha'])
) {
    exit();
}

$username = trim($_POST['username']);
$email    = trim($_POST['email']);
$captcha  = trim($_POST['captcha']);

if (   strlen($username) < 1
    || strlen($username) > 16
    || filter_var(filter_var($email, FILTER_SANITIZE_EMAIL), FILTER_VALIDATE_EMAIL) == FALSE
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

$username        = mysqli_real_escape_string($database, $username);
$email           = mysqli_real_escape_string($database, $email);
$newPassword     = substr(str_shuffle('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'), 0, 10);
$newPasswordHash = md5($newPassword);

$query = "UPDATE accounts "
       . "SET password = '{$newPasswordHash}' "
       . "WHERE username = '{$username}' AND email = '{$email}'";
mysqli_query($database, $query);

if (mysqli_affected_rows($database) != 1) {
    exit('2');
}

$body = "Please DO NOT reply to this email.\n\nUsername:\t{$username}\nPassword:\t{$newPassword}\n\nwww.AFK-Manager.ir";
sendMail('account@afk-manager.ir', 'AFK Manager', $email, 'AFK Manager - Password Reset', $body);
exit('3');