import 'package:flutter/material.dart';

import '../models/cloud_product.dart';
import '../services/product_api.dart';
import '../widgets/cloud_product_image.dart';
import 'cloud_product_detail_screen.dart';

class CloudProductsScreen extends StatefulWidget {
  final Future<List<Product>> Function()? fetchProducts;
  const CloudProductsScreen({super.key, this.fetchProducts});
  @override
  State<CloudProductsScreen> createState() => _CloudProductsScreenState();
}

class _CloudProductsScreenState extends State<CloudProductsScreen> {
  List<Product>? products;
  String? error;
  bool loading = true;
  int request = 0;
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final ticket = ++request;
    setState(() {
      loading = true;
      error = null;
    });
    try {
      final result =
          await (widget.fetchProducts?.call() ?? const ProductApi().fetch());
      if (!mounted || ticket != request) return;
      setState(() {
        products = result;
        loading = false;
      });
    } catch (e) {
      if (!mounted || ticket != request) return;
      setState(() {
        error = e is ProductApiException
            ? e.message
            : 'Unable to load products. Check your connection and retry.';
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('LW10 Cloud Explorer', overflow: TextOverflow.ellipsis),
    ),
    body: loading
        ? const Center(child: CircularProgressIndicator())
        : error != null
        ? Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off, size: 56),
                  const SizedBox(height: 16),
                  Text(error!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: load,
                    child: const Text('Retry Connection'),
                  ),
                ],
              ),
            ),
          )
        : RefreshIndicator(
            onRefresh: load,
            child: products!.isEmpty
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(height: 100),
                      Center(
                        child: Text(
                          'No products available. Pull down to refresh.',
                        ),
                      ),
                    ],
                  )
                : ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: products!.length,
                    separatorBuilder: (_, index) => const Divider(),
                    itemBuilder: (_, index) {
                      final p = products![index];
                      return ListTile(
                        key: ValueKey('cloud-${p.id}'),
                        leading: SizedBox(
                          width: 56,
                          height: 56,
                          child: Hero(
                            tag: 'product_image_${p.id}',
                            child: CloudProductImage(url: p.imageUrl),
                          ),
                        ),
                        title: Text(
                          p.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          '★ ${p.rating} (${p.reviewCount}) · USD ${p.price.toStringAsFixed(2)}',
                        ),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => ProductDetailScreen(product: p),
                          ),
                        ),
                      );
                    },
                  ),
          ),
  );
}
