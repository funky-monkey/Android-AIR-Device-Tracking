<?php
header('Content-Type: text/html; charset=utf-8');
error_reporting(E_ALL);

$var_utmac='UA-000000-00'; //enter the new urchin code
$var_utmhn='yourdomain.com'; //enter your domain
$var_utmn=rand(1000000000,9999999999);//random request number
$var_cookie=rand(10000000,99999999);//random cookie number
$var_random=rand(1000000000,2147483647); //number under 2147483647
$var_today=time(); //today
$var_referer=$_SERVER['HTTP_REFERER']; //referer url

$var_uservar = $_GET["page"]; //enter your own user defined variable
$var_utmp='/app/'.$_GET["appname"].'/'.$var_uservar; //this example adds a fake page request to the (fake) rss directory (the viewer IP to check for absolute unique RSS readers)

$urchinUrl='http://www.google-analytics.com/__utm.gif?utmwv=1&utmn='.$var_utmn.'&utmsr=-&utmsc=-&utmul=-&utmje=0&utmfl=-&utmdt=-&utmhn='.$var_utmhn.'&utmr='.$var_referer.'&utmp='.$var_utmp.'&utmac='.$var_utmac.'&utmcc=__utma%3D'.$var_cookie.'.'.$var_random.'.'.$var_today.'.'.$var_today.'.'.$var_today.'.2%3B%2B__utmb%3D'.$var_cookie.'%3B%2B__utmc%3D'.$var_cookie.'%3B%2B__utmz%3D'.$var_cookie.'.'.$var_today.'.2.2.utmccn%3D(direct)%7Cutmcsr%3D(direct)%7Cutmcmd%3D(none)%3B%2B__utmv%3D'.$var_cookie.'.'.$var_uservar.'%3B';
 
$handle = fopen($urchinUrl, "r");
$test = fgets($handle);
fclose($handle);

echo($var_utmp);

?>