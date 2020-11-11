import 'package:flutter/cupertino.dart';
import 'package:flutter_grocery_list/shared/math_utils.dart';
import 'item.dart';

/// Esta classe implementa o objeto [Model] de um carrinho [Cart].
class Cart extends ChangeNotifier {
  //****************************************************************************
  // Construtor da classe
  //****************************************************************************
  /// Construtor padrao da classe
  Cart({this.id});

  //****************************************************************************
  // Atributos da classe
  //****************************************************************************
  int id;
  int qttItems = 0;
  double totalValue = 0.0;
  List<Item> itemList = List();

  //****************************************************************************
  // Metodos da classe
  //****************************************************************************
  /// Este metodo adiciona um item de [itemList].
  addItem(int id, String name, String description, double value, int qtt) {
    Item item = Item(
      id: itemList.length + 1,
      name: name,
      description: description,
      value: value,
      qtt: 1
    );
    itemList.add(item);
    totalValue += item.value;
    qttItems++;

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo atualiza um item de [itemList].
  updateItem(int id, String name, String description, double value, int qtt) {
    final item = Item(
        id: id,
        name: name,
        description: description,
        value: value,
      qtt: qtt
    );

    final index = itemList.indexOf(item);
    // Atualiza o preco total do carrinho
    totalValue -= itemList[index].value*itemList[index].qtt;
    qttItems -= itemList[index].qtt;
    // Remove o item
    itemList.removeAt(index);

    // Adiciona o novo item atualizado
    itemList.insert(index, item);
    // Modifica o novo preco
    totalValue += itemList[index].value*itemList[index].qtt;

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo remove um item de [itemList] baseado em um indice [index].
  removeItem(int index) {
    // Atualiza o preco total do carrinho
    totalValue -= itemList[index].value*itemList[index].qtt;
    // Remove o item
    itemList.removeAt(index);
    qttItems -= itemList[index].qtt;

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo realiza um check todos os itens selecionados.
  checkSelectedItems() {
    // Percorre todos os itens do carrinho.
    for (int i = itemList.length-1; i > -1; i--) {
      if (itemList[i].selected) {
        // Marca o item.
        itemList[i].isDone = !itemList[i].isDone;
        itemList[i].selected = false;
      }
    }

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo remove todos os itens selecionados.
  removeSelectedItems() {
    // Percorre todos os itens do carrinho.
    for (int i = itemList.length-1; i > -1; i--) {
      if (itemList[i].selected) {
        // Atualiza o preco total do carrinho
        totalValue -= itemList[i].value*itemList[i].qtt;
        qttItems -= itemList[i].qtt;
        // Remove o item
        itemList.removeAt(i);
      }
    }

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo aumenta a quantidade de um item especificado por seu [index]
  increaseItemQtt(index){
    itemList[index].qtt++;
    qttItems++;

    totalValue += itemList[index].value;
    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo aumenta a quantidade de um item especificado por seu [index]
  decreaseItemQtt(index){
    if (itemList[index].qtt > 1) {
      itemList[index].qtt--;
      qttItems--;
      totalValue -= itemList[index].value;

      notifyListeners(); // Notifica aos observadores uma mudanca na lista.
    }
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

  /// Este metodo retorna se existir pelo menos 1 item selecionado em [itemList]
  hasSelectedItems(){
    return (itemList.any((item) => item.selected));
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
