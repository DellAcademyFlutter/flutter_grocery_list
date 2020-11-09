import 'package:flutter/cupertino.dart';
import 'item.dart';

/// Esta classe implementa o objeto [Model] de um carrinho [Cart].
class Cart extends ChangeNotifier {
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
  /// Este metodo adiciona um item a [cartList].
  addItem(Item item) {
    cartList.add(item);
    totalValueCart += item.unitedValue;
    amountItems++;

    notifyListeners();
  }

  /// Este metodo atualiza um item de [cartList].
  updateItem(Item item) {
    final index = cartList.indexOf(item);
    cartList.removeAt(index);
    cartList.insert(index, item);

    //TODO: atualizar o valor total do carrinho quando puder editar o preco dos itens.
    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo remove um item de [cartList] baseado em um indice [index].
  removeItem(int index) {
    // Atualiza o preco total do carrinho
    totalValueCart -= (cartList[index].unitedValue*cartList[index].amount);

    // Remove o item
    cartList.removeAt(index);
    amountItems--;

    notifyListeners();
  }

  /// Este metodo marca como [isDone] todos os itens selecionados.
  checkSelectedItems() {
    // Percorre todos os itens do carrinho.
    for (int i = cartList.length-1; i > -1; i--) {
      if (cartList[i].selected) {
        cartList[i].isDone = !cartList[i].isDone;
        cartList[i].selected = false;
      }
    }

    notifyListeners();
  }

  /// Este metodo remove todos os itens selecionados.
  removeSelectedItems() {
    // Percorre todos os itens do carrinho.
    for (int i = cartList.length-1; i > -1; i--) {
      if (cartList[i].selected) {
        // Atualiza o preco total do carrinho
        totalValueCart -= (cartList[i].unitedValue*cartList[i].amount);
        amountItems -= cartList[i].amount; //Decrementa um item do carrinho

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

    // Adiciona o preço unitário ao carrinho
    totalValueCart += cartList[index].unitedValue;

    //Atualiza o preço total do item
    cartList[index].totalValue = cartList[index].unitedValue * cartList[index].amount;

    notifyListeners();
  }

  /// Este metodo aumenta a quantidade de um item especificado por seu [index]
  decreaseAmount(index){
    if (cartList[index].amount > 1) {
      cartList[index].amount--;
      amountItems--;
      totalValueCart -= cartList[index].unitedValue;

      //Atualiza o preço total do item
      cartList[index].totalValue = cartList[index].unitedValue * cartList[index].amount;

      notifyListeners();
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
