class CatalogProduct {
  final String id, title, category;
  final int price;
  final double rating;
  const CatalogProduct({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    this.rating = 4.9,
  });
}

const catalogSeed = [
  CatalogProduct(
    id: 'runner',
    title: 'Everyday Runner',
    category: 'Lifestyle',
    price: 42900,
  ),
  CatalogProduct(
    id: 'court',
    title: 'Court Classic',
    category: 'Lifestyle',
    price: 38900,
  ),
  CatalogProduct(
    id: 'trail',
    title: 'Trail Explorer',
    category: 'Outdoor',
    price: 56900,
  ),
  CatalogProduct(
    id: 'tempo',
    title: 'Tempo Sport',
    category: 'Running',
    price: 49900,
  ),
];
