import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(bodyText2: TextStyle(fontSize: 30))
      ),
      home: MyHomePage(title: 'Lista de Compras'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> cartList = List();
  var editText = TextEditingController();

  @override
  void initState() {
    super.initState();
    cartList.add("Leite");
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
          itemBuilder: (context, index){
            return ListTile(
              title: Text("${cartList[index]}"),
              onTap: (){
                debugPrint("lead9 Você clicou no ${cartList[index]}");
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context, child:
          AlertDialog(
            title: Text("Adcionando um item"),
            content: TextField(
              controller: editText,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: (){
                  setState(() {
                    cartList.add(editText.text);
                    editText.text = "";
                  });

                  Navigator.of(context).pop();
                },
              )
            ],
          )
          );
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
