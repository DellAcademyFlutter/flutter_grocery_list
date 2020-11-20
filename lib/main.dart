import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/user.dart';
import 'package:flutter_grocery_list/shared/theme_model.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:get_it/get_it.dart';
import 'Models/cart.dart';
import 'Models/settings.dart';
import 'Viewers/add_item_page.dart';
import 'Viewers/home_page.dart';
import 'Viewers/login_page.dart';
import 'local/shared_prefs.dart';
import 'shared/theme_model.dart';

void main() {
  //Singletons
  GetIt.I.registerSingleton<Cart>(Cart());
  GetIt.I.registerSingleton<ThemeModel>(ThemeModel());
  GetIt.I.registerSingleton<Settings>(Settings(GetIt.I<ThemeModel>()));
  GetIt.I.registerSingleton<User>(User());

  //Inicializando Stetho
  Stetho.initialize();

  //Execucao do app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final settings = GetIt.I<Settings>();
  final loggedUser = GetIt.I<User>();
  final cartList = GetIt.I<Cart>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: loggedUser,
        builder: (context, w) {
          return AnimatedBuilder(
              animation: settings.themeModel,
              builder: (context, w) {
                return MaterialApp(
                    title: 'Flutter Demo',
                    theme: settings.themeModel.verifytheme('defaultTheme'),
                    darkTheme: settings.themeModel.verifytheme('isDarkTheme'),
                    debugShowCheckedModeBanner: false,
                    builder: (context, child) {
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
                      // return MediaQuery(
                      //     data: MediaQueryData(
                      //       textScaleFactor: 1.0
                      //     ),
                      //     child: child);
                    },
                    initialRoute: loggedUser.name != null ? MyHomePage.routeName: LoginPage.routeName,
                    routes: {
                      LoginPage.routeName: (context) =>
                          loggedUser.name != null ? MyHomePage() : LoginPage(),
                      MyHomePage.routeName: (context) => MyHomePage(),
                    },
                    onGenerateRoute: (settings) {
                      switch (settings.name) {
                        case CreateEditItemPage.routeName:
                          {
                            final CreateEditItemPageArguments args = settings.arguments;
                            return MaterialPageRoute(
                              builder: (context) {
                                return CreateEditItemPage(
                                  item: args.item,
                                );
                              },
                            );
                          }
                          break;
                        default:
                          assert(false, 'Need to implement ${settings.name}');
                          return null;
                      }
                    });
              });
        });
  }
}
