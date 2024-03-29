import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Models/user.dart';
import 'package:get_it/get_it.dart';
import '../Models/item.dart';

/// Esta classe implementa uma tela de adicao/edicao de [Item].
class CreateEditItemPage extends StatefulWidget {
  CreateEditItemPage({this.item});

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
      body: Padding(
        padding: const EdgeInsets.all(18),
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
                            // ignore: deprecated_member_use
                            WhitelistingTextInputFormatter(
                                RegExp(r'^\d+\.?\d{0,2}')),
                          ],
                          onChanged: (valor) =>
                              setState(() => itemValue = double.parse(valor)),
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
                        if (isEdit) {
                          // Realiza a edicao do item
                          if ((itemName != widget.item.name ||
                              itemDescription != widget.item.description ||
                              itemValue != widget.item.value))
                            widget.cart.updateItem(widget.item.id, widget.loggedUser.name, itemName,
                                itemDescription, itemValue, widget.item.qtt, widget.item.isDone);
                        } else {
                          if (itemName != '' || itemDescription != '') {
                            // Realiza a adicao do item
                            widget.cart.addItem(widget.cart.itemList.length + 1, widget.loggedUser.name,
                                itemName, itemDescription, itemValue, 1, false);
                          } else {
                            return null;
                          }
                        }
                        Navigator.of(context).pop();
                      }
                    : null,
                child: Text(
                  textHint,
                ),
                color: Colors.blue,
              )
            ],
          ),
        ),
      ),
    );
  }
}
