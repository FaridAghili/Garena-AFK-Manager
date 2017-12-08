<?php
require_once 'Header.php';

function login($database, $username, $password, $machineId)
{
    $response = array();

    $query = "SELECT expiry_date, max_users, proxy "
           . "FROM accounts "
           . "WHERE username = '{$username}' AND password = '{$password}'";
    $result = mysqli_query($database, $query);

    if (mysqli_num_rows($result) != 1) {
        $response['Result'] = RES_INVALID;
        return json_encode($response);
    }

    $account    = mysqli_fetch_assoc($result);
    $expiryDate = $account['expiry_date'];
    $maxUsers   = intval($account['max_users'], 10);
    $proxyState = intval($account['proxy'], 10) == 1;

    $currentTime = time();

    if ($currentTime >= strtotime($expiryDate)) {
        $response['Result'] = RES_EXPIRED;
        return json_encode($response);
    }

    if ($maxUsers <= 0) {
        $response['Result'] = RES_LOCKED;
        return json_encode($response);
    }

    $query = "SELECT id, machine_id, last_seen "
           . "FROM onlines "
           . "WHERE username = '{$username}'";
    $result = mysqli_query($database, $query);

    $id = 0;
    $onlineClients = 0;

    if (mysqli_num_rows($result) > 0) {
        while ($online = mysqli_fetch_assoc($result)) {
            if (strcmp($machineId, $online['machine_id']) == 0) {
                $id = intval($online['id'], 10);
            } else {
                if ($currentTime - strtotime($online['last_seen']) < SEC_THIRTY_MINUTES) {
                    $onlineClients++;
                } else {
                    $query = "DELETE FROM onlines "
                           . "WHERE id = {$online['id']}";
                    mysqli_query($database, $query);
                }
            }
        }

        if ($onlineClients >= $maxUsers) {
            $response['Result'] = RES_USER_LIMIT;
            return json_encode($response);
        }
    }

    $currentDate = date('Y-m-d H:i:s');

    if ($id == 0) {
        $query = "INSERT INTO onlines "
               . "(username, machine_id, last_seen) "
               . "VALUES "
               . "('{$username}', '{$machineId}', '{$currentDate}')";
    } else {
        $query = "UPDATE onlines "
               . "SET last_seen = '{$currentDate}' "
               . "WHERE id = {$id}";
    }

    mysqli_query($database, $query);

    $query = "SELECT version, proxy_server, room_id, channel_id, room_servers, talk_servers "
           . "FROM program "
           . "WHERE id = 1";
    $result = mysqli_query($database, $query);

    $program                   = mysqli_fetch_assoc($result);
    $version                   = floatval($program['version']);
    list($proxyIp, $proxyPort) = explode(':', $program['proxy_server']);
    $roomId                    = intval($program['room_id'], 10);
    $channelId                 = intval($program['channel_id'], 10);
    $roomServers               = explode('|', $program['room_servers']);
    $talkServers               = explode('|', $program['talk_servers']);

    $remainingDays   = floor((strtotime($expiryDate) - $currentTime) / SEC_ONE_DAY);
    $proxyPort       = intval($proxyPort, 10);

    $program = array(
                     'Version'         => $version,
                     'RoomId'          => $roomId,
                     'ChannelId'       => $channelId
                    );

    $account = array(
                     'RemainingDays' => $remainingDays,
                     'MaxUsers'      => $maxUsers,
                     'OnlineUsers'   => $onlineClients + 1
                    );

    $proxy = array(
                   'IsEnabled' => $proxyState,
                   'IP'        => $proxyState ? $proxyIp : '',
                   'Port'      => $proxyState ? $proxyPort : 0
                  );

    $response['Result']      = RES_SUCCESS;
    $response['Program']     = $program;
    $response['Account']     = $account;
    $response['Proxy']       = $proxy;
    $response['RoomServers'] = $roomServers;
    $response['TalkServers'] = $talkServers;

    return json_encode($response);
}

