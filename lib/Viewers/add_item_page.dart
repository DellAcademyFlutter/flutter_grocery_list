import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:get_it/get_it.dart';
import '../Models/item.dart';

/// Esta classe implementa uma tela de adicao/edicao de [Item].
class CreateItem extends StatefulWidget {
  CreateItem(this.indexEditedItem);

  ///Carrinho
  final cart = GetIt.I<Cart>();

  ///Posicao para a edicao
  int indexEditedItem;

  @override
  _CreateItemState createState() => _CreateItemState();
}

/// [State] da pagina de adicao/edicao de [Item].
class _CreateItemState extends State<CreateItem> {
  TextEditingController textEditingController;
  String textHint = 'Adicionar Item';
  String itemName = '';
  bool isEdit;

  @override
  // Inicializa o texto de edicao com base no estado 'edicao' ou 'adicao'.
  void initState() {
    isEdit = widget.indexEditedItem != null;
    textEditingController =
        TextEditingController(text: (widget.indexEditedItem != null)?
        widget.cart.cartList[widget.indexEditedItem].name ?? '' : '');
    // Altera a label do botao de adicao/edicao
    setState(() {
      if (isEdit) {
        textHint = 'Salvar modificações';
      } else {
        textHint = 'Adicionar Item';
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: textEditingController,
                onChanged: (valor) => setState(() => itemName = valor),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Digite o nome do item',
                ),
              ),
              SizedBox(height: 12),
              RaisedButton(
                onPressed: itemName != ''
                    ? () {
                        if (isEdit) {
                          // Realiza a edicao do item

                          final editedItem = Item(
                              id: widget.cart.cartList[widget.indexEditedItem].id,
                              name: itemName,
                              value: 3.50);

                          widget.cart.updateItem(editedItem);
                        } else {
                          // Realiza a adicao do item
                          widget.cart.addItem(itemName);
                        }
                        Navigator.of(context).pop();
                      }
                    : null,
                child: Text(
                  textHint,
                  style: TextStyle(
                    color: Colors.white,
                  ),
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
