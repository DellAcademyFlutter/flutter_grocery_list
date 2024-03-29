import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Models/item.dart';
import 'package:flutter_grocery_list/Viewers/add_item_page.dart';
import 'package:flutter_grocery_list/shared/math_utils.dart';
import 'package:get_it/get_it.dart';

class ItemsPage extends StatelessWidget {
  ItemsPage({this.doneItems});

  final bool doneItems;
  final cart = GetIt.I<Cart>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: cart,
        builder: (context, w) {
          return Scaffold(
            body: buildItemCards(doneItems),
            floatingActionButton: (doneItems) ? null : addItem(context),
          );
        });
  }
}

/// Widget que retorna uma [ListView] dos items pendentes
Widget buildItemCards(bool doneItems) {
  final cart = GetIt.I<Cart>();
  return (doneItems) ? listDoneItems() : listUndoneItems();
}

class listDoneItems extends StatelessWidget {
  final cart = GetIt.I<Cart>();

  @override
  Widget build(BuildContext context) {
    return (cart.hasDoneItems() == false)
        ? EmptyItemsMessage(doneItems: true)
        : ListItems(doneItems: true);
  }
}

class listUndoneItems extends StatelessWidget {
  final cart = GetIt.I<Cart>();

  @override
  Widget build(BuildContext context) {
    return (cart.hasUnDoneItems())
        ? ListItems(doneItems: false)
        : EmptyItemsMessage(doneItems: false);
  }
}

class ListItems extends StatelessWidget {
  ListItems({this.doneItems});

  final bool doneItems;
  final cart = GetIt.I<Cart>();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView.builder(
      itemCount: cart.itemList.length,
      itemBuilder: (context, index) => getScrollableItemCard(
          context, index, doneItems), // Sem Context e index
    ));
  }
}

/// Widget utilizado para exibicao dos itens do carrinho [cart]
Widget getScrollableItemCard(BuildContext context, int index, bool itemType) {
  final cart = GetIt.I<Cart>();

  return (cart.itemList[index].isDone == itemType)
      ? GestureDetector(
          onTap: () {
            cart.toggleSelectItem(index);
          },
          child: Dismissible(
            // Adiciona comportamento slide
            key: Key(cart.itemList[index].name), // Identificador do item
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                margin: EdgeInsets.symmetric(vertical: 4),
                child: Card(
                  color: cart.itemList[index].selected
                      ? Colors.blue
                      : null,
                  child: Container(
                    margin: EdgeInsets.all(0.0),
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(children: <Widget>[
                        ListTile(
                          title: Text('${cart.itemList[index].name}',
                              style: TextStyle(
                                  decoration: cart.itemList[index].isDone
                                      ? TextDecoration.lineThrough
                                      : null)),
                          subtitle: Text('${cart.itemList[index].description}',
                              style: TextStyle(
                                  decoration: cart.itemList[index].isDone
                                      ? TextDecoration.lineThrough
                                      : null)),
                          trailing: Text(
                              'R\$ ${MathUtils.round(cart.itemList[index].value * cart.itemList[index].qtt, 2).toString()}',
                              style: TextStyle(
                                  decoration: cart.itemList[index].isDone
                                      ? TextDecoration.lineThrough
                                      : null)),
                        ),
                        Row(children: <Widget>[
                          InkWell(
                              onTap: () => cart.increaseItemQtt(index),
                              child: Icon(Icons.add, color: Colors.green[800])),
                          Text('${cart.itemList[index].qtt}',
                              style: TextStyle(
                                  decoration: cart.itemList[index].isDone
                                      ? TextDecoration.lineThrough
                                      : null)),
                          InkWell(
                              onTap: () => cart.decreaseItemQtt(index),
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
                            "Você gostaria de remover: ${cart.itemList[index]} do carrinho?"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              "Cancelar",
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          FlatButton(
                            child: Text(
                              "Remover",
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
                        CreateEditItemPage(item: cart.itemList[index]),
                  ),
                );
              }
            },
          ))
      : SizedBox.shrink();
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
            width: 20,
          ),
          Icon(
            Icons.edit,
          ),
          Text(
            " Editar",
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
          ),
          Text(
            " Remover",
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
        onTap: () => cart.checkSelectedItems(),
        child: Icon(Icons.check_circle_outline));
  }
}

/// Mensagem de feedback de delecao
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
    title: Text("Atenção!"),
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

/// Este metodo retorna um widget [FloatingActionButton] de adicao de [Item]
FloatingActionButton addItem(BuildContext context) {
  return FloatingActionButton(
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
  );
}

/// Esta classe retorna um widget mensagem de carrinho vazio.
class EmptyItemsMessage extends StatelessWidget {
  EmptyItemsMessage({this.doneItems});

  final bool doneItems;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
          doneItems ? "Não há items comprados." : "Não há items para comprar.",
        ),
      ),
    );
  }
}
