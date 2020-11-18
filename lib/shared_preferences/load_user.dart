import 'package:flutter_grocery_list/Models/user.dart';
import 'package:flutter_grocery_list/shared_preferences/shared_prefs.dart';
import 'package:get_it/get_it.dart';

class LoadUser {
  /// Este metodo carrega o usuario [User].
  static load() async {
    SharedPrefs.contains("loggedUser").then((value) {
      final loggedUser = GetIt.I<User>();

      if (value) {
        SharedPrefs.read("loggedUser").then((value) {
          loggedUser.name = value;
        });
      } else {
        loggedUser.name = null;
      }
    });
  }
}
