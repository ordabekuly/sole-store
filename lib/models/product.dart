import 'package:flutter/material.dart';

class Product {
  final String name, category, description, imageAsset;
  final int price;
  final Color color;
  const Product(
    this.name,
    this.category,
    this.price,
    this.color, {
    required this.description,
    required this.imageAsset,
  });
}

const products = [
  Product(
    'Everyday Runner',
    'Lifestyle',
    42900,
    Color(0xFFDCE5D5),
    description: 'Light on your feet. Easy on your day. Breathable knit and soft cushioning for campus, coffee runs and everything in between.',
    imageAsset: 'assets/products/runner.png',
  ),
  Product(
    'Court Classic',
    'Lifestyle',
    38900,
    Color(0xFFE9DFCE),
    description: 'A clean court-inspired silhouette with a padded collar and a durable sole. Classic comfort for your everyday wardrobe.',
    imageAsset: 'assets/products/court.png',
  ),
  Product(
    'Trail Explorer',
    'Outdoor',
    56900,
    Color(0xFFD6DFE8),
    description: 'Take the long way home. A grippy outsole and supportive fit for city paths and weekend trails.',
    imageAsset: 'assets/products/trail.png',
  ),
  Product(
    'Tempo Sport',
    'Running',
    49900,
    Color(0xFFE9D9D4),
    description: 'Find your rhythm with responsive cushioning and lightweight mesh. Built for daily runs and active afternoons.',
    imageAsset: 'assets/products/tempo.png',
  ),
];
String money(int value) => '₸ $value';
