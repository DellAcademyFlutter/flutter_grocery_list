import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Models/item.dart';
import 'package:flutter_grocery_list/Models/user.dart';
import 'package:flutter_grocery_list/local/shared_prefs.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/";

  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<LoginPage> {
  TextEditingController nameController = TextEditingController();
  final loggedUser = GetIt.I<User>();
  String userName;
  bool isActionSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Login')),
        backgroundColor: Colors.amber,
      ),
      body: Stack(
          // Empilha widgets
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            Positioned(
              bottom: MediaQuery.of(context).size.height / 2,
              child: AnimatedOpacity(
                curve: Curves.easeInOutCirc,
                opacity: !isActionSuccess ? 0.0 : 1.0,
                duration: Duration(milliseconds: 1000),
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.shopping_cart,
                        size: 120,
                        color: Colors.amberAccent,
                      ),
                      Text("Carregando o carrinho de ${nameController.text}"),
                      SizedBox(height: 20),
                      CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.amber),
                      )
                    ],
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              curve: Curves.bounceIn,
              opacity: isActionSuccess ? 0 : 1.0,
              duration: Duration(milliseconds: 0),
              child: Padding(
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
                        onChanged: (valor) =>
                            setState(() => userName = valor.trim().toLowerCase()),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Digite o seu perfil',
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
                          child: Text('Entrar'),
                          onPressed: () {
                            removeFocus(context: context);
                            isActionSuccess = true;
                            loggedUser.name = userName;
                            saveUser(nameController.text);
                            SharedPrefs.save("loggedUser", userName);
                            Future.delayed(Duration(milliseconds: 1500), () {
                              Navigator.of(context)
                                  .pushReplacementNamed(MyHomePage.routeName);
                            });
                          },
                        )),
                  ],
                ),
              ),
            ),
          ]),
    );
  }
}

saveUser(String name) {
  SharedPrefs.save("${name}", '${name}');
}

/// Este metodo remove o focus de um widget.
removeFocus({BuildContext context}) {
  FocusScopeNode currentFocus = FocusScope.of(context);

  // Remove o focus do widget atual
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}
