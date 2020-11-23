import 'dart:convert';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Models/item.dart';
import 'package:flutter_grocery_list/Models/user.dart';
import 'package:flutter_grocery_list/shared_preferences/shared_prefs.dart';
import 'package:get_it/get_it.dart';

class LoadItems {

  /// Este metodo carrega os items do usuario [User] logado no sistema.
  static load() async {

    // Ler todas as keys em Local Storage.
    SharedPrefs.getAllKeys().then((value) {
      final cart = GetIt.I<Cart>();
      final loggedUser = GetIt.I<User>();
      String key;
      String loggedUserId;

      for (int i = 0; i < value.length; i++) {
        key = value.elementAt(i);
        loggedUserId = loggedUser.name;

        // Se a key for do tipo item, ela contem a string item.
        if (key.contains("item")) {
          SharedPrefs.read(key).then((value) {
            Item item = Item.fromJson(json: jsonDecode(value));
            if (item.fqUserId == loggedUserId) {
              cart.addItem(id: item.id, fqUserId: item.fqUserId, name: item.name, description: item.description,
                  value: item.value, qtt: item.qtt, isDone: item.isDone);
            }
          });
        }
      }
    });
  }
}
