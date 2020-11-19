import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

/// Esta classe implementa o objeto [Model] de um item do mercado [User].
class User extends ChangeNotifier {
  /// Construtor padrao da classe
  User({int id, String name}) {
    this.id = id;
    this._name = name;
  }

  // Atributos da classe
  int id;
  String _name;

  /// Atribui os valores dos parametros deste [User] dado um [Map] Jason.
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  /// Este metodo codifica este [User] em um [Map] Json.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }

  // Gets e Set
  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  /// Disjuncao logica (Equals): compara se dois objetos [User] sao iguais.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && runtimeType == other.runtimeType && id == other.id;

  /// hashCode: codigo para identificacao unica deste carrinho.
  @override
  int get hashCode => id.hashCode;
}
