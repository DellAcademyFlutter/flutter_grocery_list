import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Viewers/add_item_page.dart';
import 'package:flutter_grocery_list/shared/math_utils.dart';
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
                  Text(widget.title, style: TextStyle(color: Colors.black)),
                  changeTheme(),
                ],
              ),
              backgroundColor:
                  cart.hasSelectedItems() ? Colors.lightGreen : Colors.amber,
              actions: <Widget>[
                cart.hasSelectedItems()
                    ? Row(
                        children: [
                          CheckSelectedItems(),
                          SizedBox(width: 20),
                          RemoveSelectedItems(),
                        ],
                      )
                    : CartInfos()
              ],
            ),
            body: Center(
                child: cart.cartList.length != 0
                    ? ListView.builder(
                        itemCount: cart.cartList.length,
                        itemBuilder: _getListItemTile, // Sem Context e index
                      )
                    : emptyCart()),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateEditItemPage(
                      item: null,
                    ),
                  ),
                );
              },
              tooltip: 'Add',
              child: Icon(Icons.add),
              backgroundColor: Colors.amber,
            ),
          );
        });
  }
}

/// Widget utilizado para exibicao dos itens do carrinho [cart]
Widget _getListItemTile(BuildContext context, int index) {
  final cart = GetIt.I<Cart>();

  return GestureDetector(
      onTap: () {
        cart.toggleSelectItem(index);
      },
      child: Dismissible(
        // Adiciona comportamento slide
        key: Key(cart.cartList[index].name), // Identificador do item
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            margin: EdgeInsets.symmetric(vertical: 4),
            color: cart.cartList[index].selected
                ? Colors.greenAccent
                : Colors.white,
            child: Card(
              color: cart.cartList[index].isDone ? Colors.amber : Colors.white,
              child: Container(
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(children: <Widget>[
                    ListTile(
                      title: Text('${cart.cartList[index].name}',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              decoration: cart.cartList[index].isDone
                                  ? TextDecoration.lineThrough
                                  : null)),
                      trailing: Text(
                          'R\$ ${MathUtils.round(cart.cartList[index].value*cart.cartList[index].amount, 2).toString()}',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              decoration: cart.cartList[index].isDone
                                  ? TextDecoration.lineThrough
                                  : null)),
                    ),
                    Row(children: <Widget>[
                      SizedBox(width: 10),
                      InkWell(
                          onTap: () => cart.increaseAmount(index),
                          child: Icon(Icons.add, color: Colors.green)),
                      Text('${cart.cartList[index].amount}',
                          style: TextStyle(fontSize: 25, color: Colors.grey)),
                      InkWell(
                          onTap: () => cart.decreaseAmount(index),
                          child: Icon(Icons.remove, color: Colors.red)),
                    ]),
                  ]),
                ),
              ),
            )),

        background: slideRightBackground(), // Slide right
        secondaryBackground: slideLeftBackground(), // Slide left

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
                builder: (_) => CreateEditItemPage(item: cart.cartList[index]),
              ),
            );
          }
        },
      ));
}

/// Widget retornado e exibido quando arrastamos um [Card] para a direita.
Widget slideRightBackground() {
  return Container(
    color: Colors.green,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //Para adicionar um pequeno espaçamento no começo
          SizedBox(
            width: 10,
          ),
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          Text(
            " Editar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}

/// Widget retornado e exibido quando arrastamos um [Card] para a esquerda.
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
              fontSize: 30,
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
class CartInfos extends StatelessWidget {
  final cart = GetIt.I<Cart>();

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Total: R\$ ${MathUtils.round(cart.totalValueCart,2)}",
              style: TextStyle(fontSize: 20, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ));
  }
}

/// Esta classe retorna um widget mensagem de carrinho vazio.
Widget emptyCart() {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 50),
        Text(
          "Seu carrinho ainda está vazio!",
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),
        Icon(
          Icons.remove_shopping_cart,
          color: Colors.black,
          size: 50,
        ),
      ],
    ),
  );
}

/// Esta classe retorna um widget de troca de temas [Theme_Model]
Widget changeTheme() {
  return InkWell(
      onTap: () => GetIt.I<ThemeModel>().changeTheme(),
      child: Icon(CupertinoIcons.brightness_solid));
}

/// Esta classe retorna um widget de remocao de multiplos itens do carrinho
class RemoveSelectedItems extends StatelessWidget {
  final cart = GetIt.I<Cart>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => showAlertDialog(context),
        child: Icon(Icons.delete_outline));
  }
}

/// Esta classe retorna um widget de remocao de multiplos itens do carrinho
class CheckSelectedItems extends StatelessWidget {
  final cart = GetIt.I<Cart>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => cart.checkSelectedItems(), child: Icon(Icons.beenhere));
  }
}

showAlertDialog(BuildContext context) {
  final cart = GetIt.I<Cart>();

  Widget cancelaButton = FlatButton(
    child: Text("Nao"),
    onPressed: () => Navigator.of(context).pop(),
  );
  Widget continuaButton = FlatButton(
      child: Text("Sim"),
      onPressed: () {
        cart.removeSelectedItems();
        Navigator.of(context).pop();
      });

  //configura o AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Confirmação"),
    content: Text("Deseja remover os itens selecionados?"),
    actions: [
      cancelaButton,
      continuaButton,
    ],
  );

  //exibe o diálogo
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
