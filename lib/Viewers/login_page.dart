import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Models/item.dart';
import 'package:flutter_grocery_list/Models/user.dart';
import 'package:flutter_grocery_list/local/shared_prefs.dart';
import 'package:get_it/get_it.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/";

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  final loggedUser = GetIt.I<User>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('Login')),
          backgroundColor: Colors.amber,
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Defina seu perfil',
                      style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Nome de usuário',
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.black,
                      color: Colors.amber,
                      child: Text('Login'),
                      onPressed: () {
                        loggedUser.name = nameController.text;
                        SharedPrefs.save("loggedUser", nameController.text);
                        //importItemToLocalStorage(nameController.text);
                        Navigator.of(context)
                            .pushReplacementNamed(MyHomePage.routeName);
                      },
                    )),
              ],
            )));
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
            cartlist.addItem(item.id, item.user, item.name, item.value,
                item.amount, item.isDone);
          });
        }
      }
    });
  }

  /// Verifica se o usuário já possui algum carrinho salvo
  removeAllUsers(String userName) async {
    // Ler todas as keys em Local Storage.
    SharedPrefs.getKeysCollection().then((value) {
      final cartlist = GetIt.I<Cart>();

      String key;

      for (int i = 0; i < value.length; i++) {
        key = value.elementAt(i);

        if (!key.contains('item')) {
          SharedPrefs.read(key).then((value) {
            Item item = Item.fromJson(jsonDecode(value));
            cartlist.addItem(item.id, item.user, item.name, item.value,
                item.amount, item.isDone);
          });
        }
      }
    });
  }
}
