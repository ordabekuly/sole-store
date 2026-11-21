// ignore_for_file: avoid_print
import 'package:sole_store/services/product_api.dart';

Future<void> main() async {
  final products = await const ProductApi().fetch();
  print('LIVE_CLOUD_API_OK count=${products.length}');
}
