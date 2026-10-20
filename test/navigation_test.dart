import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sole_store/main.dart';
import 'package:sole_store/models/product.dart';
import 'package:sole_store/screens/product_detail_screen.dart';

void main() {
  testWidgets('Complete object, both back actions and persistent tabs', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const SoleStoreApp());
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, 'Outdoor'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Trail Explorer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Trail Explorer'));
    await tester.pumpAndSettle();
    final detail = tester.widget<ProductDetailScreen>(
      find.byType(ProductDetailScreen),
    );
    expect(identical(detail.product, products[2]), isTrue);
    expect(
      ModalRoute.of(tester.element(find.byType(ProductDetailScreen)))!
          .settings
          .arguments,
      same(products[2]),
    );
    expect(find.text(products[2].description), findsOneWidget);
    await tester.tap(find.byTooltip('Save favorite'));
    await tester.tap(find.byKey(const Key('add-to-cart')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('back-to-list')),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('back-to-list')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('back-to-list')));
    await tester.pumpAndSettle();
    expect(find.text('Bag (1)'), findsOneWidget);
    expect(
      tester
          .widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'Outdoor'))
          .selected,
      isTrue,
    );
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    expect(find.text('Trail Explorer'), findsOneWidget);
    await tester.ensureVisible(find.text('Trail Explorer'));
    await tester.tap(find.text('Trail Explorer'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<BottomNavigationBar>(find.byType(BottomNavigationBar))
          .currentIndex,
      1,
    );
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Feed'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<SwitchListTile>(find.byType(SwitchListTile)).value,
      isFalse,
    );
    await tester.tap(find.text('Favorites'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Remove favorite'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No favorites yet.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
