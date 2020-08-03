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

$query = "INSERT INTO `$Username` (`ID`, `Name`, `Login`, `Password`, `Website`, `Note`, `isRemoved`) VALUES (NULL, '$Name', '$Login', '$Password', '$Site', '$Note', '0');";
mysqli_query($link, $query);// or die(mysql_error());


$auto = mysqli_fetch_assoc(mysqli_query($link, "SHOW TABLE STATUS FROM `FirstPass` WHERE `Name` = '$Username'"));
echo $auto['Auto_increment'] - 1;

?>
