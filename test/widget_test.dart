import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('teste de carrinho', () {

   /// Teste para verificacao do preço total do carrinho
   test('Teste de soma do preço total do carrinho', () {
     Cart carrinho = Cart(id: 0);

     //carrinho.addItem(0, 'Usuario 1', 'Brownie', 2.50, 1, false);
     //carrinho.addItem(0, 'Usuario 1', 'Chocolate', 0.50, 1, false);

     expect(carrinho.totalValueCart, 3.0);
   });

   /// Teste para verificacao do item comprado
   test('Teste para verificacao do item comprado', () {
     Cart carrinho = Cart(id: 0);

    // carrinho.addItem(0, 'Usuario 1', 'Carne', 15.0, 1, true);
     //carrinho.addItem(0, 'Usuario 1', 'Frango', 13.50, 1, false);

     expect(carrinho.cartList[0].isDone, true);
   });
 });

}


