import '../lib/services/product_api.dart';

Future<void> main() async {
  final products = await const ProductApi().fetch();
  print('LIVE_CLOUD_API_OK count=${products.length}');
}
