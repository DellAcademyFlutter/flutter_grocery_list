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
  final loggedUser = GetIt.I<User>();
  final Item item;

  @override
  _CreateEditItemPageState createState() => _CreateEditItemPageState();
}

/// [State] da pagina de adicao/edicao de [Item].
class _CreateEditItemPageState extends State<CreateEditItemPage> {
  TextEditingController tecItemName;
  TextEditingController tecItemDescription;
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
    tecItemDescription =
        TextEditingController(text: widget?.item?.description ?? '');
    tecItemValue = TextEditingController(
        text: widget?.item?.value.toString() == 'null'
            ? ''
            : widget?.item?.value.toString());

    // Altera a label do botao de adicao/edicao
    setState(() {
      if (isEdit) {
        itemName = widget.item.name;
        itemDescription = widget.item.description;
        itemValue = widget.item.value;
        textHint = 'Salvar modificações';
        pageTitle = 'Atualize o item';
      } else {
        textHint = 'Adicionar Item';
        pageTitle = 'Selecione o item';
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
                            TextField(
                              controller: tecItemDescription,
                              onChanged: (valor) =>
                                  setState(() => itemDescription = valor),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Digite a descrição do item',
                              ),
                            ),
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
                          ]))),
                  SizedBox(height: 12),
                  RaisedButton(
                    onPressed: (itemName != '' || itemDescription != '')
                        ? () {
                            saveChanges(
                                cart: widget.cart,
                                item: widget.item,
                                itemName: itemName,
                                itemDescription: itemDescription,
                                itemValue: itemValue,
                                isEdit: isEdit);
                            setState(() {
                              isActionSuccess = true;
                            });

                            // Remove o foco do textEdit, para realizar dismiss no keyboard.
                            removeFocus(context: context);

                            // Fecha a pagina depois de alguns milisegundos.
                            Future.delayed(Duration(milliseconds: 1500), () {
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

/// Este metodo salva modificacoes de adicao ou edicao de [Item] no carrinho.
saveChanges(
    {Cart cart,
    Item item,
    String itemName,
    String itemDescription,
    double itemValue,
    bool isEdit}) {
  final loggedUser = GetIt.I<User>();

  if (isEdit) {
    // Realiza a edicao do item
    if ((itemName != item.name ||
        itemDescription != item.description ||
        itemValue != item.value))
      cart.updateItem(
          id: item.id,
          fqUserId: loggedUser.name,
          name: itemName,
          description: itemDescription,
          value: itemValue,
          qtt: item.qtt,
          isDone: item.isDone);
  } else {
    if (itemName != '' || itemDescription != '') {
      // Realiza a adicao do item
      cart.addItem(
          id: cart.itemList.length + 1,
          fqUserId: loggedUser.name,
          name: itemName,
          description: itemDescription,
          value: itemValue,
          qtt: 1,
          isDone: false);
    } else {
      return null;
    }
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
