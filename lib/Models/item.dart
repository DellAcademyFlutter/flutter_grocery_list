import 'package:flutter/cupertino.dart';

/// Esta classe implementa o objeto [Model] de um item do mercado [Item].
class Item {
  //****************************************************************************
  // Construtor da classe
  //****************************************************************************
  /// Construtor padrao da classe
  Item({this.id, this.name, this.unitedValue});

  //****************************************************************************
  // Atributos da classe
  //****************************************************************************
  int id;
  int amount = 1;
  String name;
  double unitedValue;
  double totalValue;
  bool selected = false;
  bool isDone = false;

  //****************************************************************************
  // Metodos da classe
  //****************************************************************************
  /// Disjuncao logica (Equals): compara se dois objetos [Item] sao iguais.
  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is Item && runtimeType == other.runtimeType && id == other.id;

  /// hashCode: codigo para identificacao unica deste carrinho.
  @override
  int get hashCode => id.hashCode;
}
