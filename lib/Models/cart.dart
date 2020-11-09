import 'package:flutter/cupertino.dart';

import 'item.dart';

class Cart extends ChangeNotifier{

  /// Variaveis
  List<Item> cartList = List();
  double totalValue = 0.0;

  /// Realiza a adicao do item
  addItem(String itemName){
    Item newItem = Item(
      id: cartList.length + 1,
      name: itemName,
      qtd: 1,
      value: 3.50,
    );
    totalValue += newItem.value;
    cartList.add(newItem);
    notifyListeners();
  }

  /// Realiza a remoção do item
  removeItemList(int index){
    double valueToRemove = cartList[index].value;
    totalValue -= valueToRemove;

    cartList.removeAt(index);
    notifyListeners();
  }

  /// Atualiza um item editado
  updateItem(Item editedItem){
    //Calcula o index
    final index = cartList.indexOf(editedItem);
    cartList.removeAt(index);
    cartList.insert(index, editedItem);

    notifyListeners();
  }


}