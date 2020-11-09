import 'package:flutter/cupertino.dart';

/// Esta classe implementa o objeto [Model] de um item do mercado [Item].
class Item extends ChangeNotifier{
  /// Construtor
  Item({this.id, this.name, this.qtd, this.value});

  /// Atributos da classe
  int id;
  String name;
  int qtd = 0;
  //String description;
  double value;

  increase(){
    qtd = qtd + 1;
    notifyListeners();
  }

  decrease(){
    qtd= qtd - 1;
    notifyListeners();
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
