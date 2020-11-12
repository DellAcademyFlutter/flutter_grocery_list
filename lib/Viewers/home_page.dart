import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Models/user.dart';
import 'package:flutter_grocery_list/Viewers/add_item_page.dart';
import 'package:flutter_grocery_list/shared/math_utils.dart';
import 'package:flutter_grocery_list/shared/theme_model.dart';
import 'package:flutter_grocery_list/shared_preferences/shared_prefs.dart';
import 'package:get_it/get_it.dart';

import 'login_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final cart = GetIt.I<Cart>();
  final loggedUser = GetIt.I<User>();
  Color appBarColor;

  @override
  void initState() {
    super.initState();
    appBarColor = Colors.blue;
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
                  Column(
                    children: [
                      Text(widget.title),
                      Text(loggedUser?.name == null ? "nulo" : loggedUser.name),
                    ],
                  ),
                  ChangeTheme(),
                ],
              ),
              backgroundColor:
                  cart.hasSelectedItems() ? Colors.blue[900] : Colors.blue,
              actions: <Widget>[
                cart.hasSelectedItems()
                    ? Row(
                        children: [
                          CheckSelectedItems(),
                          SizedBox(width: 20),
                          RemoveSelectedItems(),
                        ],
                      )
                    : CartInfos(),
                SizedBox(
                  width: 20,
                ),
                Logout(),
              ],
            ),
            body: Center(
                child: cart.itemList.length != 0
                    ? ListView.builder(
                        itemCount: cart.itemList.length,
                        itemBuilder: _getListItemTile, // Sem Context e index
                      )
                    : EmptyCart()),
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
        key: Key(cart.itemList[index].name), // Identificador do item
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            margin: EdgeInsets.symmetric(vertical: 4),
            color:
                cart.itemList[index].selected ? Colors.red[100] : Colors.white,
            child: Card(
              color: cart.itemList[index].selected
                  ? Colors.blue
                  : cart.itemList[index].isDone
                      ? Colors.lightGreen[400]
                      : Colors.grey[300],
              child: Container(
                margin: EdgeInsets.all(0.0),
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(children: <Widget>[
                    ListTile(
                      title: Text('${cart.itemList[index].name}',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              decoration: cart.itemList[index].isDone
                                  ? TextDecoration.lineThrough
                                  : null)),
                      subtitle: Text(
                        '${cart.itemList[index].description}',
                        style: TextStyle(fontSize: 15),
                      ),
                      trailing: Text(
                          'R\$ ${MathUtils.round(cart.itemList[index].value * cart.itemList[index].qtt, 2).toString()}',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.black,
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
                              fontSize: 25,
                              color: Colors.black,
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
                builder: (_) => CreateEditItemPage(item: cart.itemList[index]),
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
              "Qtd. produtos: ${cart.qttItems}",
              style: TextStyle(fontSize: 15, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            Text(
              "Valor total: R\$ ${MathUtils.round(cart.totalValue, 2)}",
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

/// Esta classe retorna um widget de troca de temas [Theme_Model]
class ChangeTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => GetIt.I<ThemeModel>().changeTheme(),
        child: Icon(CupertinoIcons.brightness_solid));
  }
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

/// Este widget exibe uma label para o [ThemeModel]
// ignore: non_constant_identifier_names
Widget ThemeLabel() {
  return FutureBuilder(
    future: SharedPrefs.read("isDarkTheme"),
    initialData: "---",
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return null; //Text("${snapshot.data}");
      } else {
        return null; //CircularProgressIndicator();
      }
    },
  );
}

/// Esta classe retorna um widget de logout de [User]
class Logout extends StatelessWidget {
  final loggedUser = GetIt.I<User>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          SharedPrefs.contains("loggedUser").then((value) {
            if (value) {
              loggedUser.name = null;
              SharedPrefs.remove("loggedUser");
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        LoginPage()),
              );
            } else {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LoginPage(),
                ),
              );
            }
          });
        },
        child: Icon(Icons.power_settings_new, semanticLabel: "logout",));
  }
}


