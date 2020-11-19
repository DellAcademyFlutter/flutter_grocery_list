import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/settings.dart';
import 'package:get_it/get_it.dart';

class ThemeModel extends ChangeNotifier{
  bool _isDarkTheme = false;
  bool _isContrast = false;

  bool get isContrast => _isContrast;

  set isContrast(bool value) {
    _isContrast = value;
    notifyListeners();
  }

  bool get isDarkTheme => _isDarkTheme;

  set isDarkTheme(bool value) {
    _isDarkTheme = value;

    notifyListeners();
  }

  verifytheme(String theme){
    if(isContrast == true || theme == 'highontrast'){
      return Themes.highContrastTheme();
    }

    if(isDarkTheme == true|| theme == 'isDarkTheme'){
      isContrast = false;
      return Themes.darkTheme();
    }

    if(isDarkTheme == false|| theme == 'defaultTheme'){
      isContrast = false;
      return Themes.defaultTheme();
    }

    notifyListeners();
  }

  changeTheme(){
    isDarkTheme = !isDarkTheme;
  }

  changeThemeContrast(){
    isContrast = !isContrast;
  }
}

class Themes {

  static defaultTheme() {
    final settings = GetIt.I<Settings>();

    return ThemeData(
        brightness: Brightness.light,
        cardColor: Colors.grey[300],

        buttonTheme: ButtonThemeData(
            buttonColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(),
            textTheme: ButtonTextTheme.primary,
        ),

        textTheme: TextTheme(
            headline5 : TextStyle(color: Colors.green),
            headline6: TextStyle(
                fontSize: (10 + settings.fontSize),
                color: Colors.black87,
                fontWeight: FontWeight.bold),
            bodyText2: TextStyle(
                fontSize: (10 + settings.fontSize),
                color: Colors.black87,
                fontWeight: FontWeight.bold)));
  }

  static darkTheme() {
    final settings = GetIt.I<Settings>();

    return ThemeData(
        brightness: Brightness.dark,
        cardColor: Colors.white24,

        buttonTheme: ButtonThemeData(
          buttonColor: Colors.white24,
          shape: RoundedRectangleBorder(),
          textTheme: ButtonTextTheme.primary,
        ),

        textTheme: TextTheme(
            headline5 : TextStyle(color: Colors.red),
            headline6: TextStyle(
                fontSize: (10.5 + settings.fontSize),
                color: Colors.yellow,
                fontWeight: FontWeight.bold),
            bodyText2: TextStyle(
                fontSize: (10.5 + settings.fontSize),
                color: Colors.yellow,
                fontWeight: FontWeight.bold)));
  }

  static highContrastTheme() {
    final settings = GetIt.I<Settings>();

    return ThemeData(
        brightness: Brightness.dark,
        cardColor: Colors.black54,

        buttonTheme: ButtonThemeData(
          buttonColor: Colors.yellow,
          shape: RoundedRectangleBorder(),
          textTheme: ButtonTextTheme.primary,
        ),

        textTheme: TextTheme(
            headline5 : TextStyle(color: Colors.green),
            headline6: TextStyle(
                fontSize: (10.5 + settings.fontSize),
                color: Colors.black87,
                fontWeight: FontWeight.bold),
            bodyText2: TextStyle(
                fontSize: (10.5 + settings.fontSize),
                color: Colors.white,
                fontWeight: FontWeight.bold)));
  }
}