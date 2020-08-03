<?php

  $link = mysqli_connect('127.0.0.1', 'root', '95159514','FirstPass');

  if (!$link) {
    echo 'Не могу соединиться с БД. Код ошибки: ' . mysqli_connect_errno() . ', ошибка: ' . mysqli_connect_error();
    exit;
  }

  $Login = $_POST['a'];
  $Password = $_POST['b'];

  $Password_Hash = md5(md5($Password));

  $query = "UPDATE `Users` SET `Password_Hash` = '$Password_Hash' WHERE `Login` = '$Login';";

  mysqli_query($link, $query) or die(mysql_error());

  echo "Success";

?>
