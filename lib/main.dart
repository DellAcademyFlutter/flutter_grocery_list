import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/settings.dart';
import 'package:flutter_grocery_list/Viewers/create_item_page.dart';
import 'package:flutter_grocery_list/Viewers/home_page.dart';
import 'package:flutter_grocery_list/shared/theme_model.dart';
import 'package:flutter_grocery_list/shared_preferences/load_user.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:get_it/get_it.dart';
import 'Models/cart.dart';
import 'Models/user.dart';
import 'Viewers/intro_page.dart';
import 'Viewers/login_page.dart';

void main() {
  GetIt.I.registerSingleton<Cart>(Cart()); // Um Singleton de [Cart].
  GetIt.I
      .registerSingleton<ThemeModel>(ThemeModel()); // Um singleton [ThemeModel]
  GetIt.I.registerSingleton<Settings>(
      Settings(GetIt.I<ThemeModel>())); // Um singleton [ThemeModel]
  GetIt.I.registerSingleton<User>(User()); // Um singleton de User
  Stetho.initialize();

  // Execucao do aplicativo
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final themeModel = GetIt.I<ThemeModel>();
  final settings = GetIt.I<Settings>();
  final loggedUser = GetIt.I<User>();

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
                    theme: Themes.getAppTheme(),
                    darkTheme: Themes.darkTheme(),
                    debugShowCheckedModeBanner: false,
                    //initialRoute: LoadingScreen.routeName,
                    routes: {
                      // Rotas sem argumentos. A primeira rota possui o caminho '/'
                      LoadingScreen.routeName: (context) => LoadingScreen(),
                      LoginPage.routeName: (context) => LoginPage(),
                      HomePage.routeName: (context) => HomePage(),
                    },
                    onGenerateRoute: (settings) {
                      // Rotas com argumentos.
                      // Capturar e extrair os argumentos da pagina.
                      switch (settings.name) {
                        case CreateEditItemPage.routeName:
                          {
                            final CreateEditItemPageArguments args =
                                settings.arguments;
                            return MaterialPageRoute(
                              builder: (context) {
                                return CreateEditItemPage(
                                  item: args.item,
                                );
                              },
                            );
                          }
                          break;
                        case LoginPage.routeName:
                          {
                            return MaterialPageRoute(
                              builder: (context) {
                                return loggedUser.name != null
                                    ? HomePage()
                                    : LoginPage();
                              },
                            );
                          }
                          break;
                        default: // Caso precise implementar
                          assert(false,
                              'Falta implementar a rota ${settings.name}');
                          return null;
                      }
                    });
              });
        });
  }
}
