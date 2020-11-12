import 'package:flutter/cupertino.dart';

/// Esta classe implementa o objeto [Model] de um item do mercado [User].
class User extends ChangeNotifier {
  //****************************************************************************
  // Construtor da classe
  //****************************************************************************
  /// Construtor padrao da classe
  User({int id, String name});

  //****************************************************************************
  // Atributos da classe
  //****************************************************************************
  int id;
  String name;

  //****************************************************************************
  // Metodos da classe
  //****************************************************************************

  /// Disjuncao logica (Equals): compara se dois objetos [User] sao iguais.
  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is User && runtimeType == other.runtimeType && id == other.id;

  /// hashCode: codigo para identificacao unica deste carrinho.
  @override
  int get hashCode => id.hashCode;
}
