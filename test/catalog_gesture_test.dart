import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sole_store/main.dart';
import 'package:sole_store/screens/smart_catalog_screen.dart';

void main() {
  testWidgets('Profile opens LW8', (tester) async {
    await tester.pumpWidget(const SoleStoreApp());
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('LW8 Smart Catalog'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('LW8 Smart Catalog'));
    await tester.pumpAndSettle();
    expect(find.byType(SmartCatalogScreen), findsOneWidget);
  });
  for (final grid in [false, true]) {
    testWidgets('Real pull gesture refreshes grid=$grid', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: SmartCatalogScreen()));
      if (grid) {
        await tester.tap(find.byTooltip('Show grid'));
        await tester.pumpAndSettle();
      }
      await tester.drag(
        find.byType(grid ? GridView : ListView),
        const Offset(0, 400),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text('New arrival 1'), findsOneWidget);
    });
  }
}
