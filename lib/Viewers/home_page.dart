import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Viewers/add_item_page.dart';
import 'package:flutter_grocery_list/Models/item.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Item> cartList = List();
  var editText = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Adiciona, por padrao, um item leite.
    cartList.add(new Item(
        id: cartList.length,
        name: "Leite",
        description: "Leite integral",
        value: 3.50));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: cartList.length,
          itemBuilder: (context, index) {
            //Dismissible é um widjet que adiciona os comportamentos de slide
            return Dismissible(
              key: Key(cartList[index].name),
              child: Card(
                  child: ListTile(
                    title: Text('${cartList[index].name}'),
                    subtitle: Text('${cartList[index].description}'),
                    trailing: Text('R\$ ${cartList[index].value}'),
                  ),
                  color: Colors.lightGreenAccent),

              //É o widget que fica visível quando deslizamos o item da lista para a direita.
              background: slideRightBackground(),

              // SecondaryBackground: É o outro lado do deslizamento.
              secondaryBackground: slideLeftBackground(),

              // ignore: missing_return
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.endToStart) {
                  final bool resp = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                              "Você gostaria de remover: ${cartList[index]} do carrinho?"),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                "Cancelar",
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text(
                                "Remover",
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                //Remove o lista no index selecionado
                                setState(() {
                                  cartList.removeAt(index);
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                  return resp;
                } else {
                  // Navega para a pagina de edicao
                  setState(() {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            CreateItem(cart: cartList, item: cartList[index]),
                      ),
                    );
                  });
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CreateItem(
                  cart: cartList,
                  item: null,
                ),
              ),
            );
          });
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}

// Quando arrastamos para a direita
Widget slideRightBackground() {
  return Container(
    color: Colors.green,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //Para adicionar um pequeno espaçamento no começo
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          Text(
            " Editar",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}

// Quando arrastamos para a esquerda
Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            " Remover",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.right,
          ),
          //Espaçamento no final
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}
