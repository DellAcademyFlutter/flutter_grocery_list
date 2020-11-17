import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Models/settings.dart';
import 'package:get_it/get_it.dart';

class ThemeModel extends ChangeNotifier {
  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;

  set isDarkTheme(bool value) {
    _isDarkTheme = value;

    notifyListeners();
  }

  changeTheme() {
    isDarkTheme = !isDarkTheme;
  }
}

class Themes {
  static defaultTheme() {
    final settings = GetIt.I<Settings>();
    final cart = GetIt.I<Cart>();

    return ThemeData(
      appBarTheme: AppBarTheme(
        textTheme: TextTheme(
          headline6: TextStyle(
              fontSize: (10 + settings.fontSize),
              color: Colors.black87,
              fontWeight: FontWeight.bold),
        ),
        color: Colors.blue,
      ),
      brightness: Brightness.light,
      cardColor: Colors.grey[300],
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(),
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: TextTheme(
          headline5: TextStyle(color: Colors.green),
          headline6: TextStyle(
              fontSize: (10 + settings.fontSize),
              color: Colors.black87,
              fontWeight: FontWeight.bold),
          bodyText2: TextStyle(
              fontSize: (10 + settings.fontSize),
              color: Colors.black87,
              fontWeight: FontWeight.bold),
          subtitle1: TextStyle(
              fontSize: (10 + settings.fontSize),
              color: Colors.black87,
              fontWeight: FontWeight.bold),
          subtitle2: TextStyle(
            fontSize: (10 + settings.fontSize / 2),
            color: Colors.pink,
          )),
    );
  }

  static highContrastTheme() {
    final settings = GetIt.I<Settings>();
    final cart = GetIt.I<Cart>();

    return ThemeData(
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
            headline6: TextStyle(
                fontSize: (10 + settings.fontSize),
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          color: Colors.amber,
        ),
        brightness: Brightness.dark,
        cardColor: Colors.black54,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.yellow,
          shape: RoundedRectangleBorder(),
          textTheme: ButtonTextTheme.primary,
        ),
        textTheme: TextTheme(
            headline5: TextStyle(color: Colors.green),
            headline6: TextStyle(
                fontSize: (10 + settings.fontSize),
                color: Colors.black87,
                fontWeight: FontWeight.bold),
            bodyText2: TextStyle(
                fontSize: (10 + settings.fontSize),
                color: Colors.white,
                fontWeight: FontWeight.bold),
            subtitle1: TextStyle(
                fontSize: (10 + settings.fontSize),
                color: Colors.white,
                fontWeight: FontWeight.bold),
            subtitle2: TextStyle(
              fontSize: (10 + settings.fontSize / 2),
              color: Colors.pink,
            )));
  }
}
