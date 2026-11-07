import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class GlobalCartScreen extends StatelessWidget {
  const GlobalCartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: Text('Cart (${cart.count})')),
      body: cart.count == 0
          ? const Center(child: Text('Your cart is empty'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cart.count,
              separatorBuilder: (_, index) => const Divider(),
              itemBuilder: (context, index) {
                final product = cart.items[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(product.title),
                  subtitle: Text('KZT ${product.price}'),
                  trailing: IconButton(
                    key: ValueKey('remove-${product.id}'),
                    tooltip: 'Remove ${product.title}',
                    onPressed: () =>
                        context.read<CartProvider>().remove(product.id),
                    icon: const Icon(Icons.delete_outline),
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Total: KZT ${cart.totalPrice}',
                key: const Key('cart-total'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              FilledButton(
                key: const Key('clear-global-cart'),
                onPressed: cart.count == 0
                    ? null
                    : () => context.read<CartProvider>().clear(),
                child: const Text('Clear All'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
