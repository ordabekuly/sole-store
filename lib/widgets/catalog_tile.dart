import 'package:flutter/material.dart';

import '../models/catalog_product.dart';

class CatalogTile extends StatelessWidget {
  final CatalogProduct product;
  final bool grid;
  const CatalogTile({super.key, required this.product, this.grid = false});
  @override
  Widget build(BuildContext context) {
    final details = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 4),
        Text(
          product.category,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 4),
        Text('★ ${product.rating}', style: const TextStyle(fontSize: 12)),
        Text(
          'KZT ${product.price}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ],
    );
    if (!grid) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const CircleAvatar(child: Icon(Icons.shopping_bag_outlined)),
            const SizedBox(width: 12),
            Expanded(child: details),
          ],
        ),
      );
    }
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ColoredBox(
                color: const Color(0xFFDCE5D5),
                child: const Center(
                  child: Icon(Icons.shopping_bag_outlined, size: 32),
                ),
              ),
            ),
            const SizedBox(height: 8),
            details,
          ],
        ),
      ),
    );
  }
}
