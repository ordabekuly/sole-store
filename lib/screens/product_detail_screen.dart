import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/product_art.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final ValueChanged<int> onAdd;
  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavorite,
    required this.onAdd,
  });
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late bool saved = widget.isFavorite;
  int selectedSize = 40;
  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product preview',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: AspectRatio(
                  aspectRatio: 1.25,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ProductArt(product: p),
                      const Positioned(
                        top: 16,
                        left: 16,
                        child: Chip(label: Text('NEW SEASON')),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: IconButton.filled(
                          tooltip: saved ? 'Remove favorite' : 'Save favorite',
                          onPressed: () {
                            setState(() => saved = !saved);
                            widget.onFavorite();
                          },
                          icon: Icon(
                            saved ? Icons.bookmark : Icons.bookmark_border,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      p.name,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 18,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    money(p.price),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star_rounded, color: Color(0xFFC38F2E)),
                      Flexible(
                        child: Text(
                          '4.9 · 128 reviews',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  p.category,
                  'Unisex',
                  'Lightweight',
                ].map((tag) => Chip(label: Text(tag))).toList(),
              ),
              const SizedBox(height: 16),
              Text(
                'Made for your everyday',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text(
                'Light on your feet. Easy on your day. A breathable upper and soft cushioning make this your go-to pair for campus, coffee runs and everything in between.',
                style: TextStyle(height: 1.6),
              ),
              const SizedBox(height: 24),
              Text(
                'Select size · EU $selectedSize',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [38, 39, 40, 41, 42, 43, 44]
                    .map(
                      (size) => ChoiceChip(
                        label: Text('$size'),
                        selected: selectedSize == size,
                        onSelected: (_) => setState(() => selectedSize = size),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              const Text(
                'Free delivery · 14-day returns',
                style: TextStyle(color: Color(0xFF315D45)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  key: const Key('add-to-cart'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  onPressed: () {
                    widget.onAdd(selectedSize);
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text(
                            '${p.name} · EU $selectedSize added to your bag',
                          ),
                        ),
                      );
                  },
                  icon: const Icon(Icons.shopping_bag_outlined),
                  label: const Text('Add to Cart'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