function checkIn($database, $username, $password, $machineId)
{
    $response = array();

    $query = "SELECT expiry_date, max_users, proxy "
           . "FROM accounts "
           . "WHERE username = '{$username}' AND password = '{$password}'";
    $result = mysqli_query($database, $query);

    if (mysqli_num_rows($result) != 1) {
        logout($database, $username, $machineId);

        $response['Result'] = RES_INVALID;
        return json_encode($response);
    }

    $account    = mysqli_fetch_assoc($result);
    $expiryDate = $account['expiry_date'];
    $maxUsers   = intval($account['max_users'], 10);
    $proxyState = intval($account['proxy'], 10) == 1;

    $currentTime = time();

    if ($currentTime >= strtotime($expiryDate)) {
        logout($database, $username, $machineId);

        $response['Result'] = RES_EXPIRED;
        return json_encode($response);
    }

    if ($maxUsers <= 0) {
        logout($database, $username, $machineId);

        $response['Result'] = RES_LOCKED;
        return json_encode($response);
    }

    $query = "SELECT id, machine_id, last_seen "
           . "FROM onlines "
           . "WHERE username = '{$username}'";
    $result = mysqli_query($database, $query);

    $id = 0;
    $onlineClients = 0;

    if (mysqli_num_rows($result) > 0) {

        while ($online = mysqli_fetch_assoc($result)) {
            if (strcmp($machineId, $online['machine_id']) == 0) {
                $id = intval($online['id'], 10);
            } else {
                if ($currentTime - strtotime($online['last_seen']) < SEC_THIRTY_MINUTES) {
                    $onlineClients++;
                } else {
                    $query = "DELETE FROM onlines "
                           . "WHERE id = {$online['id']}";
                    mysqli_query($database, $query);
                }
            }
        }

        if ($onlineClients >= $maxUsers) {
            logout($database, $username, $machineId);

            $response['Result'] = RES_USER_LIMIT;
            return json_encode($response);
        }
    }

    $currentDate = date('Y-m-d H:i:s');

    if ($id == 0) {
        $query = "INSERT INTO onlines "
               . "(username, machine_id, last_seen) "
               . "VALUES "
               . "('{$username}', '{$machineId}', '{$currentDate}')";
    } else {
        $query = "UPDATE onlines "
               . "SET last_seen = '{$currentDate}' "
               . "WHERE id = {$id}";
    }

    mysqli_query($database, $query);

    $query = "SELECT version, proxy_server, room_id, channel_id, room_servers, talk_servers "
           . "FROM program "
           . "WHERE id = 1";
    $result = mysqli_query($database, $query);

    $program                   = mysqli_fetch_assoc($result);
    $version                   = floatval($program['version']);
    list($proxyIp, $proxyPort) = explode(':', $program['proxy_server']);
    $roomId                    = intval($program['room_id'], 10);
    $channelId                 = intval($program['channel_id'], 10);
    $roomServers               = explode('|', $program['room_servers']);
    $talkServers               = explode('|', $program['talk_servers']);

    $remainingDays   = floor((strtotime($expiryDate) - $currentTime) / SEC_ONE_DAY);
    $proxyPort       = intval($proxyPort, 10);

    $program = array(
                     'Version'         => $version,
                     'RoomId'          => $roomId,
                     'ChannelId'       => $channelId
                    );

    $account = array(
                     'RemainingDays' => $remainingDays,
                     'MaxUsers'      => $maxUsers,
                     'OnlineUsers'   => $onlineClients + 1
                    );

    $proxy = array(
                   'IsEnabled' => $proxyState,
                   'IP'        => $proxyState ? $proxyIp : '',
                   'Port'      => $proxyState ? $proxyPort : 0
                  );

    $response['Result']      = RES_SUCCESS;
    $response['Program']     = $program;
    $response['Account']     = $account;
    $response['Proxy']       = $proxy;
    $response['RoomServers'] = $roomServers;
    $response['TalkServers'] = $talkServers;

    return json_encode($response);
}

function logout($database, $username, $machineId)
{
    $query = "DELETE FROM onlines "
           . "WHERE username = '{$username}' AND machine_id = '{$machineId}'";
    mysqli_query($database, $query);
}