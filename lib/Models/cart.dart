import 'package:flutter/cupertino.dart';
import 'item.dart';

/// Esta classe implementa o objeto [Model] de um carrinho [Cart].
class Cart extends ChangeNotifier{
  //****************************************************************************
  // Atributos da classe
  //****************************************************************************
  /// Construtor padrao da classe
  Cart({this.id});


  //****************************************************************************
  // Atributos da classe
  //****************************************************************************
  int id;
  double totalValue = 0.0;
  List<Item> itemList = List();


  //****************************************************************************
  // Metodos da classe
  //****************************************************************************
  /// Este metodo atualiza um item de [itemList].
  addItem(Item item){
    itemList.add(item);
    totalValue += item.value;

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo atualiza um item de [itemList].
  updateItem(Item item){
    final index = itemList.indexOf(item);
    itemList.removeAt(index);
    itemList.insert(index, item);

    //TODO: atualizar o valor total do carrinho quando puder editar o preco dos itens.

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Este metodo remove um item de [itemList] baseado em um indice [index].
  removeItem(int index){
    // Atualiza o preco total do carrinho
    double itemToRemoveValue = itemList[index].value;
    totalValue -= itemToRemoveValue;

    // Remove o item
    itemList.removeAt(index);

    notifyListeners(); // Notifica aos observadores uma mudanca na lista.
  }

  /// Disjuncao logica (Equals): compara se dois objetos [Item] sao iguais.
  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is Item && runtimeType == other.runtimeType && id == other.id;

  /// hashCode: codigo para identificacao unica deste carrinho.
  @override
  int get hashCode => id.hashCode;
}
