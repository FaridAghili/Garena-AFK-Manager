<?php
require_once 'Database.php';

$database = databaseConnect();
if ($database == NULL) {
    exit();
}

$deadline = date('Y-m-d H:i:s', time() - SEC_THIRTY_MINUTES);

$query = "DELETE FROM onlines "
       . "WHERE last_seen <= '{$deadline}'";
$result = mysqli_query($database, $query);