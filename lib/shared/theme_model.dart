import 'package:flutter/cupertino.dart';

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