import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/cloud_product.dart';

class ProductApiException implements Exception {
  final String message;
  const ProductApiException(this.message);
  @override
  String toString() => message;
}

class ProductApi {
  static final endpoint = Uri.parse('https://fakestoreapi.com/products');
  final http.Client? client;
  final Duration timeout;
  const ProductApi({this.client, this.timeout = const Duration(seconds: 10)});
  Future<List<Product>> fetch() async {
    try {
      final response =
          await (client == null ? http.get(endpoint) : client!.get(endpoint))
              .timeout(timeout);
      if (response.statusCode != 200) {
        throw ProductApiException(switch (response.statusCode) {
          404 => 'Products not found (HTTP 404). Please retry later.',
          >= 500 =>
            'Store server is unavailable (HTTP ${response.statusCode}). Please retry.',
          _ => 'Request failed (HTTP ${response.statusCode}). Please retry.',
        });
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw const FormatException('Expected a product list');
      }
      final products = decoded.map((item) {
        if (item is! Map<String, dynamic>) {
          throw const FormatException('Invalid product');
        }
        return Product.fromJson(item);
      }).toList();
      if (products.map((p) => p.id).toSet().length != products.length) {
        throw const FormatException('Duplicate product IDs');
      }
      return products;
    } on ProductApiException {
      rethrow;
    } on TimeoutException {
      throw const ProductApiException(
        'Connection timed out after 10 seconds. Check your internet and retry.',
      );
    } on FormatException {
      throw const ProductApiException(
        'The store returned invalid product data. Please retry.',
      );
    } on http.ClientException {
      throw const ProductApiException(
        'Cannot reach the store. Check your connection and retry.',
      );
    } catch (_) {
      throw const ProductApiException(
        'Could not load products. Check your connection and retry.',
      );
    }
  }
}
