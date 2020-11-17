import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Models/settings.dart';
import 'package:flutter_grocery_list/Models/user.dart';
import 'package:flutter_grocery_list/shared_preferences/shared_prefs.dart';
import 'package:get_it/get_it.dart';

import 'login_page.dart';

/// Esta classe implementa a pagina de perfil de [User].
class ProfilePage extends StatelessWidget {
  final cart = GetIt.I<Cart>();
  final loggedUser = GetIt.I<User>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BuildProfilePage(),
    );
  }
}

/// Esta classe retorna o widget da pagina perfil do [User].
class BuildProfilePage extends StatelessWidget {
  final cart = GetIt.I<Cart>();
  final loggedUser = GetIt.I<User>();
  final settings = GetIt.I<Settings>();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: ListView(
        children: [
          UserIconLabel(),
          SizedBox(height: 20.0),
          CartQttItems(),
          CartTotalValue(),
          HighContrastSettings(),
          TextSize(),
          Logout(),
        ],
      ),
    );
  }
}

/// Esta classe retorna um widget com [CircleAvatar] e [Text] referentes ao [User].
class UserIconLabel extends StatelessWidget {
  final loggedUser = GetIt.I<User>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 100.0,
          backgroundImage: NetworkImage(
              "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png"),
          backgroundColor: Colors.transparent,
        ),
        Text(
          "${loggedUser.name}",
        ),
      ],
    );
  }
}

/// Esta classe retorna um widget mensagem com a quantidade de items do [Cart].
class CartQttItems extends StatelessWidget {
  final cart = GetIt.I<Cart>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: cart,
        builder: (context, widget) {
          return Card(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Quantidade de produtos: ",
                      textAlign: TextAlign.left,
                    ),
                    Spacer(),
                    Text(
                      "${cart.qttItems}",
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

/// Esta classe retorna um widget mensagem com a quantidade de items do [Cart].
class CartTotalValue extends StatelessWidget {
  final cart = GetIt.I<Cart>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: cart,
        builder: (context, widget) {
          return Card(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text(
                      "Valor total do carrinho: ",
                      textAlign: TextAlign.left,
                    ),
                    Spacer(),
                    Text(
                      "R\$ ${cart.totalValue}",
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

/// Esta classe retorna um widget referente a configuracao do contraste das cores.
class HighContrastSettings extends StatefulWidget {
  @override
  HighContrastSettingsState createState() => HighContrastSettingsState();
}

/// Esta classe retorna um widget referente ao estado da configuracao do contraste das cores.
class HighContrastSettingsState extends State<HighContrastSettings> {
  final settings = GetIt.I<Settings>();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Alto-contraste',
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                    settings.themeModel.changeTheme();
                  });
                },
                activeTrackColor: Colors.blue,
                activeColor: Colors.blue,
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Maior diferença de luminância/cor entre objetos (ajuda a distinguir melhor).',
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ],
      ),
    ));
  }
}

/// Esta classe retorna um widget referente a configuracao do tamanho da fonte.
class TextSize extends StatelessWidget {
  final settings = GetIt.I<Settings>();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: settings,
        builder: (context, widget) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Tamanho da fonte',
                    ),
                  ),
                  TextSizeSlider(),
                ],
              ),
            ),
          );
        });
  }
}

/// Esta classe retorna um widget com slider referente ao tamanho da fonte.
class TextSizeSlider extends StatelessWidget {
  final settings = GetIt.I<Settings>();

  @override
  Widget build(BuildContext context) {
    return Slider(
      value: settings.fontSize,
      min: 8,
      max: 18,
      divisions: 5,
      label: "${settings.fontSize}",
      onChanged: (newSliderValue) {
        settings.fontSize = newSliderValue;
      },
    );
  }
}

/// Esta classe retorna um widget referente a configuracao do tamanho da fonte.
class Logout extends StatelessWidget {
  final settings = GetIt.I<Settings>();

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Logout',
                textAlign: TextAlign.left,
              ),
              Spacer(),
              LogoutButton(),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Clique no botão ao lado para sair de sua conta.',
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ),
        ],
      ),
    ));
  }
}

/// Esta classe retorna um widget de logout de [User]
class LogoutButton extends StatelessWidget {
  final cart = GetIt.I<Cart>();
  final loggedUser = GetIt.I<User>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          SharedPrefs.contains("loggedUser").then((value) {
            if (value) {
              loggedUser.name = null;
              SharedPrefs.remove("loggedUser");
              cart.clean(); // limpa o carrinho.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
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
        child: Icon(
          Icons.power_settings_new,
          semanticLabel: "logout",
        ));
  }
}
