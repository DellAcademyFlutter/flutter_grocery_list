import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Models/UserSettings.dart';
import 'package:flutter_grocery_list/Models/user.dart';
import 'package:flutter_grocery_list/shared/theme_model.dart';
import 'package:flutter_grocery_list/shared_preferences/shared_prefs.dart';
import 'package:get_it/get_it.dart';

import '../shared/math_utils.dart';
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
          LightDarkTheme(),
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
            child: ListTile(
              title: Text(
                "Quantidade de produtos: ",
              ),
              trailing: Text(
                "${cart.qttItems}",
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
            child: ListTile(
              title: Text(
                "Valor total do carrinho: ",
              ),
              trailing: Text(
                "R\$ ${MathUtils.round(cart.totalValue, 2)}",
                textAlign: TextAlign.right,
              ),
            ),
          );
        });
  }
}

/// Esta classe retorna um widget referente a configuracao de tema escuro ou claro.
class LightDarkTheme extends StatefulWidget {
  @override
  LightDarkThemeState createState() => LightDarkThemeState();
}

/// Esta classe retorna um widget referente ao estado da configuracao de tema escuro ou claro.
class LightDarkThemeState extends State<LightDarkTheme> {
  final settings = GetIt.I<Settings>();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Tema'),
        subtitle: Text("${settings.themeDescription}"),
        trailing: LightDarkThemeDropDownButton(),
      ),
    );
  }
}

/// Esta classe retorna um widget de dropdown de menu escuro ou claro.
class LightDarkThemeDropDownButton extends StatefulWidget {
  LightDarkThemeDropDownButton({Key key}) : super(key: key);

  @override
  LightDarkThemeDropDownButtonState createState() =>
      LightDarkThemeDropDownButtonState();
}

/// Esta classe retorna um widget de dropdown de menu escuro ou claro.
class LightDarkThemeDropDownButtonState
    extends State<LightDarkThemeDropDownButton> {
  List<String> values = [
    'Sistema',
    'Tema Claro',
    'Tema Escuro',
    'Alto contraste'
  ];
  String dropdownValue = 'Sistema';
  final settings = GetIt.I<Settings>();

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue.toString(),
      icon: Icon(Icons.more_vert),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
          ThemeEnum theme;
          switch (newValue) {
            case 'Sistema':
              theme = ThemeEnum.system;
              settings.themeDescription = "Tema definido pelo sistema.";
              break;
            case 'Tema Escuro':
              theme = ThemeEnum.darkTheme;
              settings.themeDescription = "Tema com plano de fundo escuro.";
              break;
            case 'Alto contraste':
              theme = ThemeEnum.highContrast;
              settings.themeDescription =
                  "Tema com maior diferença de luz e cor entre objetos";
              break;
            default:
              theme = ThemeEnum.lightTheme;
              settings.themeDescription = "Tema com plano de fundo claro.";
              break;
          }
          settings.themeModel.changeTheme(theme: theme, context: context);
        });
      },
      items: values.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Tamanho da fonte',
                    ),
                  ),
                  Container(child: TextSizeSlider()),
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
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Slider(
            value: settings.fontSize,
            min: 14,
            max: 25,
            divisions: 6,
            label: "${settings.fontSize}",
            onChanged: (newSliderValue) {
              settings.fontSize = newSliderValue;
            },
          ),
          RaisedButton(
            child: Text('Tamanho padrão'),
            onPressed: settings.fontSize == settings.defaultFontSize
                ? null
                : () {
                    settings.fontSize = settings.defaultFontSize;
                  },
          )
        ],
      ),
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
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
              loggedUser.name = null;
              SharedPrefs.remove("loggedUser");
              cart.clean(); // limpa o carrinho.
            }
          });
        },
        child: Icon(
          Icons.power_settings_new,
          semanticLabel: "logout",
        ));
  }
}
