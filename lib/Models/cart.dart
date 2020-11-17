import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_grocery_list/shared_preferences/shared_prefs.dart';
import 'item.dart';

/// Esta classe implementa o objeto [Model] de um carrinho [Cart].
class Cart extends ChangeNotifier {
  /// Construtor padrao da classe
  Cart({this.id});

  // Atrubutos da classe
  int id;
  int qttItems = 0;
  double totalValue = 0.0;
  List<Item> itemList = List();

  /// Este metodo adiciona um item de [itemList].
  addItem(int id, String fqUserId, String name, String description,
      double value, int qtt, bool isDone) {
    Item item = Item(
      id: itemList.length + 1,
      fqUserId: fqUserId,
      name: name,
      description: description,
      value: value,
      qtt: 1,
      isDone: isDone,
    );
    itemList.add(item);
    totalValue += item.value;
    qttItems++;

    // Salva o item em Local Storage
    SharedPrefs.save(
        "item_${item.fqUserId}_${item.id}", jsonEncode(item.toJson()));

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo atualiza um item de [itemList].
  updateItem(int id, String fqUserId, String name, String description,
      double value, int qtt, bool isDone) {
    final item = Item(
      id: id,
      fqUserId: fqUserId,
      name: name,
      description: description,
      value: value,
      qtt: qtt,
      isDone: isDone,
    );

    final index = itemList.indexOf(item);
    // Atualiza o preco total do carrinho
    totalValue -= itemList[index].value * itemList[index].qtt;
    qttItems -= itemList[index].qtt;
    // Remove o item
    itemList.removeAt(index);

    // Adiciona o novo item atualizado
    itemList.insert(index, item);
    // Modifica o novo preco
    totalValue += itemList[index].value * itemList[index].qtt;

    // Salva o item em Local Storage
    SharedPrefs.save(
        "item_${item.fqUserId}_${item.id}", jsonEncode(item.toJson()));

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo remove um item de [itemList] baseado em um indice [index].
  removeItem(int index) {
    // Atualiza o preco total do carrinho
    totalValue -= itemList[index].value * itemList[index].qtt;
    qttItems -= itemList[index].qtt;

    // Remove o item em Local Storage
    SharedPrefs.remove("item_${itemList[index].fqUserId}_${itemList[index].id}");

    // Remove o item
    itemList.removeAt(index);

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo realiza um check todos os itens selecionados.
  checkSelectedItems() {
    // Percorre todos os itens do carrinho.
    for (int i = itemList.length - 1; i > -1; i--) {
      if (itemList[i].selected) {
        // Marca o item.
        itemList[i].isDone = !itemList[i].isDone;
        itemList[i].selected = false;

        // Salva o item em Local Storage
        SharedPrefs.save("item_${itemList[i].fqUserId}_${itemList[i].id}",
            jsonEncode(itemList[i].toJson()));
      }
    }

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo remove todos os itens selecionados.
  removeSelectedItems() {
    // Percorre todos os itens do carrinho.
    for (int i = itemList.length - 1; i > -1; i--) {
      if (itemList[i].selected) {
        // Atualiza o preco total do carrinho
        totalValue -= itemList[i].value * itemList[i].qtt;
        qttItems -= itemList[i].qtt;

        // Remove o item em Local Storage
        SharedPrefs.remove("item_${itemList[i].fqUserId}_${itemList[i].id}");

        // Remove o item
        itemList.removeAt(i);
      }
    }

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo aumenta a quantidade de um item especificado por seu [index]
  increaseItemQtt(index) {
    itemList[index].qtt++;
    qttItems++;
    totalValue += itemList[index].value;

    // Salva o item em Local Storage
    SharedPrefs.save("item_${itemList[index].fqUserId}_${itemList[index].id}",
        jsonEncode(itemList[index].toJson()));

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo aumenta a quantidade de um item especificado por seu [index]
  decreaseItemQtt(index) {
    if (itemList[index].qtt > 1) {
      itemList[index].qtt--;
      qttItems--;
      totalValue -= itemList[index].value;

      // Salva o item em Local Storage
      SharedPrefs.save("item_${itemList[index].fqUserId}_${itemList[index].id}",
          jsonEncode(itemList[index].toJson()));

      notifyListeners(); // Notifica aos observadores uma mudanca na lista.
    }
  }

  /// Este metodo faz a limpeza total do carrinho.
  clean() {
    this.qttItems = 0;
    this.totalValue = 0.0;
    this.itemList.clear();

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo marca true no atributo select deste [item]
  selectItem(index) {
    itemList[index].selected = true;

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo alterna o atributo selecao de um item
  toggleSelectItem(index) {
    itemList[index].selected = !itemList[index].selected;

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo retorna true se existir pelo menos 1 item selecionado em [itemList]
  hasSelectedItems() {
    return (itemList.any((item) => item.selected));
  }

  /// Este metodo retorna true se existir pelo menos 1 item em [itemList]
  hasItems() {
    return (itemList.length > 0);
  }

  /// Este metodo retorna true se existir pelo menos 1 item comprado em [itemList]
  hasUnDoneItems() {
    return (itemList.any((item) => !item.isDone));
  }

  /// Este metodo retorna true se existir pelo menos 1 item comprado em [itemList]
  hasDoneItems() {
    return (itemList.any((item) => item.isDone));
  }

  /// Disjuncao logica (Equals): compara se dois objetos [Item] sao iguais.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item && runtimeType == other.runtimeType && id == other.id;

  /// hashCode: codigo para identificacao unica deste carrinho.
  @override
  int get hashCode => id.hashCode;
}
