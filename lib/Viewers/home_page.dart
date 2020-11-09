import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Viewers/add_item_page.dart';
import 'package:flutter_grocery_list/Models/item.dart';
import 'package:flutter_grocery_list/shared/theme_model.dart';
import 'package:get_it/get_it.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final cart = GetIt.I<Cart>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: cart,
        builder: (context, w) {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: <Widget>[
                  Text(widget.title),
                  InkWell(
                      onTap: ()=> GetIt.I<ThemeModel>().changeTheme(),
                      child: Icon(CupertinoIcons.brightness_solid))
                ],
              ),
              actions: <Widget>[CartTotalValue()],
            ),
            body: Center(
                child: cart.itemList.length != 0
                    ? ListView.builder(
                        itemCount: cart.itemList.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            // Adiciona comportamento slide
                            key: Key(cart.itemList[index].name),
                            child: Card(
                                child: ListTile(
                                  title: Text(
                                    '${cart.itemList[index].name}',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  subtitle: Text(
                                    '${cart.itemList[index].description}',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  trailing:
                                      Text('R\$ ${cart.itemList[index].value}'),
                                ),
                                color: Colors.lightGreenAccent),

                            background: slideRightBackground(), // Slide right
                            secondaryBackground:
                                slideLeftBackground(), // Slide left

                            // ignore: missing_return
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.endToStart) {
                                final bool resp = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text(
                                            "Você gostaria de remover: ${cart.itemList[index]} do carrinho?"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text(
                                              "Cancelar",
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          FlatButton(
                                            child: Text(
                                              "Remover",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onPressed: () {
                                              //Remove o lista no index selecionado
                                              cart.removeItem(index);
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
                                    builder: (_) =>
                                        CreateItem(item: cart.itemList[index]),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      )
                    : EmptyCart()),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateItem(
                      item: null,
                    ),
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

/// Esta classe retorna um widget mensagem com o valor total do carrinho.
class CartTotalValue extends StatelessWidget {
  final cart = GetIt.I<Cart>();

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Qtd. produtos: ${cart.itemList.length}",
              style: TextStyle(fontSize: 15, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Text(
              "Valor total: R\$ ${cart.totalValue}",
              style: TextStyle(fontSize: 15, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }
}

/// Esta classe retorna um widget mensagem de carrinho vazio.
class EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "Seu carrinho está vazio.",
        style: TextStyle(fontSize: 25, color: Colors.black),
      ),
    );
  }
}
