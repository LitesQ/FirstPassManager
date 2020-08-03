<?php
$link = mysqli_connect('127.0.0.1', 'root', '95159514','FirstPass');

if (!$link) {
  echo 'Не могу соединиться с БД. Код ошибки: ' . mysqli_connect_errno() . ', ошибка: ' . mysqli_connect_error();
  return;
}

$Login = $_POST['a'];
$Request = $_POST['b'];

$query = "SELECT * FROM `$Login` WHERE `isRemoved` = 1 AND `Name` LIKE '%$Request%' ORDER BY `Name` ASC;";

$result_raw = mysqli_query($link, $query);// or die(mysql_error());

$result = array();

while ($r = mysqli_fetch_assoc($result_raw)){
  $result[] = $r;
}

  echo json_encode($result);


 ?>
