<?php

  $link = mysqli_connect('127.0.0.1', 'root', '95159514','FirstPass');

  if (!$link) {
    echo 'Не могу соединиться с БД. Код ошибки: ' . mysqli_connect_errno() . ', ошибка: ' . mysqli_connect_error();
    exit;
  }

  $Login = $_POST['a'];
  $Password = $_POST['b'];

  $result = $link->query('SELECT * FROM `Users` WHERE `Login` = '."'$Login'".';');
  if ($result->num_rows > 0) {
    echo "AlreadyUsed";
    return;
  }
  else {
    $permitted_chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    $Secure_Key = substr(str_shuffle($permitted_chars), 0, 4).'-'.substr(str_shuffle($permitted_chars), 0, 5).'-'.substr(str_shuffle($permitted_chars), 0, 6).'-'.substr(str_shuffle($permitted_chars), 0, 3);
    $Password_Hash = md5(md5($Password));
    $Secure_Key_Hash = md5(md5($Secure_Key));

  $query = "INSERT INTO `Users` (`Login`, `Password_Hash`, `Secure_Key_Hash`) VALUES ('$Login','$Password_Hash','$Secure_Key_Hash');";
  mysqli_query($link, $query) or die(mysql_error());

  $query = "CREATE TABLE `FirstPass`.`"."$Login"."` ( `ID` INT(11) NOT NULL AUTO_INCREMENT , `Name` VARCHAR(56) NOT NULL , `Login` VARCHAR(56) NULL , `Password` VARCHAR(256) NULL , `Website` VARCHAR(256) NULL , `Note` TEXT NULL , `isRemoved` BOOLEAN NOT NULL , PRIMARY KEY (`ID`)) ENGINE = InnoDB;";
  mysqli_query($link, $query) or die(mysql_error());

  echo $Secure_Key;

  }
?>
