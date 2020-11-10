import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/local/shared_prefs.dart';

class ThemeModel extends ChangeNotifier{

  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  set isDarkTheme(bool value) {
    _isDarkTheme = value;

    SharedPrefs.save("isDarkTheme", value.toString());
    notifyListeners();
  }

  changeTheme(){
    isDarkTheme = !isDarkTheme;
  }
}

class Themes {
  static defaultTheme() {
    return ThemeData(
        scaffoldBackgroundColor: Colors.brown[200],
        cardColor: Colors.white,
        textTheme: TextTheme(
            bodyText2: TextStyle(
                fontSize: 50,
                color: Colors.pink,
                fontWeight: FontWeight.bold)));
  }

  static highContrastTheme() {
    return ThemeData(
        scaffoldBackgroundColor: Colors.pink[500],
        cardColor: Colors.black26,
        textTheme: TextTheme(
            bodyText2: TextStyle(
                fontSize: 50,
                color: Colors.yellow)));
  }
}