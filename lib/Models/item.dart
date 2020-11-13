/// Esta classe implementa o objeto [Model] de um item do mercado [Item].
class Item {
  //****************************************************************************
  // Construtor da classe
  //****************************************************************************
  /// Construtor padrao da classe
  Item({this.id, this.name, this.description, this.value, this.qtt});

  //****************************************************************************
  // Atributos da classe
  //****************************************************************************
  int id;
  int qtt = 1;
  String name;
  String description;
  double value;
  bool selected = false;
  bool isDone = false;

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qtt = json['qtt'];
    name = json['name'];
    value = json['value'];
    selected = json['selected'];
    isDone = json['isDone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['qtt'] = this.qtt;
    data['name'] = this.name;
    data['value'] = this.value;
    data['selected'] = this.selected;
    data['isDone'] = this.isDone;
    return data;
  }

  //****************************************************************************
  // Metodos da classe
  //****************************************************************************
  /// Disjuncao logica (Equals): compara se dois objetos [Item] sao iguais.
  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is Item && runtimeType == other.runtimeType && id == other.id;

  /// hashCode: codigo para identificacao unica deste item.
  @override
  int get hashCode => id.hashCode;
}
