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

  @override
  void initState() {
    super.initState();
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
                          //Text("Compras de ${loggedUser?.name == null ? "nulo" : loggedUser.name}"),
                          Text("Compras de ${ModalRoute
                              .of(context)
                              .settings
                              .arguments
                              .toString()}"),
                        ],
                      ),
                    ],
                  ),
                  backgroundColor: cart.hasSelectedItems()
                      ? Colors.blue[900]
                      : null,
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
                      Text(widget.title),
                      Text(widget.title),
                      Text(widget.title),
                    ]),
              ));
        });
  }

  /// Este widget exibe uma label para o [ThemeModel]
// ignore: non_constant_identifier_names

}