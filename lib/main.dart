import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Viewers/home_page.dart';
import 'package:get_it/get_it.dart';

void main() {
  GetIt.I.registerSingleton<Cart>(Cart());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData( // Tema padrao
          primarySwatch: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          textTheme: TextTheme(bodyText2: TextStyle(fontSize: 30))),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Carrinho:'),
    );
  }
}