import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/cloud_product.dart';
import '../providers/cloud_cart_provider.dart';
import '../widgets/cloud_product_image.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});
  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int page = 0;
  void share() => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          24,
          24,
          24 + MediaQuery.viewInsetsOf(sheetContext).bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Share product',
              style: Theme.of(sheetContext).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SelectableText(widget.product.deepLink),
            const SizedBox(height: 16),
            FilledButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Copy link'),
              onPressed: () async {
                try {
                  await Clipboard.setData(
                    ClipboardData(text: widget.product.deepLink),
                  );
                  if (!sheetContext.mounted) return;
                  Navigator.pop(sheetContext);
                  if (!mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Link copied')));
                } catch (_) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Could not copy. Select the link to copy manually.',
                        ),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final added = context.watch<CloudCartProvider>().contains(p.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product details'),
        actions: [
          IconButton(
            tooltip: 'Share product',
            onPressed: share,
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: PageView.builder(
                  itemCount: 3,
                  onPageChanged: (value) => setState(() => page = value),
                  itemBuilder: (_, index) {
                    final image = ColoredBox(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(index == 1 ? 0 : 24),
                        child: CloudProductImage(
                          url: p.imageUrl,
                          fit: index == 1 ? BoxFit.cover : BoxFit.contain,
                        ),
                      ),
                    );
                    final view = index == 2
                        ? Transform.scale(scale: .75, child: image)
                        : image;
                    return index == 0
                        ? Hero(tag: 'product_image_${p.id}', child: view)
                        : view;
                  },
                ),
              ),
              const SizedBox(height: 12),
              Text('${page + 1} / 3', textAlign: TextAlign.center),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: page == index ? 22 : 8,
                    height: 8,
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: page == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const Text(
                'One API photo · standard, crop and wide views',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 20),
              Text(p.title, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text(
                'USD ${p.price.toStringAsFixed(2)} · ★ ${p.rating} (${p.reviewCount} reviews)',
              ),
              const SizedBox(height: 12),
              Wrap(children: [Chip(label: Text(p.category))]),
              const SizedBox(height: 12),
              Text(p.description, style: const TextStyle(height: 1.5)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: added
                ? null
                : () {
                    context.read<CloudCartProvider>().add(p);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Added to cloud cart')),
                    );
                  },
            icon: Icon(added ? Icons.check : Icons.add_shopping_cart),
            label: Text(added ? 'Added to Cart' : 'Add to Cart'),
          ),
        ),
      ),
    );
  }
}
