import 'package:flutter/cupertino.dart';
import 'package:flutter_grocery_list/shared/theme_model.dart';

class Settings extends ChangeNotifier{
  // Atributos da classe
  double _fontSize = 10;
  final ThemeModel themeModel;
  int option = 1;
  double _defaultFontSize = 10.5;

  // Construtor da classe
  Settings(this.themeModel);

  // Metodos da classe
  increment(){
    fontSize += 10.0;
    notifyListeners();
  }

  handleRadioValueChange(int value, BuildContext context) {
    option = value;

    switch (value) {
      case 1: //System
        option = value;
         if(MediaQuery.platformBrightnessOf(context) == Brightness.light) {
          themeModel.isContrast = false;
          themeModel.isDarkTheme = false;
         }else{
          themeModel.isContrast = false;
          themeModel.isDarkTheme = true;
         }
        break;
      case 2: //Light
        option = value;
        themeModel.isContrast = false;
        themeModel.isDarkTheme = false;
        break;
      case 3: //Dark
        option = value;
        themeModel.isContrast = false;
        themeModel.isDarkTheme = true;
        break;
      case 4: //Contrast
        option = value;
        themeModel.isContrast = true;
        themeModel.isDarkTheme = false;
    }
    notifyListeners();
  }

  double get fontSize => _fontSize;

  set fontSize(double value) {
    _fontSize = value;
    notifyListeners();
  }

  double get defaultFontSize => _defaultFontSize;

  set defaultFontSize(double value) {
    _defaultFontSize = value;
  }

}