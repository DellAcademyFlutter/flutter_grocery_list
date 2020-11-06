import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Viewers/home_page.dart';

void main() {
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
      home: MyHomePage(title: 'Lista de Compras'),
    );
  }
}