import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/user.dart';
import 'package:flutter_grocery_list/shared_preferences/load_items.dart';
import 'package:flutter_grocery_list/shared_preferences/shared_prefs.dart';
import 'package:get_it/get_it.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  TextEditingController nameController = TextEditingController(text: '');
  String userName;
  final loggedUser = GetIt.I<User>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Tela de login'),
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
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: nameController,
                    onChanged: (valor) =>
                        setState(() => userName = valor.trim().toLowerCase()),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: Text('Login'),
                      onPressed: () {
                        loggedUser.name = userName;
                        SharedPrefs.save("loggedUser", userName);
                        SharedPrefs.contains(userName).then((value) {
                          if (!value){
                            // TODO: ajeitar ID zero.
                            User user = User(id: 0, name: userName);
                            SharedPrefs.save(userName, jsonEncode(user.toJson()));
                          }
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyHomePage(title: 'Compras')),
                        );
                      },
                    )),
              ],
            )));
  }
}
