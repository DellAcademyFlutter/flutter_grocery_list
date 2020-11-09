import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Viewers/add_item_page.dart';
import 'package:flutter_grocery_list/Models/item.dart';
import 'package:get_it/get_it.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final cart = GetIt.I<Cart>();
  var editText = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Adiciona, por padrao, um item leite.
    cart.cartList.add(
        Item(id: cart.cartList.length, name: "Leite", qtd: 1, value: 3.50));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: cart,
        builder: (context, w) {
          return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
              actions: <Widget>[
                Container(
                  width: 200,
                  height: 100,
                  alignment: Alignment.center,
                  child: Text(
                    'Valor total R\$: ${cart.totalValue}',
                    style: TextStyle(fontSize: 25, color: Colors.green),
                  ),
                ),
                //TesteIsrael()
              ],
            ),
            body: Center(
              child: (cart.cartList.length != 0)
                  ? ListView.builder(
                      itemCount: cart.cartList.length,
                      itemBuilder: (context, index) {
                        //Dismissible é um widjet que adiciona os comportamentos de slide
                        return Dismissible(
                          key: Key(cart.cartList[index].name),
                          child: Card(
                            child: Container(
                              child: Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Column(children: <Widget>[
                                  ListTile(
                                    title: Text('${cart.cartList[index].name}',
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.black)),
                                    trailing: Text(
                                        'R\$ ${cart.cartList[index].value}',
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.grey)),
                                  ),
                                  Row(children: <Widget>[
                                    new IconButton(
                                      icon:
                                          Icon(Icons.add, color: Colors.green),
                                      onPressed:
                                          cart.cartList[index].increase(),
                                    ),
                                    Text('${cart.cartList[index].qtd}',
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.grey)),
                                    new IconButton(
                                      icon:
                                          Icon(Icons.remove, color: Colors.red),
                                      onPressed:
                                          cart.cartList[index].decrease(),
                                    ),
                                  ]),
                                ]),
                              ),
                            ),
                          ),

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
                                          "Você gostaria de remover: ${cart.cartList[index]} do carrinho?"),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text(
                                            "Cancelar",
                                            style:
                                                TextStyle(color: Colors.black),
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
                                            cart.removeItemList(index);

                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  });
                              return resp;
                            } else {
                              // Navega para a pagina de edicao
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => CreateItem(cart.cartList
                                        .indexOf(cart.cartList[index])),
                                  ),
                                );
                            }
                          },
                        );
                      },
                    )
                  : Text('O seu carrinho está Vazio!'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {

                  Navigator.of(context)
                      .push(
                        MaterialPageRoute(
                          builder: (_) => CreateItem(null),
                        ),
                      );
              },
              tooltip: 'Add',
              child: Icon(Icons.add),
            ),
          );
        });
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

class TesteIsrael extends StatelessWidget {
  final cart = GetIt.I<Cart>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        '',
        style: TextStyle(fontSize: 25, color: Colors.black),
      ),
    );
  }
}
