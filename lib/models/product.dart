import 'package:flutter/material.dart';

class Product {
  final String name, category;
  final int price;
  final Color color;
  const Product(this.name, this.category, this.price, this.color);
}

const products = [
  Product('Everyday Runner', 'Lifestyle', 42900, Color(0xFFDCE5D5)),
  Product('Court Classic', 'Lifestyle', 38900, Color(0xFFE9DFCE)),
  Product('Trail Explorer', 'Outdoor', 56900, Color(0xFFD6DFE8)),
  Product('Tempo Sport', 'Running', 49900, Color(0xFFE9D9D4)),
];

String money(int value) => '₸ $value';
