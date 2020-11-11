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
  int amountItems = 0;
  double totalValueCart = 0.0;
  List<Item> cartList = List();

  //****************************************************************************
  // Metodos da classe
  //****************************************************************************
  /// Este metodo adiciona um item de [cartList].
  addItem(int id, String name, double value, int qtt) {
    Item item = Item(
        id: cartList.length + 1,
        name: name,
        value: value,
        amount: 1
    );
    cartList.add(item);
    totalValueCart += item.value;
    amountItems++;

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo atualiza um item de [cartList].
  updateItem(int id, String name, double value, int qtt) {
    final item = Item(
        id: id,
        name: name,
        value: value,
        amount: qtt
    );

    final index = cartList.indexOf(item);
    // Atualiza o preco total do carrinho
    totalValueCart -= cartList[index].value*cartList[index].amount;
    amountItems -= cartList[index].amount;
    // Remove o item
    cartList.removeAt(index);

    // Adiciona o novo item atualizado
    cartList.insert(index, item);
    // Modifica o novo preco
    totalValueCart += cartList[index].value*cartList[index].amount;

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo remove um item de [cartList] baseado em um indice [index].
  removeItem(int index) {
    // Atualiza o preco total do carrinho
    totalValueCart -= cartList[index].value*cartList[index].amount;
    // Remove o item
    amountItems -= cartList[index].amount;
    cartList.removeAt(index);

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo realiza um check todos os itens selecionados.
  checkSelectedItems() {
    // Percorre todos os itens do carrinho.
    for (int i = cartList.length-1; i > -1; i--) {
      if (cartList[i].selected) {
        // Marca o item.
        cartList[i].isDone = !cartList[i].isDone;
        cartList[i].selected = false;
      }
    }

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo remove todos os itens selecionados.
  removeSelectedItems() {
    // Percorre todos os itens do carrinho.
    for (int i = cartList.length-1; i > -1; i--) {
      if (cartList[i].selected) {
        // Atualiza o preco total do carrinho
        totalValueCart -= cartList[i].value*cartList[i].amount;
        amountItems -= cartList[i].amount;
        // Remove o item
        cartList.removeAt(i);
      }
    }

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo aumenta a quantidade de um item especificado por seu [index]
  increaseAmount(index){
    cartList[index].amount++;
    amountItems++;

    totalValueCart += cartList[index].value;
    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo aumenta a quantidade de um item especificado por seu [index]
  decreaseAmount(index){
    if (cartList[index].amount > 1) {
      cartList[index].amount--;
      amountItems--;
      totalValueCart -= cartList[index].value;

      notifyListeners(); // Notifica aos observadores uma mudanca na lista.
    }
  }


  /// Este metodo marca true no atributo select deste [item]
  selectItem(index) {
    cartList[index].selected = true;

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo alterna o atributo selecao de um item
  toggleSelectItem(index) {
    cartList[index].selected = !cartList[index].selected;

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo retorna se existir pelo menos 1 item selecionado em [cartList]
  hasSelectedItems(){
    return (cartList.any((item) => item.selected));
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
