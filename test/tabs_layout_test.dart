import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sole_store/main.dart';

void main() {
  for (final size in [
    const Size(280, 568),
    const Size(390, 844),
    const Size(1440, 900),
  ]) {
    testWidgets('All root tabs fit $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const SoleStoreApp());
      await tester.pumpAndSettle();
      await tester.tap(find.text('Favorites'));
      await tester.pumpAndSettle();
      expect(find.textContaining('No favorites yet.'), findsOneWidget);
      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();
      expect(find.text('Your profile'), findsOneWidget);
      await tester.tap(find.text('Feed'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
