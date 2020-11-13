import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier{

  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  set isDarkTheme(bool value) {
    _isDarkTheme = value;

    notifyListeners();
  }

  changeTheme(){
    isDarkTheme = !isDarkTheme;
  }
}

class Themes {
  static defaultTheme() {
    return ThemeData(
        cardColor: Colors.white,
        textTheme: TextTheme(
            bodyText1: TextStyle(
                fontSize: 30,
                color: Colors.red,
                fontWeight: FontWeight.bold),

            bodyText2: TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.bold)));
  }

  static highContrastTheme() {
    return ThemeData(
      primaryColor: Colors.green,
        cardColor: Colors.black26,
        textTheme: TextTheme(
          headline1:    TextStyle(
            fontSize: 40,
            color: Colors.yellow),

            bodyText2: TextStyle(
                fontSize: 50,
                color: Colors.yellow)));
  }
}