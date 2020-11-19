import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Models/item.dart';
import 'package:flutter_grocery_list/shared/theme_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Change theme tests', () {
    final themeModel = ThemeModel();

    themeModel.changeTheme(theme: ThemeEnum.darkTheme);

    expect(themeModel.appTheme, ThemeEnum.darkTheme);
  });

  test('Add item to cartList', () {
    final cart = Cart();

    cart.addItemNamed(id : 1, fqUserId : "1", name : "Manga", description : "Fruta", value : 0.20, qtt : 3, isDone : false);
    cart.addItemNamed(id : 6, fqUserId : "1", name : "Jaca", description : "Fruta", value : 0.20, qtt : 3, isDone : false);

    cart.itemList.insert(0, Item(id : 6, fqUserId : "1", name : "Goiaba", description : "Fruta", value : 0.20, qtt : 3, isDone : false));

    expect(cart.itemList[1].name, "Manga");
    //expect(cart.itemList.length, 3);
  });

}
