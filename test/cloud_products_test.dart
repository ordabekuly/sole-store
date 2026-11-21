import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:provider/provider.dart';
import 'package:sole_store/models/cloud_product.dart';
import 'package:sole_store/services/product_api.dart';
import 'package:sole_store/providers/cloud_cart_provider.dart';
import 'package:sole_store/screens/cloud_products_screen.dart';
import 'package:sole_store/screens/cloud_product_detail_screen.dart';
import 'package:sole_store/main.dart';

const sample = {
  'id': 1,
  'title': 'Cloud shoe',
  'price': 29,
  'description': 'Cloud product description',
  'category': 'Shoes',
  'image': '',
  'rating': {'rate': 4, 'count': 8},
};
void main() {
  test('JSON integer/double, null and malformed fields are safe', () {
    final p = Product.fromJson(sample);
    expect(p.price, 29.0);
    expect(p.rating, 4.0);
    expect(p.reviewCount, 8);
    expect(Product.fromJson({...sample, 'price': 29.99}).price, 29.99);
    expect(Product.fromJson({}).title, 'Untitled product');
    expect(Product.fromJson({'price': 'invalid', 'rating': false}).price, 0);
    expect(Product.fromJson({'price': double.nan}).price, 0);
  });
  test('GET 200 decodes real API shape', () async {
    final client = MockClient((request) async {
      expect(request.url, ProductApi.endpoint);
      expect(request.method, 'GET');
      return http.Response(jsonEncode([sample]), 200);
    });
    addTearDown(client.close);
    expect((await ProductApi(client: client).fetch()).single.id, 1);
  });
  for (final code in [404, 500, 403]) {
    test('HTTP $code gives actionable error', () async {
      final client = MockClient((_) async => http.Response('', code));
      addTearDown(client.close);
      await expectLater(
        ProductApi(client: client).fetch(),
        throwsA(
          isA<ProductApiException>().having(
            (e) => e.message,
            'status',
            contains('$code'),
          ),
        ),
      );
    });
  }
  test('Offline, timeout and invalid JSON are caught', () async {
    for (final failure in [
      http.ClientException('offline'),
      TimeoutException('timeout'),
    ]) {
      final client = MockClient((_) async => throw failure);
      addTearDown(client.close);
      await expectLater(
        ProductApi(client: client).fetch(),
        throwsA(isA<ProductApiException>()),
      );
    }
    final client = MockClient((_) async => http.Response('{}', 200));
    addTearDown(client.close);
    await expectLater(
      ProductApi(client: client).fetch(),
      throwsA(isA<ProductApiException>()),
    );
    final waiting = MockClient((_) => Completer<http.Response>().future);
    addTearDown(waiting.close);
    await expectLater(
      ProductApi(client: waiting, timeout: Duration.zero).fetch(),
      throwsA(
        isA<ProductApiException>().having(
          (e) => e.message,
          'timeout',
          contains('timed out'),
        ),
      ),
    );
  });
  testWidgets('Profile opens cloud route', (tester) async {
    await tester.pumpWidget(const SoleStoreApp());
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('LW10 Cloud Explorer'));
    await tester.pumpAndSettle();
    // The real network is deliberately not started by this navigation-presence check.
    expect(find.text('LW10 Cloud Explorer'), findsOneWidget);
  });
  testWidgets(
    'Loading -> error -> retry -> success -> pull refresh and dispose',
    (tester) async {
      final first = Completer<List<Product>>();
      var calls = 0;
      Future<List<Product>> fetch() {
        calls++;
        return calls == 1
            ? first.future
            : Future.value([Product.fromJson(sample)]);
      }

      await tester.pumpWidget(
        MaterialApp(home: CloudProductsScreen(fetchProducts: fetch)),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      first.completeError(const ProductApiException('Offline test'));
      await tester.pumpAndSettle();
      expect(find.text('Offline test'), findsOneWidget);
      await tester.tap(find.text('Retry Connection'));
      await tester.pumpAndSettle();
      expect(find.text('Cloud shoe'), findsOneWidget);
      expect(calls, 2);
      await tester.drag(find.byType(ListView), const Offset(0, 400));
      await tester.pumpAndSettle();
      expect(calls, 3);
      final pending = Completer<List<Product>>();
      await tester.pumpWidget(
        MaterialApp(
          home: CloudProductsScreen(
            key: const Key('pending'),
            fetchProducts: () => pending.future,
          ),
        ),
      );
      await tester.pumpWidget(const SizedBox());
      pending.complete([Product.fromJson(sample)]);
      await tester.pump();
      expect(tester.takeException(), isNull);
    },
  );
  for (final size in [
    const Size(280, 568),
    const Size(390, 844),
    const Size(1440, 900),
  ]) {
    testWidgets('Hero, carousel, copy and cart at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final cart = CloudCartProvider();
      addTearDown(cart.dispose);
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = (call.arguments as Map)['text'] as String;
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: cart,
          child: MaterialApp(
            home: CloudProductsScreen(
              fetchProducts: () async => [Product.fromJson(sample)],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate((w) => w is Hero && w.tag == 'product_image_1'),
        findsOneWidget,
      );
      await tester.tap(find.text('Cloud shoe'));
      await tester.pumpAndSettle();
      expect(find.byType(ProductDetailScreen), findsOneWidget);
      expect(find.text('1 / 3'), findsOneWidget);
      await tester.drag(
        find.byType(PageView),
        Offset(-tester.getSize(find.byType(PageView)).width * .8, 0),
      );
      await tester.pumpAndSettle();
      expect(find.text('2 / 3'), findsOneWidget);
      await tester.tap(find.text('Add to Cart'));
      await tester.pumpAndSettle();
      expect(cart.count, 1);
      expect(find.text('Added to Cart'), findsOneWidget);
      await tester.tap(find.byTooltip('Share product'));
      await tester.pumpAndSettle();
      expect(find.text('narxoz://store/product/1'), findsOneWidget);
      await tester.tap(find.text('Copy link'));
      await tester.pumpAndSettle();
      expect(copied, 'narxoz://store/product/1');
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Cloud shoe'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
