<?php
$link = mysqli_connect('127.0.0.1', 'root', '95159514','FirstPass');

if (!$link) {
  echo 'Не могу соединиться с БД. Код ошибки: ' . mysqli_connect_errno() . ', ошибка: ' . mysqli_connect_error();
  exit;
}

$ID = $_POST['a'];
$Username = $_POST['b'];

$query = "DELETE FROM `$Username` WHERE `ID` = '$ID';";

mysqli_query($link, $query);// or die(mysql_error());

//echo $query;
echo "Successfully added";
?>
