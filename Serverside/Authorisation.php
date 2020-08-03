<?php

  $link = mysqli_connect('127.0.0.1', 'root', '95159514','FirstPass');

  if (!$link) {
    echo 'Не могу соединиться с БД. Код ошибки: ' . mysqli_connect_errno() . ', ошибка: ' . mysqli_connect_error();
    exit;
  }

  $Login = $_POST['a'];
  $Password = $_POST['b'];
  $Secure_Key = $_POST['c'];
  $Password_Hash = md5(md5($Password));
  $Secure_Key_Hash = md5(md5($Secure_Key));

  $result = $link->query('SELECT * FROM `Users` WHERE `Login` = '."'$Login'".';');
  if ($result->num_rows <= 0) {
    echo "ErrorUser";
    return;
  }
  else {
    $result = $link->query('SELECT * FROM `Users` WHERE `Login` = '."'$Login'".' AND `Password_Hash` = '."'$Password_Hash'".';');
    if ($result->num_rows <= 0) {
      echo "ErrorPassword";
      return;
    }
    else {
      $result = $link->query('SELECT * FROM `Users` WHERE `Login` = '."'$Login'".' AND `Password_Hash` = '."'$Password_Hash'".' AND `Secure_Key_Hash` = '."'$Secure_Key_Hash'".';');
      if ($result->num_rows <= 0) {
        echo "ErrorSecureKey";
        return;
      }
      else {
        echo "AuthSucceed";
      }
    }
  }
//'."'$Login'".'
?>
