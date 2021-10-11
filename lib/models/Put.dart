/*
Local errors
1 - Неверная роль
2 - Не существет номер телефона
3 - Неверный код подтверждения
4 - Неверный токен
5 - Недостаточно параметров
6 - Неверный идентификатор ключа шифрования
7 - Не существует приватный ключ для идентификатора
8 - Не существует код подтверждения
9 - Нет имени
10 - Недостаточно прав доступа
11 - Категория не существует
12 - Не введены параметры для изменения
13 - Товар не существует
14 - Некорректный набор параметров
15 - Параметры не прошли валидацию
16 - Недостаточно средств на кошельке
17 - Бизнес не существует
1000 - ошибка синтаксиса
 */




import 'package:flutter/material.dart';

class Put {
  int error;
  bool localError;
  String mess;
  Put({
    @required this.error,
    @required this.mess,
    @required this.localError
  });
  factory Put.fromJson(Map<String,dynamic> json){
    print("put decode ${json['code']}");
    return Put(error: json['code'], localError: false, mess: json['mess']);
  }
}