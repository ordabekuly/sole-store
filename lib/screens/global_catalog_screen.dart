import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import 'global_cart_screen.dart';

class GlobalCatalogScreen extends StatelessWidget {
  const GlobalCatalogScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('LW9 Catalog', overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            key: const Key('open-global-cart'),
            tooltip: 'Open cart',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(builder: (_) => const GlobalCartScreen()),
            ),
            icon: Badge(
              label: Text('${cart.count}', key: const Key('cart-badge')),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: cartCatalog.length,
        separatorBuilder: (_, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final product = cartCatalog[index];
          final selected = cart.contains(product.id);
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text('${product.category} · KZT ${product.price}'),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    key: ValueKey('toggle-${product.id}'),
                    onPressed: () =>
                        context.read<CartProvider>().toggle(product),
                    icon: Icon(
                      selected ? Icons.check : Icons.add_shopping_cart,
                    ),
                    label: Text(selected ? 'Remove from Cart' : 'Add to Cart'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
