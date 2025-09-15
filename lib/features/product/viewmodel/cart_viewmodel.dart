import 'package:flutter/material.dart';
import 'package:uc_coffee_shop/features/product/model/product_model.dart';

class CartViewModel extends ChangeNotifier {
  final Map<ProductModel, int> _cartItems = {};

  Map<ProductModel, int> get cartItems => _cartItems;

  void addToCart(ProductModel product) {
    if (_cartItems.containsKey(product)) {
      _cartItems[product] = _cartItems[product]! + 1;
    } else {
      _cartItems[product] = 1;
    }
    notifyListeners();
  }

  void removeFromCart(ProductModel product) {
    if (_cartItems.containsKey(product) && _cartItems[product]! > 1) {
      _cartItems[product] = _cartItems[product]! - 1;
    } else {
      _cartItems.remove(product);
    }
    notifyListeners();
  }

  double get totalPrice {
    return _cartItems.entries.fold(
        0,
        (total, current) =>
            total + (current.key.price ?? 0) * current.value);
  }

  int get totalItems {
    return _cartItems.values.fold(0, (total, current) => total + current);
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}
