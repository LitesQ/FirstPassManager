<?php

$link = mysqli_connect('127.0.0.1', 'root', '95159514','FirstPass');

if (!$link) {
  echo 'Не могу соединиться с БД. Код ошибки: ' . mysqli_connect_errno() . ', ошибка: ' . mysqli_connect_error();
  exit;
}

$Username = $_POST['a'];
$ID = $_POST['b'];

$query = "UPDATE `$Username` SET `isRemoved` = '0' WHERE `ID` = '$ID';";

mysqli_query($link, $query);// or die(mysql_error());

//echo $query;
echo "Successfully added";




 ?>
