import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'package:provider/provider.dart';

class Cart with ChangeNotifier, DiagnosticableTreeMixin {
  List<Map<String, dynamic>> _cart = [];

  int get count => _cart.length;
  List get cart => _cart;

  // void increment() {
  //   _count++;
  //   notifyListeners();
  // }

  void addToCart(item) {
    // increment object's count if the product is the same
    final existingObject =
        _cart.firstWhereOrNull((element) => element['id'] == item['id']);
    if (existingObject != null) {
      _cart[_cart.indexWhere((element) => element['id'] == item['id'])]
          .update('count', (value) => value = value + 1);
    } else {
      // or just add a new
      _cart.add(item);
    }
    notifyListeners();
  }

  int getCount(id) {
    if (cart.isNotEmpty) {
      return _cart[_cart.indexWhere((element) => element['id'] == id)]
              ['count'] ??
          1;
    } else {
      return 1;
    }
  }

  void increment(id) {
    _cart[_cart.indexWhere((element) => element['id'] == id)]
        .update('count', (value) => value = value + 1);
    notifyListeners();
  }

  void decrement(id) {
    if (_cart[_cart.indexWhere((element) => element['id'] == id)]['count'] >
        1) {
      _cart[_cart.indexWhere((element) => element['id'] == id)]
          .update('count', (value) => value = value - 1);
    } else {
      removeFromCart(id);
    }
    notifyListeners();
  }

  void removeFromCart(id) {
    _cart.removeWhere((element) => id == element['id']);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  /// Makes `Cart` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
  }
}
