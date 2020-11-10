import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Viewers/home_page.dart';
import 'package:flutter_grocery_list/local/shared_prefs.dart';
import 'package:flutter_grocery_list/shared/theme_model.dart';
import 'package:get_it/get_it.dart';
import 'Models/cart.dart';

void main() {
  GetIt.I.registerSingleton<Cart>(Cart()); // Um Singleton de [Cart].
  GetIt.I.registerSingleton<ThemeModel>(ThemeModel());

  // Execucao do aplicativo
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: GetIt.I<ThemeModel>(),
        builder: (context, w) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: GetIt.I<ThemeModel>().isDarkTheme ? Themes.highContrastTheme()
            : Themes.defaultTheme(),
            debugShowCheckedModeBanner: false,
            home: MyHomePage(title: 'Lista de Compras'),
            builder: (context, child){
              final themeModel = GetIt.I<ThemeModel>();

              SharedPrefs.read("isDarkTheme").then((value) {
                themeModel.isDarkTheme = value == "true" ? true : false;
              });

              return child;
            },
          );
        });
  }
}
