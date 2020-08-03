<?php

  $link = mysqli_connect('127.0.0.1', 'root', '95159514','FirstPass');

  if (!$link) {
    echo 'Не могу соединиться с БД. Код ошибки: ' . mysqli_connect_errno() . ', ошибка: ' . mysqli_connect_error();
    exit;
  }

  $Login = $_POST['a'];


  $permitted_chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
  $Secure_Key = substr(str_shuffle($permitted_chars), 0, 4).'-'.substr(str_shuffle($permitted_chars), 0, 5).'-'.substr(str_shuffle($permitted_chars), 0, 6).'-'.substr(str_shuffle($permitted_chars), 0, 3);
  $Secure_Key_Hash = md5(md5($Secure_Key));

  $query = "UPDATE `Users` SET `Secure_Key_Hash` = '$Secure_Key_Hash' WHERE `Login` = '$Login';";

  mysqli_query($link, $query) or die(mysql_error());

  echo $Secure_Key;

?>
