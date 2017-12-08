<?php
date_default_timezone_set('Asia/Tehran');

//Database constants
define('DB_SERVER',   'localhost');
define('DB_USERNAME', 'afkmanag_g34g34h');
define('DB_PASSWORD', 'RRb+#ln~_a#B');
define('DB_DATABASE', 'afkmanag_g34g34h');

//Request constants
define('REQ_LOGIN',    20);
define('REQ_CHECK_IN', 21);
define('REQ_LOGOUT',   22);

//Result constants
define('RES_SUCCESS',    200);
define('RES_INVALID',    201);
define('RES_EXPIRED',    202);
define('RES_USER_LIMIT', 203);
define('RES_LOCKED',     204);

//Time constants
define('SEC_THIRTY_MINUTES', 1800);
define('SEC_ONE_DAY',        86400);
define('SEC_ONE_MONTH',      2592000);

//Payment constants
define('MERCHANT_ID', '562964c6-a4f4-467a-b899-15665bef37d4');

//SMTP constants
define('SMTP_HOST',     'smtp.sendgrid.net');
define('SMTP_PORT',     587);
define('SMTP_USERNAME', 'hossein');
define('SMTP_PASSWORD', 'h6578520');