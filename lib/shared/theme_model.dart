import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/settings.dart';
import 'package:flutter_grocery_list/shared_preferences/shared_prefs.dart';
import 'package:get_it/get_it.dart';

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
final settings = GetIt.I<Settings>();

class Themes {
  static defaultTheme() {
    return ThemeData(
      brightness: Brightness.light,
        cardColor: Colors.white,
        textTheme: TextTheme(
            headline6: TextStyle(
                fontSize: (10 + settings.fontSize),
                color: Colors.green,
                fontWeight: FontWeight.bold),
            bodyText2: TextStyle(
                fontSize: (10 + settings.fontSize),
                color: Colors.pink,
                fontWeight: FontWeight.bold)));
  }

  static highContrastTheme() {
    return ThemeData(
        brightness: Brightness.dark,
        cardColor: Colors.black26,
        textTheme: TextTheme(
            bodyText2: TextStyle(
                fontSize: 70,
                color: Colors.yellow)));
  }
}