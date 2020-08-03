<?php

$link = mysqli_connect('127.0.0.1', 'root', '95159514','FirstPass');

if (!$link) {
  echo 'Не могу соединиться с БД. Код ошибки: ' . mysqli_connect_errno() . ', ошибка: ' . mysqli_connect_error();
  exit;
}

$Username = $_POST['a'];
$Name = $_POST['b'];
$Login = $_POST['c'];
$Password = $_POST['d'];
$Site = $_POST['e'];
$Note = $_POST['f'];
$ID = $_POST['g'];

$query = "UPDATE `$Username` SET `Name` = '$Name', `Login` = '$Login', `Password` = '$Password', `Website` = '$Site', `Note` = '$Note' WHERE `ID` = '$ID';";

mysqli_query($link, $query);// or die(mysql_error());

//echo $query;
echo "Successfully added";




 ?>
