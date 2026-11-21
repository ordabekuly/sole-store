import 'package:flutter/foundation.dart';

import '../models/cloud_product.dart';

class CloudCartProvider extends ChangeNotifier {
  final Map<int, Product> _items = {};
  int get count => _items.length;
  bool contains(int id) => _items.containsKey(id);
  void add(Product product) {
    if (_items.containsKey(product.id)) return;
    _items[product.id] = product;
    notifyListeners();
  }
}
