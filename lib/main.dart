import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/user.dart';
import 'package:flutter_grocery_list/Models/userList.dart';
import 'package:flutter_grocery_list/Viewers/home_page.dart';
import 'package:flutter_grocery_list/Viewers/login_page.dart';
import 'package:flutter_grocery_list/shared/theme_model.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:get_it/get_it.dart';
import 'Models/cart.dart';
import 'Models/settings.dart';
import 'local/shared_prefs.dart';

// Versao: Antonio Honorato Moreira Guedes
// Equipe: Antonio Honorato (Mentorado) / Elias Cicero (Mentorado)  / Israel Barbosa (Mentor)
// Projeto - Groccery_List my Cart

void main() {
  GetIt.I.registerSingleton<Cart>(Cart()); // Um Singleton de [Cart].
  GetIt.I
      .registerSingleton<ThemeModel>(ThemeModel()); // Um singleton [ThemeModel]
  GetIt.I.registerSingleton<Settings>(
      Settings(GetIt.I<ThemeModel>())); // Um singleton [ThemeModel]
  GetIt.I.registerSingleton<User>(User()); // Um singleton de User
  GetIt.I.registerSingleton<UserList>(UserList()); // Um singleton de User
  Stetho.initialize();

  // Execucao do aplicativo
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final themeModel = GetIt.I<ThemeModel>();
  final settings = GetIt.I<Settings>();
  final loggedUser = GetIt.I<User>();
  final cartList = GetIt.I<Cart>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: settings.themeModel,
        builder: (context, w) {
          return AnimatedBuilder(
              animation: settings,
              builder: (context, w) {
                return MaterialApp(
                  title: 'Flutter Demo',
                  theme: settings.themeModel.isDarkTheme
                      ? Themes.highContrastTheme()
                      : Themes.defaultTheme(),
                  debugShowCheckedModeBanner: false,
                  home: loggedUser.name != null
                      ? MyHomePage(title: 'Carrinho')
                      : LoginPage(),
                  builder: (context, child) {

                    //SharedPrefs.read("isDarkTheme").then((value) {
                    //  themeModel.isDarkTheme = (value == "true");
                    //});

                    SharedPrefs.contains("loggedUser").then((value) {
                      if (value) {
                        SharedPrefs.read("loggedUser").then((value) {
                          loggedUser.name = value;
                        });
                      } else {
                        loggedUser.name = null;
                      }
                    });
                    return child;
                  },
                );
              });
        });
  }
}


