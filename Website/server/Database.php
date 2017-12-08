<?php
require_once 'Header.php';

function databaseConnect()
{
    $database = mysqli_connect(DB_SERVER, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
    return mysqli_connect_errno() ? NULL : $database;
}