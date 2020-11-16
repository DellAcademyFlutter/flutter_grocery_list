import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Viewers/home_page.dart';
import 'package:flutter_grocery_list/shared/theme_model.dart';
import 'package:flutter_grocery_list/shared_preferences/load_user.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:get_it/get_it.dart';
import 'Models/cart.dart';
import 'Models/user.dart';
import 'Viewers/login_page.dart';

void main() {
  GetIt.I.registerSingleton<Cart>(Cart()); // Um Singleton de [Cart].
  GetIt.I.registerSingleton<ThemeModel>(ThemeModel()); // Um singleton [ThemeModel]
  GetIt.I.registerSingleton<User>(User()); // Um singleton de User
  Stetho.initialize();

  // Execucao do aplicativo
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final themeModel = GetIt.I<ThemeModel>();
  final loggedUser = GetIt.I<User>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: themeModel,
        builder: (context, w) {
          return MaterialApp(
            title: 'Flutter Demo',
            home:  loggedUser.name != null ? MyHomePage(title: 'Compras') : LoginPage(),
            theme: themeModel.isDarkTheme
                ? Themes.highContrastTheme()
                : Themes.defaultTheme(),
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              LoadUser.load(); // Carrega o usuario
              return child;
            },
          );
        });
  }
}
