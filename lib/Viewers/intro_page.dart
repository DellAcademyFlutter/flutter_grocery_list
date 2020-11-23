import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_grocery_list/Models/user.dart';
import 'package:flutter_grocery_list/Viewers/login_page.dart';
import 'package:flutter_grocery_list/shared_preferences/load_user.dart';
import 'package:get_it/get_it.dart';

class LoadingScreen extends StatefulWidget {
  static const routeName = "/";

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();

    // Executa uma funcao uma unica vez quando o layout eh renderizado.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      runInitTasks(context); // initState aceita o context
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Grocery app'),
              SizedBox(height: 20,),
              Container(child: Image.network(
                  'https://static.vecteezy.com/system/resources/previews/000/472/422/non_2x/shopping-supermarket-cart-with-grocery-pictogram-vector.jpg')),
              SizedBox(height: 20,),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                backgroundColor: Colors.grey,
              ),
              Expanded(child: Text('Carregando...',)),
            ],
          ),
        ),
      ),
    );
  }
}

Future runInitTasks(BuildContext context) async {
  final loggedUser = GetIt.I<User>();
  await LoadUser.load();
  Timer(Duration(seconds: 2), () {
    Navigator.pushReplacementNamed(context, LoginPage.routeName);
  });
}

