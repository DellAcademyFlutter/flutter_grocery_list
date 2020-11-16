import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/shared_preferences/shared_prefs.dart';

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
            bodyText2: TextStyle(
                fontSize: 50,
                color: Colors.pink,
                fontWeight: FontWeight.bold)));
  }

  static highContrastTheme() {
    return ThemeData(
        cardColor: Colors.black26,
        textTheme: TextTheme(
            bodyText2: TextStyle(
                fontSize: 50,
                color: Colors.yellow)));
  }
}