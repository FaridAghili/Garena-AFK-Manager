<?php
require_once '../server/Database.php';
require_once 'Functions.php';

if (isset($_POST['username'], $_POST['days']) == false) {
    exit('نام کاربری و یا تعداد روز را وارد نکرده اید');
}

$username = trim($_POST['username']);
$days     = intval(trim($_POST['days']), 10);

if (   strlen($username) < 1
    || strlen($username) > 16
    || $days < 30
    || $days > 180
) {
    exit('نام کاربری و یا تعداد روز معتبر نیست');
}

if (strcasecmp($username, 'test') == 0) {
    exit('شما مجاز به تمدید این اکانت نیستید');
}

$database = databaseConnect();
if ($database == NULL) {
    exit('متاسفانه خطایی رخ داده است');
}

$username = mysqli_real_escape_string($database, $username);

$query = "SELECT max_users "
       . "FROM accounts "
       . "WHERE username = '{$username}'";
$result = mysqli_query($database, $query);

if (mysqli_num_rows($result) != 1) {
    exit('نام کاربری یافت نشد');
}

$account = mysqli_fetch_assoc($result);
$users   = intval($account['max_users'], 10);

exit(getPrice($days, $users, true, 0) . ' تومان');