import 'package:flutter/material.dart';

import '../models/catalog_product.dart';
import '../widgets/catalog_tile.dart';

class SmartCatalogScreen extends StatefulWidget {
  const SmartCatalogScreen({super.key});
  @override
  State<SmartCatalogScreen> createState() => _SmartCatalogScreenState();
}

class _SmartCatalogScreenState extends State<SmartCatalogScreen> {
  final List<CatalogProduct> items = List.of(catalogSeed);
  bool grid = false;
  bool refreshing = false;
  int sequence = 0;
  Future<void> refresh() async {
    if (refreshing) return;
    refreshing = true;
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() {
      sequence++;
      items.insert(
        0,
        CatalogProduct(
          id: 'generated-$sequence',
          title: 'New arrival $sequence',
          category: 'New season',
          price: 35000 + sequence * 100,
        ),
      );
      refreshing = false;
    });
  }

  void remove(CatalogProduct product) {
    final index = items.indexWhere((p) => p.id == product.id);
    if (index < 0) return;
    setState(() => items.removeAt(index));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('${product.title} removed'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              if (!mounted || items.any((p) => p.id == product.id)) return;
              setState(
                () => items.insert(index.clamp(0, items.length), product),
              );
            },
          ),
        ),
      );
  }

  void reset() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() {
      items.clear();
      items.addAll(catalogSeed);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Smart Catalog', overflow: TextOverflow.ellipsis),
      actions: [
        IconButton(
          tooltip: grid ? 'Show list' : 'Show grid',
          onPressed: () => setState(() => grid = !grid),
          icon: Icon(grid ? Icons.view_list : Icons.grid_view),
        ),
      ],
    ),
    body: SafeArea(
      child: RefreshIndicator(
        onRefresh: refresh,
        child: items.isEmpty
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(32),
                children: [
                  const SizedBox(height: 70),
                  const Icon(Icons.inventory_2_outlined, size: 64),
                  const SizedBox(height: 16),
                  const Text('Catalog is Empty', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: reset,
                    child: const Text('Reset Catalog'),
                  ),
                ],
              )
            : grid
            ? GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.72,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: items.length,
                itemBuilder: (_, index) => CatalogTile(
                  key: ValueKey(items[index].id),
                  product: items[index],
                  grid: true,
                ),
              )
            : ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, index) =>
                    const Divider(height: 1, thickness: 0.5),
                itemBuilder: (_, index) {
                  final product = items[index];
                  return Dismissible(
                    key: ValueKey(product.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => remove(product),
                    child: CatalogTile(product: product),
                  );
                },
              ),
      ),
    ),
  );
}
