import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Models/item.dart';
import 'package:flutter_grocery_list/Models/user.dart';
import 'package:flutter_grocery_list/Viewers/items_pages.dart';
import 'package:flutter_grocery_list/Viewers/profile_page.dart';
import 'package:flutter_grocery_list/shared/theme_model.dart';
import 'package:flutter_grocery_list/local/shared_prefs.dart';
import 'package:get_it/get_it.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  static const routeName = "/home";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final cart = GetIt.I<Cart>();
  final loggedUser = GetIt.I<User>();

  @override
  void initState() {
    importItemToLocalStorage(loggedUser.name);
    super.initState();
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
                      Tab(icon: Icon(Icons.remove_shopping_cart)),
                      Tab(icon: Icon(Icons.add_shopping_cart)),
                      Tab(icon: Icon(Icons.account_circle)),
                    ],
                  ),
                  title: Row(
                    children: <Widget>[
                      Column(
                        children: [
                          Text("Carrinho de: ${loggedUser.name}",
                            style: TextStyle(color: Colors.black),),
                        ],
                      ),
                    ],
                  ),
                  backgroundColor:
                  cart.hasSelectedItems() ? Colors.green : Colors.amber,
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

/// Verifica se o usuário já possui algum carrinho salvo
importItemToLocalStorage(String userName) async {
  // Ler todas as keys em Local Storage.
  SharedPrefs.getKeysCollection().then((value) {
    final cartlist = GetIt.I<Cart>();

    String key;

    for (int i = 0; i < value.length; i++) {
      key = value.elementAt(i);

      if (key.contains(userName)) {
        SharedPrefs.read(key).then((value) {
          Item item = Item.fromJson(jsonDecode(value));
          cartlist.addItem(id: item.id, userName: item.user, name: item.name, value: item.value,
              qtt: item.amount, isDone: item.isDone);
        });
      }
    }
  });
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



