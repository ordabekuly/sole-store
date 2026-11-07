import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sole_store/screens/smart_catalog_screen.dart';

void main() {
  testWidgets('Delete, undo original index, refresh prepends, empty reset', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SmartCatalogScreen()));
    await tester.drag(
      find.byKey(const ValueKey('court')),
      const Offset(-700, 0),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('court')), findsNothing);
    await tester.tap(find.text('UNDO'));
    await tester.pumpAndSettle();
    expect(
      find
          .byType(Dismissible)
          .evaluate()
          .map((e) => (e.widget.key! as ValueKey).value),
      ['runner', 'court', 'trail', 'tempo'],
    );
    final refresh = tester.widget<RefreshIndicator>(
      find.byType(RefreshIndicator),
    );
    final pending = refresh.onRefresh();
    await tester.pump(const Duration(milliseconds: 1499));
    expect(find.text('New arrival 1'), findsNothing);
    await tester.pump(const Duration(milliseconds: 1));
    await pending;
    await tester.pumpAndSettle();
    expect(
      (tester.widget<Dismissible>(find.byType(Dismissible).first).key!
              as ValueKey)
          .value,
      'generated-1',
    );
    for (final id in ['generated-1', 'runner', 'court', 'trail', 'tempo']) {
      await tester.drag(find.byKey(ValueKey(id)), const Offset(-700, 0));
      await tester.pumpAndSettle();
    }
    expect(find.text('Catalog is Empty'), findsOneWidget);
    await tester.tap(find.text('Reset Catalog'));
    await tester.pumpAndSettle();
    expect(find.byType(Dismissible), findsNWidgets(4));
  });
  for (final size in [
    const Size(280, 568),
    const Size(390, 844),
    const Size(1440, 900),
  ]) {
    testWidgets('Both views fit $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const MaterialApp(home: SmartCatalogScreen()));
      await tester.tap(find.byTooltip('Show grid'));
      await tester.pumpAndSettle();
      expect(find.byType(GridView), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.byTooltip('Show list'));
      await tester.pumpAndSettle();
      expect(find.byType(Dismissible), findsNWidgets(4));
      expect(tester.takeException(), isNull);
    });
  }
}
