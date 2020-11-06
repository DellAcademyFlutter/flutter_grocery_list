/// Esta classe implementa o objeto [Model] de um item do mercado [Item].
class Item {
  /// Construtor padrao da classe
  Item({this.id, this.name, this.description, this.value});

  // Atributos da classe
  int id;
  String name;
  String description;
  double value;

  /// Disjuncao logica (Equals): compara se dois objetos [Item] sao iguais.
  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is Item && runtimeType == other.runtimeType && id == other.id;

  /// hashCode: codigo para identificacao unica deste carrinho.
  @override
  int get hashCode => id.hashCode;
}
