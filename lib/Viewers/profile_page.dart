import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Models/settings.dart';
import 'package:flutter_grocery_list/Models/user.dart';
import 'package:flutter_grocery_list/shared/math_utils.dart';
import 'package:flutter_grocery_list/shared/theme_model.dart';
import 'package:flutter_grocery_list/shared_preferences/shared_prefs.dart';
import 'package:get_it/get_it.dart';

import 'login_page.dart';

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
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          CircleAvatar(
            radius: 100.0,
            backgroundImage: NetworkImage(
                "https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png"),
            backgroundColor: Colors.transparent,
          ),
          Text(
            "${loggedUser.name}",
            //style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          SizedBox(height: 20.0),
        ListTile(
          title:Text(
            "Quantidade de produtos: ",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          trailing: Text("${cart.qttItems}",
              style: TextStyle(fontSize: 20, color: Colors.black),),
        ),
          ListTile(
            title:Text(
              "Valor total da lista de produtos: ",
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            trailing: Text("${cart.totalValue}",
              style: TextStyle(fontSize: 20, color: Colors.black),),
          ),
          ListTile(
            title: Text(
              'Alto-contraste',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Maior diferença de luminância/cor entre objetos (ajuda a distinguir melhor).',
              style: TextStyle(fontSize: 18),
            ),
            trailing: Switch(
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
            isThreeLine: true,
          ),
          ListTile(
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Clique no botão ao lado para sair de sua conta.',
              style: TextStyle(fontSize: 18),
            ),
            trailing: Logout(),
            isThreeLine: true,
          ),
          AnimatedBuilder(
            animation: settings,
            builder: (context, widget) {
              return ListTile(
                title: Text(
                  'Font Size',
                //  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Aumento de fonte - ${settings.fontSize}',
                  style: TextStyle(fontSize: 18),
                ),
                trailing: Container(
                  child: InkWell(
                    onTap: ()=>settings.increment(),
                    child: Text("+"),
                  ),
                ),
                isThreeLine: true,
              );
            }
          )
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
      title:Text(
        "Qtd. produtos: ${cart.qttItems}",
        style: TextStyle(fontSize: 15, color: Colors.black),
        textAlign: TextAlign.center,
      ),
      subtitle: Text(
        "Valor total: R\$ ${MathUtils.round(cart.totalValue, 3)}",
        style: TextStyle(fontSize: 15, color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// Esta classe retorna um widget de logout de [User]
class Logout extends StatelessWidget {
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
