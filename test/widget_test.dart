// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_grocery_list/Models/cart.dart';
import 'package:flutter_grocery_list/Models/item.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_grocery_list/main.dart';
import 'package:get_it/get_it.dart';

void main() {
  /// Teste para verificacao do preço total do carrinho
  test('Teste do preço total do carrinho', () {
    Cart cart = Cart(id: 0);

    cart.addItem(id: 0, fqUserId: 'anonimo', name:'item 1', description:'item 1', value:2.0, qtt:2, isDone: false);
    cart.addItem(id: 1, fqUserId: 'anonimo', name:'item 2', description:'item 2', value:3.0, qtt:2, isDone: false);

    expect(cart.totalValue, 10.0);
  });

  /// Teste para verificacao do item comprado
  test('Teste para verificacao do item comprado', () {
    Cart cart = Cart(id: 0);

    cart.addItem(id: 0, fqUserId: 'anonimo', name:'item 1', description:'item 1', value:2.0, qtt:2, isDone: false);
    cart.addItem(id: 1, fqUserId: 'anonimo', name:'item 2', description:'item 2', value:3.0, qtt:2, isDone: false);
    cart.checkItem(0);

    expect(cart.itemList[0].isDone, true);
  });

  /// Teste para verificacao do login de usuario
  test('Teste para verificacao do login de usuario', () {
    
  });

}
