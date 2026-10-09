import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sole_store/main.dart';

void main() {
  for (final size in [
    const Size(280, 568),
    const Size(320, 568),
    const Size(390, 844),
    const Size(1024, 768),
    const Size(1440, 900),
  ]) {
    testWidgets('Layout and interactions at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const SoleStoreApp());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.scrollUntilVisible(
        find.text('Everyday Runner'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Everyday Runner'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Everyday Runner'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Save favorite'));
      await tester.pumpAndSettle();
      expect(find.byTooltip('Remove favorite'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('41'),
        150,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('41'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('41'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('add-to-cart')));
      await tester.pumpAndSettle();
      expect(find.textContaining('EU 41 added'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Bag (1)'), findsOneWidget);
      await tester.tap(find.text('Bag (1)'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Quantity: 1'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
