import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cartitem.dart';


class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];  // private value
  List<CartItem> get items => _items;  // public read value

  void addItem(Product product) {
    int index = _items.indexWhere((item) => item.product.id == product.id);
    if(index>=0){
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeItem(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void clear() {
    _items = [];
    notifyListeners();
  }

  double get totalAmount {
    double total = 0.0;
    for(var item in _items) {
      total += item.product.price * item.quantity;
    }

    return total;
  }
}