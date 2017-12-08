<?php
function request($merchantId, $amount, $description, $email, $mobile, $callbackUrl)
{
    $client = new SoapClient('https://de.zarinpal.com/pg/services/WebGate/wsdl', array('encoding' => 'UTF-8'));

    $result = $client->PaymentRequest(
        array(
            'MerchantID'  => $merchantId,
            'Amount'      => $amount,
            'Description' => $description,
            'Email'       => $email,
            'Mobile'      => $mobile,
            'CallbackURL' => $callbackUrl
        )
    );

    return $result;
}

function verify($merchantId, $authority, $amount)
{
    $client = new SoapClient('https://de.zarinpal.com/pg/services/WebGate/wsdl', array('encoding' => 'UTF-8'));

    $result = $client->PaymentVerification(
        array(
            'MerchantID' => $merchantId,
            'Authority'  => $authority,
            'Amount'     => $amount
        )
    );

    return $result;
}