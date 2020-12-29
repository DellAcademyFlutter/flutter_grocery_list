import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Models/user.dart';
import 'package:get_it/get_it.dart';
import '../Models/item.dart';

/// Esta classe define os argumentos da [CreateEditItemPage].
class CreateEditItemPageArguments {
  final Item item;
  CreateEditItemPageArguments({this.item});
}

/// Esta classe implementa uma tela de adicao/edicao de [Item].
class CreateEditItemPage extends StatefulWidget {
  CreateEditItemPage({this.item});

  static const routeName = "/createitem";
  final cart = GetIt.I<Cart>();
  final Item item;

  @override
  _CreateEditItemPageState createState() => _CreateEditItemPageState();
}

/// [State] da pagina de adicao/edicao de [Item].
class _CreateEditItemPageState extends State<CreateEditItemPage> {
  final loggedUser = GetIt.I<User>();
  TextEditingController tecItemName;
  TextEditingController tecItemValue;
  String textHint = 'Adicionar Item';
  String pageTitle = 'Selecione o item';
  String itemName = '';
  String itemDescription = '';
  double itemValue = 0.0;
  bool isActionSuccess = false;

  bool isEdit;

  @override
  // Inicializa o texto de edicao com base no estado 'edicao' ou 'adicao'.
  void initState() {
    isEdit = widget.item != null;
    tecItemName = TextEditingController(text: widget?.item?.name ?? '');
    tecItemValue = TextEditingController(
        text: widget?.item?.value.toString() == 'null'
            ? ''
            : widget?.item?.value.toString());

    // Altera a label do botao de adicao/edicao
    setState(() {
      if (isEdit) {
        itemName = widget.item.name;
        itemValue = widget.item.value;
        textHint = 'Salvar alterações';
        pageTitle = 'Editando o item';
      } else {
        textHint = 'Adicionar Item';
        pageTitle = 'Item:';
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageTitle),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: Stack(
        // Empilha widgets
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Positioned(
            bottom: MediaQuery.of(context).size.height / 2,
            child: AnimatedOpacity(
              curve: Curves.linear,
              opacity: !isActionSuccess ? 0.0 : 1.0,
              duration: Duration(milliseconds: 1000),
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.done_outline,
                      color: Colors.green,
                    ),
                    Text("Concluído!")
                  ],
                ),
              ),
            ),
          ),
          AnimatedOpacity(
            curve: Curves.bounceIn,
            opacity: isActionSuccess ? 0 : 1.0,
            duration: Duration(milliseconds: 0),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(children: [
                            TextField(
                              controller: tecItemName,
                              onChanged: (valor) =>
                                  setState(() => itemName = valor),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Digite o nome do item',
                              ),
                            ),
                            SizedBox(height: 12),
                            SizedBox(height: 12),
                            TextField(
                              controller: tecItemValue,
                              keyboardType: TextInputType.numberWithOptions(
                                  signed: false, decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                              onChanged: (valor) => setState(
                                      () => itemValue = double.parse(valor)),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Digite o valor do item',
                              ),
                            )
                          ]),
                      ),
                  ),
                    SizedBox(height: 12),
                    RaisedButton(
                      onPressed: (itemName != '')
                          ? () {
                              if (isEdit) {
                                // Realiza a edicao do item
                                if ((itemName != widget.item.name ||
                                    itemValue != widget.item.value))
                                  widget.cart.updateItem(
                                      widget.item.id,
                                      loggedUser.name,
                                      itemName,
                                      itemValue,
                                      widget.item.amount,
                                  widget.item.isDone);
                              } else {
                                if (itemName != '') {
                                  // Realiza a adicao do item
                                  widget.cart..addItem(id: widget.cart.cartList.length + 1,
                                      userName: loggedUser.name, name: itemName, value: itemValue,
                                      qtt: 1, isDone: false);

                                } else {
                                  return null;
                                }
                              }
                              setState(() {
                                isActionSuccess = true;
                              });

                              // Remove o foco do textEdit, para realizar dismiss no keyboard.
                              removeFocus(context: context);

                              Future.delayed(Duration(milliseconds: 1500), (){
                                Navigator.of(context).pop();
                              });
                            }
                          : null,
                      child: Text(
                        textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}

/// Este metodo remove o focus de um widget.
removeFocus({BuildContext context}) {
  FocusScopeNode currentFocus = FocusScope.of(context);

  // Remove o focus do widget atual
  if (!currentFocus.hasPrimaryFocus) {
    currentFocus.unfocus();
  }
}