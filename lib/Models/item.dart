/// Esta classe implementa o objeto [Model] de um item do mercado [Item].
class Item {
  /// Construtor padrao da classe.
  Item({this.id, this.fqUserId, this.name, this.description, this.value, this.qtt, this.isDone});

  // Atributos da classe
  int id;
  String fqUserId; // foreign key do carrinho a qual este [Item] pertence.
  int qtt = 1;
  String name;
  String description;
  double value;
  bool selected = false;
  bool isDone = false;

  /// Atribui os valores dos parametros deste [Item] dado um [Map] Jason.
  Item.fromJson({Map<String, dynamic> json}) {
    id = json['id'];
    fqUserId = json['fqCartId'];
    qtt = json['qtt'];
    name = json['name'];
    description = json['description'];
    value = json['value'];
    selected = json['selected'];
    isDone = json['isDone'];
  }

  /// Este metodo codifica este [Item] em um [Map] Json.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['fqCartId'] = this.fqUserId;
    data['qtt'] = this.qtt;
    data['name'] = this.name;
    data['description'] = this.description;
    data['value'] = this.value;
    data['selected'] = this.selected;
    data['isDone'] = this.isDone;
    return data;
  }

  /// Disjuncao logica (Equals): compara se dois objetos [Item] sao iguais.
  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is Item && runtimeType == other.runtimeType && id == other.id;

  /// hashCode: codigo para identificacao unica deste item.
  @override
  int get hashCode => id.hashCode;
}
