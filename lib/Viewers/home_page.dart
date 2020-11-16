import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Models/user.dart';
import 'package:flutter_grocery_list/Viewers/items_pages.dart';
import 'package:flutter_grocery_list/Viewers/profile_page.dart';
import 'package:flutter_grocery_list/shared/theme_model.dart';
import 'package:flutter_grocery_list/shared_preferences/load_items.dart';
import 'package:flutter_grocery_list/shared_preferences/shared_prefs.dart';
import 'package:get_it/get_it.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final cart = GetIt.I<Cart>();
  final loggedUser = GetIt.I<User>();
  Color appBarColor;

  @override
  void initState() {
    super.initState();
    appBarColor = Colors.blue;
    LoadItems.load(); // carregar seu carrinho
    //SharedPrefs.removeAll();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: cart,
        builder: (context, w) {
          return DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  isScrollable: false,
                  tabs: [
                    Tab(icon: Icon(Icons.done_outline)),
                    Tab(icon: Icon(Icons.done_all)),
                    Tab(icon: Icon(Icons.person_outline)),
                  ],
                ),
                title: Row(
                  children: <Widget>[
                    Column(
                      children: [
                        Text("Lista de compras de ${loggedUser?.name == null ? "nulo" : loggedUser.name}",
                        style: TextStyle(fontSize: 20.0),),
                      ],
                    ),
                  ],
                ),
                backgroundColor:
                cart.hasSelectedItems() ? Colors.blue[900] : Colors.blue,
                actions: <Widget>[
                  cart.hasSelectedItems()
                      ? Row(
                    children: [
                      CheckSelectedItems(),
                      SizedBox(width: 20),
                      RemoveSelectedItems(),
                    ],
                  )
                      : SizedBox.shrink(),
                  SizedBox(
                    width: 20,
                  ),
                ],
              ),
              body: TabBarView(
                children: <Widget>[
                  ItemsPage(doneItems: false),
                  ItemsPage(doneItems: true),
                  ProfilePage(),
                ],
              ),
            ),
          );
        });
  }
}

/// Este widget exibe uma label para o [ThemeModel]
// ignore: non_constant_identifier_names
Widget ThemeLabel() {
  return FutureBuilder(
    future: SharedPrefs.read("isDarkTheme"),
    initialData: "---",
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return null; //Text("${snapshot.data}");
      } else {
        return null; //CircularProgressIndicator();
      }
    },
  );
}


