import 'package:flutter/cupertino.dart';
import 'package:flutter_grocery_list/shared/theme_model.dart';

class Settings extends ChangeNotifier{

  double fontSize = 0;
  final ThemeModel themeModel;

  Settings(this.themeModel);

  increment(){
    fontSize += 1.0;

    notifyListeners();
  }

}