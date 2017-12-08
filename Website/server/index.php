<?php
require_once 'Database.php';
require_once 'Validator.php';
require_once 'Server.php';

header_remove();

if (!isset($_SERVER['HTTPS'])) {
    header('HTTP/1.1 403 Forbidden');
    exit();
}

if (isset($_SERVER['HTTP_USER_AGENT']) == 0) {
    header('HTTP/1.1 400 Bad Request');
    exit();
}

if (strcmp($_SERVER['HTTP_USER_AGENT'], 'AFK Manager') != 0) {
    header('HTTP/1.1 401 Unauthorized');
    exit();
}

if (strcmp($_SERVER['REQUEST_METHOD'], 'POST') != 0) {
    header('HTTP/1.1 405 Method Not Allowed');
    exit();
}

if (isset($_POST['r']) == FALSE) {
    header('HTTP/1.1 406 Not Acceptable');
    exit();
}

$request = str_getcsv($_POST['r'], '|', '');
if (isValidRequest($request) == FALSE) {
    header('HTTP/1.1 406 Not Acceptable');
    exit();
}

$database = databaseConnect();
if ($database == NULL) {
    header('HTTP/1.1 500 Internal Error');
    exit();
}

$request[1] = mysqli_real_escape_string($database, trim($request[1]));
$request[2] = mysqli_real_escape_string($database, trim($request[2]));

switch (intval($request[0], 10)) {
    case REQ_LOGIN:
        $request[3] = mysqli_real_escape_string($database, trim($request[3]));
        echo login($database, $request[1], $request[2], $request[3]);
        break;

    case REQ_CHECK_IN:
        $request[3] = mysqli_real_escape_string($database, trim($request[3]));
        echo checkIn($database, $request[1], $request[2], $request[3]);
        break;

    case REQ_LOGOUT:
        logout($database, $request[1], $request[2]);
        break;
}