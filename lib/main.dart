import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/item.dart';
import 'package:flutter_grocery_list/Viewers/home_page.dart';
import 'package:get_it/get_it.dart';
import 'Models/cart.dart';

void main() {
  // Injecoes de dependencia
  GetIt.I.registerSingleton<Cart>(Cart()); // Um Singleton de [Cart].

  // Execucao do aplicativo
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData( // Tema padrao
          primarySwatch: Colors.green,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(bodyText2: TextStyle(fontSize: 30))),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Lista de Compras'),
    );
  }
}