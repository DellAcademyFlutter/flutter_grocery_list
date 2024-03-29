import 'package:flutter/cupertino.dart';
import 'package:flutter_grocery_list/shared/theme_model.dart';

class Settings extends ChangeNotifier{
  // Atributos da classe
  double _fontSize = 19.5;
  double _defaultSize = 19.5;

  final ThemeModel themeModel;

  // Construtor da classe
  Settings(this.themeModel);

  // Metodos da classe
  increment(){
    fontSize += 10.0;
    notifyListeners();
  }

  // Gets e Sets
  double get fontSize => _fontSize;

  set fontSize(double value) {
    _fontSize = value;
    notifyListeners();
  }

  double get defaultSize => _defaultSize;

  set defaultSize(double value) {
    _defaultSize = value;
  }
}