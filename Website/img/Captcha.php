<?php
define('FONT_NAME', '../fonts/Arnold.ttf');

$a = rand(1, 9);
$b = rand(1, 9);
$c = rand(1, 9);
$d = rand(1, 9);
$e = rand(1, 9);

session_start();
$_SESSION['captcha'] = intval("{$a}{$b}{$c}{$d}{$e}");

$image = imagecreate(130, 40);

imagecolorallocate($image, 0xFF, 0xFF, 0xFF);
imagettftext($image, rand(12, 18), rand(-30, 30), rand(11, 16),   rand(21, 31), imagecolorallocate($image, 0x2C, 0x3E, 0x50), FONT_NAME, $a);
imagettftext($image, rand(12, 18), rand(-30, 30), rand(31, 41),   rand(21, 31), imagecolorallocate($image, 0x27, 0xAE, 0x60), FONT_NAME, $b);
imagettftext($image, rand(12, 18), rand(-30, 30), rand(56, 66),   rand(21, 31), imagecolorallocate($image, 0xC0, 0x39, 0x2B), FONT_NAME, $c);
imagettftext($image, rand(12, 18), rand(-30, 30), rand(81, 91),   rand(21, 31), imagecolorallocate($image, 0xD3, 0x54, 0x00), FONT_NAME, $d);
imagettftext($image, rand(12, 18), rand(-30, 30), rand(106, 111), rand(21, 31), imagecolorallocate($image, 0x8E, 0x44, 0xAD), FONT_NAME, $e);

header("Content-Type: image/png");
imagepng($image);

imagedestroy($image);