import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/item.dart';
import 'package:flutter_grocery_list/Viewers/home_page.dart';
import 'package:flutter_grocery_list/shared/theme_model.dart';
import 'package:get_it/get_it.dart';
import 'Models/cart.dart';

void main() {

  GetIt.I.registerSingleton<Item>(Item());
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
            // theme: ThemeData(
            //     // Tema padrao
            //     brightness: GetIt.I<ThemeModel>().isDarkTheme
            //         ? Brightness.dark
            //         : Brightness.light,
            //     primarySwatch: Colors.green,
            //     visualDensity: VisualDensity.adaptivePlatformDensity,
            //     textTheme: TextTheme(bodyText2: TextStyle(fontSize: 30))),
            theme: GetIt.I<ThemeModel>().isDarkTheme ? Temas.highContrastTheme()
            : Temas.defaultTheme(),
            debugShowCheckedModeBanner: false,
            home: MyHomePage(title: 'Lista de Compras'),
          );
        });
  }
}

class Temas {
  static defaultTheme() {
    return ThemeData(
        cardColor: Colors.white,
        textTheme: TextTheme(
            bodyText2: TextStyle(
                fontSize: 50,
                color: Colors.pink,
                fontWeight: FontWeight.bold)));
  }

  static highContrastTheme() {
    return ThemeData(
      cardColor: Colors.black26,
        textTheme: TextTheme(
            bodyText2: TextStyle(
                fontSize: 50,
                color: Colors.yellow)));
  }
}
