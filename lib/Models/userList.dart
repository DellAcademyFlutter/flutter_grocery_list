import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_grocery_list/Models/user.dart';

class UserList extends ChangeNotifier {
  List<User> userList = List();

  addUser(User user){
    userList.add(user);
  }

  removeallUsers(){
   userList.clear();
  }
}