import 'package:flutter/foundation.dart';

import '../models/catalog_product.dart';

const cartCatalog = [
  ...catalogSeed,
  CatalogProduct(
    id: 'urban',
    title: 'Urban Walk',
    category: 'Lifestyle',
    price: 32900,
  ),
  CatalogProduct(
    id: 'sprint',
    title: 'Sprint Pro',
    category: 'Running',
    price: 62900,
  ),
];

/// LW9 selection cart: each product can be selected once.
class CartProvider extends ChangeNotifier {
  final Map<String, CatalogProduct> _selected = {};
  List<CatalogProduct> get items => List.unmodifiable(_selected.values);
  int get count => _selected.length;
  int get totalPrice =>
      _selected.values.fold(0, (sum, product) => sum + product.price);
  bool contains(String id) => _selected.containsKey(id);
  void toggle(CatalogProduct product) {
    if (_selected.containsKey(product.id)) {
      _selected.remove(product.id);
    } else {
      _selected[product.id] = product;
    }
    notifyListeners();
  }

  void remove(String id) {
    if (_selected.remove(id) != null) notifyListeners();
  }

  void clear() {
    if (_selected.isEmpty) return;
    _selected.clear();
    notifyListeners();
  }
}
