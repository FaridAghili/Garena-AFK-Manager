<?php
function isValidRequest($request)
{
    if (is_numeric($request[0]) == FALSE) {
        return FALSE;
    }

    switch (intval($request[0], 10)) {
        case REQ_LOGIN:
        case REQ_CHECK_IN:
            if (   count($request) != 4
                || isValidUsername($request[1]) == FALSE
                || isValidHash($request[2]) == FALSE
                || isValidHash($request[3]) == FALSE
            ) {
                return FALSE;
            }
            break;

        case REQ_LOGOUT:
            if (   count($request) != 3
                || isValidUsername($request[1]) == FALSE
                || isValidHash($request[2]) == FALSE
            ) {
                return FALSE;
            }
            break;

        default:
            return FALSE;
    }

    return TRUE;
}

function isValidUsername($username)
{
    $username = trim($username);

    if (strlen($username) < 1 || strlen($username) > 16) {
        return FALSE;
    }

    return TRUE;
}

function isValidHash($hash)
{
    $hash = trim($hash);

    if (strlen($hash) != 32) {
        return FALSE;
    }

    return TRUE;
}