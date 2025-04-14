// cart_provider.dart
import 'package:flutter/material.dart';
import 'package:wall_eat_project/model/cart.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;
  double get totalPrice => _items.fold(0, (sum, item) => sum + item.total);

  void addItem(CartItem newItem) {
    final existingIndex = _items.indexWhere((item) => item.productId == newItem.productId);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(newItem);
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}