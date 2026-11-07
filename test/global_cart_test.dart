import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sole_store/main.dart';
import 'package:sole_store/providers/cart_provider.dart';
import 'package:sole_store/screens/global_catalog_screen.dart';

void main() {
  test('Cart selection, notifications, total and read-only items', () {
    final cart = CartProvider();
    addTearDown(cart.dispose);
    var changes = 0;
    cart.addListener(() => changes++);
    cart.toggle(cartCatalog[0]);
    cart.toggle(cartCatalog[1]);
    expect(cart.count, 2);
    expect(cart.totalPrice, 81800);
    expect(() => cart.items.clear(), throwsUnsupportedError);
    cart.toggle(cartCatalog[0]);
    expect(cart.count, 1);
    cart.remove(cartCatalog[1].id);
    expect(cart.totalPrice, 0);
    expect(changes, 4);
    cart.clear();
    expect(changes, 4);
  });
  testWidgets('Profile opens global catalog under root provider', (
    tester,
  ) async {
    await tester.pumpWidget(const SoleStoreApp());
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('LW9 Global Cart'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('LW9 Global Cart'));
    await tester.pumpAndSettle();
    expect(find.byType(GlobalCatalogScreen), findsOneWidget);
  });
  for (final size in [
    const Size(280, 568),
    const Size(390, 844),
    const Size(1440, 900),
  ]) {
    testWidgets('Multi-screen sync and layout $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final cart = CartProvider();
      addTearDown(cart.dispose);
      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: cart,
          child: const MaterialApp(home: GlobalCatalogScreen()),
        ),
      );
      await tester.tap(find.byKey(const ValueKey('toggle-runner')));
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const ValueKey('toggle-court')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('toggle-court')));
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const Key('cart-badge'))).data,
        '2',
      );
      await tester.tap(find.byKey(const Key('open-global-cart')));
      await tester.pumpAndSettle();
      expect(find.text('Total: KZT 81800'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('remove-runner')));
      await tester.pumpAndSettle();
      expect(find.text('Total: KZT 38900'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const Key('cart-badge'))).data,
        '1',
      );
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('toggle-runner')),
        -200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(const ValueKey('toggle-runner')));
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('toggle-runner')),
          matching: find.text('Add to Cart'),
        ),
        findsOneWidget,
      );
      await tester.tap(find.byKey(const Key('open-global-cart')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('clear-global-cart')));
      await tester.pumpAndSettle();
      expect(find.text('Your cart is empty'), findsOneWidget);
      expect(find.text('Total: KZT 0'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.byKey(const Key('cart-badge'))).data,
        '0',
      );
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('toggle-sprint')),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('Sprint Pro'), findsOneWidget);
      expect(cartCatalog.length, 6);
      expect(tester.takeException(), isNull);
    });
  }
}
