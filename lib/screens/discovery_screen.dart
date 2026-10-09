import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/product_art.dart';
import 'product_detail_screen.dart';
import 'registration_screen.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});
  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  final Set<String> favorites = {};
  final Map<String, int> cart = {};
  String category = 'All';
  int get cartCount => cart.values.fold(0, (a, b) => a + b);
  void toggleFavorite(String name) => setState(() {
    if (!favorites.add(name)) {
      favorites.remove(name);
    }
  });
  void showCart() => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (context) => SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your bag · $cartCount items',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              if (cart.isEmpty)
                const Text('Your next favorite pair is waiting.'),
              for (final entry in cart.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text('${entry.key} · Quantity: ${entry.value}'),
                ),
              if (cart.isNotEmpty)
                Text(
                  'Total: ${money(cart.entries.fold<int>(0, (sum, e) => sum + products.firstWhere((p) => e.key.startsWith('${p.name} /')).price * e.value))}',
                ),
              const SizedBox(height: 16),
              const Text(
                'Demo cart. Checkout is planned for a later milestone.',
              ),
            ],
          ),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final visible = products
        .where((p) => category == 'All' || p.category == category)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SOLE.',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 3),
        ),
        actions: [
          IconButton(
            tooltip: 'Create account',
            icon: const Icon(Icons.person_add_alt_1_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const RegistrationScreen(),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: showCart,
            icon: const Icon(Icons.shopping_bag_outlined),
            label: Text('Bag ($cartCount)'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'MOVE YOUR WAY',
                        style: TextStyle(
                          color: Color(0xFF315D45),
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Good shoes.\nGreat days.',
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Find your everyday pair. Made for wherever life takes you.',
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['All', 'Lifestyle', 'Running', 'Outdoor']
                            .map(
                              (c) => ChoiceChip(
                                label: Text(c),
                                selected: category == c,
                                onSelected: (_) => setState(() => category = c),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'The collection',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          Text('${visible.length} pairs'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) => SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: (constraints.crossAxisExtent / 260)
                          .floor()
                          .clamp(1, 4),
                      mainAxisExtent: 340,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final p = visible[index];
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => ProductDetailScreen(
                                product: p,
                                isFavorite: favorites.contains(p.name),
                                onFavorite: () => toggleFavorite(p.name),
                                onAdd: (size) => setState(
                                  () => cart.update(
                                    '${p.name} / EU $size',
                                    (n) => n + 1,
                                    ifAbsent: () => 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    ProductArt(product: p),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: IconButton.filledTonal(
                                        tooltip: favorites.contains(p.name)
                                            ? 'Remove favorite'
                                            : 'Save favorite',
                                        onPressed: () => toggleFavorite(p.name),
                                        icon: Icon(
                                          favorites.contains(p.name)
                                              ? Icons.bookmark
                                              : Icons.bookmark_border,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(p.category),
                                    Text(
                                      p.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 16,
                                      runSpacing: 4,
                                      children: [
                                        Text(
                                          money(p.price),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text('★ 4.9'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }, childCount: visible.length),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
