import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Models/settings.dart';
import 'package:flutter_grocery_list/Models/user.dart';
import 'package:flutter_grocery_list/shared/math_utils.dart';
import 'package:flutter_grocery_list/shared/theme_model.dart';
import 'package:flutter_grocery_list/local/shared_prefs.dart';
import 'package:get_it/get_it.dart';

/// Esta classe implementa a pagina de perfil de [User].
class ProfilePage extends StatelessWidget {
  final cart = GetIt.I<Cart>();
  final loggedUser = GetIt.I<User>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: cart,
        builder: (context, w) {
          return Scaffold(
            body: BuildProfilePage(),
          );
        });
  }
}

/// Esta classe retorna o widget da pagina perfil do [User].
class BuildProfilePage extends StatefulWidget {
  @override
  _BuildProfilePageState createState() => _BuildProfilePageState();
}

class _BuildProfilePageState extends State<BuildProfilePage> {
  final cart = GetIt.I<Cart>();
  final loggedUser = GetIt.I<User>();
  final settings = GetIt.I<Settings>();
  final themeModel = GetIt.I<ThemeModel>();
  bool isSwitched = false;
  double defaultFontSize = 10.5;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: ListView(
        children: [
          Column(
            children: [
              SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: Color(0xffFDCF09),
                      child: CircleAvatar(
                        radius: 95,
                        backgroundColor: Colors.lightBlueAccent,
                        backgroundImage: NetworkImage(
                            'https://images.vexels.com/media'
                            '/users/3/137047/isolated/preview/'
                            '5831a17a290077c646a'
                            '48c4db78a81bb---cone-de-perfil-de-usu--rio-azul-by-vexels.png'),
                      ),
                    ),
                    Text(
                      "${loggedUser.name}",
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Alto-contraste',
                        ),
                      ),
                      Spacer(),
                      Container(
                        alignment: Alignment.centerRight,
                        child: Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            isSwitched = value;
                            settings.themeModel.changeThemeContrast();
                          },
                          activeTrackColor: Colors.amber,
                          activeColor: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          ' Tamanho do texto',
                        ),
                      ),
                      TextSizeSlider(),
                      FlatButton(
                        onPressed: (settings.fontSize != defaultFontSize)
                            ? () {
                                settings.fontSize = defaultFontSize;
                              }
                            : null,
                        child: Text(
                          "Retornar ao tamanho padrão",
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                'Trocar tema',
                              ),
                            ),
                            SizedBox(height: 4),
                            RadioButton(context),
                            //Text('${MediaQuery.platformBrightnessOf(context)}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sair',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(child: Logout()),
                      SizedBox(width: 2),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Esta classe retorna um widget mensagem com o valor total do [Cart].
class CartInformations extends StatelessWidget {
  final cart = GetIt.I<Cart>();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      subtitle: Text(
        "Valor total: R\$ ${MathUtils.round(cart.totalValueCart, 2)}",
        style: TextStyle(fontSize: 15, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}

logoutMethod(BuildContext context) {
  final loggedUser = GetIt.I<User>();
  final cart = GetIt.I<Cart>();

  SharedPrefs.contains("loggedUser").then((value) {
    if (value) {
      cart.exportItemToLocalStorage(loggedUser.name);
      saveUser(loggedUser);
      SharedPrefs.remove("loggedUser");
      loggedUser.name = null;
      cart.removeAll();

      Navigator.pushReplacementNamed(context, '/');
    } else {
      Navigator.pushReplacementNamed(context, '/');
    }
  });
}

/// Esta classe retorna um widget de logout de [User]
class Logout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          logoutMethod(context);
        },
        child: Icon(
          Icons.power_settings_new,
          semanticLabel: "logout",
        ));
  }
}

/// Esta classe retorna um widget com slider referente ao tamanho da fonte.
class TextSizeSlider extends StatelessWidget {
  final settings = GetIt.I<Settings>();

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: settings.fontSize,
      min: 1,
      max: 20,
      divisions: 6,
      label: "Tamanho",
      onChanged: (newSliderValue) {
        settings.fontSize = newSliderValue;
      },
    );
  }
}

saveUser(User user) {
  SharedPrefs.save("${user.name}", '${user.name}');
}

/// Esta classe retorna um widget com slider referente ao tamanho da fonte.
class RadioButton extends StatelessWidget {
  final settings = GetIt.I<Settings>();
  BuildContext contextTela;

  RadioButton(this.contextTela);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        alignment: Alignment.centerLeft,
        child: Row(
          children: <Widget>[
            Radio(
              value: 1,
              groupValue: settings.option,
              onChanged: (value) =>
                  settings.handleRadioValueChange(value, contextTela),
            ),
            Text("Sistema"),
            Radio(
              value: 2,
              groupValue: settings.option,
              onChanged: (value) =>
                  settings.handleRadioValueChange(value, contextTela),
            ),
            Text("Light"),
            new Radio(
              value: 3,
              groupValue: settings.option,
              onChanged: (value) =>
                  settings.handleRadioValueChange(value, contextTela),
            ),
            Text("Dark"),
          ],
        ),
      ),
    );
  }
}
