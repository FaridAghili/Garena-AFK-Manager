<?php
require_once '../server/Header.php';
require_once 'PHPMailer/PHPMailerAutoload.php';

function sendMail($from, $name, $to, $subject, $body)
{
    $mail = new PHPMailer;

    $mail->IsSMTP();
    $mail->Host       = SMTP_HOST;
    $mail->Port       = SMTP_PORT;
    $mail->SMTPAuth   = true;
    $mail->Username   = SMTP_USERNAME;
    $mail->Password   = SMTP_PASSWORD;
    $mail->SMTPSecure = 'tls';
    $mail->CharSet    = 'UTF-8';

    $mail->From     = $from;
    $mail->FromName = $name;
    $mail->Subject  = $subject;
    $mail->Body     = $body;

    $mail->AddAddress($to);

    $mail->Send();
}

function getPrice($days, $users, $bypass, $discountPercent)
{
    if ($days >= 5 && $days <= 15) {
        $pricePerEachDay = 185;
        $pricePerEachDayPerEachExtraUser = 155 - $users * 7;
    } elseif ($days >= 16 && $days <= 30) {
        $pricePerEachDay = 184;
        $pricePerEachDayPerEachExtraUser = 154 - $users * 7;
    } elseif ($days >= 31 && $days <= 45) {
        $pricePerEachDay = 183;
        $pricePerEachDayPerEachExtraUser = 153 - $users * 7;
    } elseif ($days >= 46 && $days <= 60) {
        $pricePerEachDay = 182;
        $pricePerEachDayPerEachExtraUser = 152 - $users * 7;
    } elseif ($days >= 61 && $days <= 75) {
        $pricePerEachDay = 181;
        $pricePerEachDayPerEachExtraUser = 151 - $users * 7;
    } elseif ($days >= 76 && $days <= 90) {
        $pricePerEachDay = 180;
        $pricePerEachDayPerEachExtraUser = 150 - $users * 7;
    } elseif ($days >= 91 && $days <= 105) {
        $pricePerEachDay = 179;
        $pricePerEachDayPerEachExtraUser = 149 - $users * 7;
    } elseif ($days >= 106 && $days <= 120) {
        $pricePerEachDay = 178;
        $pricePerEachDayPerEachExtraUser = 148 - $users * 7;
    } elseif ($days >= 121 && $days <= 135) {
        $pricePerEachDay = 177;
        $pricePerEachDayPerEachExtraUser = 147 - $users * 7;
    } elseif ($days >= 136 && $days <= 150) {
        $pricePerEachDay = 176;
        $pricePerEachDayPerEachExtraUser = 146 - $users * 7;
    } elseif ($days >= 151 && $days <= 165) {
        $pricePerEachDay = 175;
        $pricePerEachDayPerEachExtraUser = 145 - $users * 7;
    } else {
        $pricePerEachDay = 174;
        $pricePerEachDayPerEachExtraUser = 144 - $users * 7;
    }

    $pricePerExtraUsers = $users > 1 ? $pricePerEachDayPerEachExtraUser * ($users - 1) * $days : 0;
    $priceOfBypass = $bypass ? $days * 80 * $users : 0;
    $priceOfApplication = $days * $pricePerEachDay;
    $totalPrice = $priceOfApplication + $pricePerExtraUsers + $priceOfBypass;

    Return intval(($totalPrice / 100) * (100 - $discountPercent), 10);
}