import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/settings.dart';
import 'package:get_it/get_it.dart';

/// Enumerador para o tema da aplicacao
enum ThemeEnum {lightTheme, darkTheme, highContrast, system }

class ThemeModel extends ChangeNotifier {
  // Atributos da classe
  ThemeEnum _appTheme = ThemeEnum.lightTheme;

  // Metodos da classe
  changeTheme({ThemeEnum theme, Brightness brightness}) {
    if (theme == ThemeEnum.system) {
      // TODO: Implementar a captura do alto contraste pelo sistema.
      //(MediaQuery.of(context).highContrast == true)
      (brightness == Brightness.light)
          ? appTheme = ThemeEnum.lightTheme
          : appTheme = ThemeEnum.darkTheme;
      return;
    }
    appTheme = theme;
  }

  // Gets e Sets
  ThemeEnum get appTheme => _appTheme;

  set appTheme(ThemeEnum value) {
    _appTheme = value;

    notifyListeners();
  }
}

class Themes {
  static ThemeData getAppTheme() {
    final settings = GetIt.I<Settings>();

    switch (settings.themeModel.appTheme) {
      case ThemeEnum.darkTheme:
        return Themes.darkTheme();
        break;
      case ThemeEnum.highContrast:
        return Themes.highContrastTheme();
        break;
      default:
        return Themes.defaultTheme();
        break;
    }
  }

  static defaultTheme() {
    final settings = GetIt.I<Settings>();

    return ThemeData(
      appBarTheme: AppBarTheme(
        textTheme: TextTheme(
          headline6: TextStyle(
              fontSize: (settings.fontSize),
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
              fontSize: (settings.fontSize),
              color: Colors.black87,
              fontWeight: FontWeight.bold),
          bodyText2: TextStyle(
              fontSize: (settings.fontSize),
              color: Colors.black87,
              fontWeight: FontWeight.bold),
          subtitle1: TextStyle(
              fontSize: (settings.fontSize),
              color: Colors.black87,
              fontWeight: FontWeight.bold),
          subtitle2: TextStyle(
            fontSize: (settings.fontSize - 5),
            color: Colors.black54,
          ),
          caption: TextStyle(
            fontSize: (settings.fontSize - 5),
            color: Colors.black54,
          )),
    );
  }

  static darkTheme() {
    final settings = GetIt.I<Settings>();

    return ThemeData(
      appBarTheme: AppBarTheme(
        textTheme: TextTheme(
          headline6: TextStyle(
              fontSize: (settings.fontSize),
              color: Colors.white,
              fontWeight: FontWeight.bold),
        ),
        color: Colors.blue,
      ),
      brightness: Brightness.dark,
      cardColor: Colors.white60,
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.blue[900],
        shape: RoundedRectangleBorder(),
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: TextTheme(
          headline5: TextStyle(color: Colors.green),
          headline6: TextStyle(
              fontSize: (settings.fontSize),
              color: Colors.white,
              fontWeight: FontWeight.bold),
          bodyText2: TextStyle(
              fontSize: (settings.fontSize),
              color: Colors.white,
              fontWeight: FontWeight.bold),
          subtitle1: TextStyle(
              fontSize: (settings.fontSize),
              color: Colors.white,
              fontWeight: FontWeight.bold),
          subtitle2: TextStyle(
            fontSize: (settings.fontSize - 5),
            color: Colors.white70,
          ),
          caption: TextStyle(
            fontSize: (settings.fontSize - 5),
            color: Colors.white60,
          )),
    );
  }

  static highContrastTheme() {
    final settings = GetIt.I<Settings>();

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
                fontSize: (settings.fontSize),
                color: Colors.black87,
                fontWeight: FontWeight.bold),
            bodyText2: TextStyle(
                fontSize: (settings.fontSize),
                color: Colors.white,
                fontWeight: FontWeight.bold),
            subtitle1: TextStyle(
                fontSize: (settings.fontSize),
                color: Colors.white,
                fontWeight: FontWeight.bold),
            subtitle2: TextStyle(
              fontSize: (settings.fontSize - 5),
              color: Colors.white70,
            ),
            caption: TextStyle(
              fontSize: (settings.fontSize - 5),
              color: Colors.white60,
            )));
  }
}
