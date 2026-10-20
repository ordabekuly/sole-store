// Records real Flutter-rendered frames, including Navigator route animations.
// Run: flutter test tool/record_navigation_test.dart
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sole_store/main.dart';

void main() {
  testWidgets('Record LAB 7 screen transitions', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    // Load the SDK font so the recording uses the app font, not test Ahem.
    final sdk =
        Platform.environment['FLUTTER_ROOT'] ??
        File(Platform.resolvedExecutable)
            .parent
            .parent
            .parent
            .parent
            .parent
            .path;
    await tester.runAsync(() async {
      final loader = FontLoader('Roboto');
      loader.addFont(
        File('$sdk/bin/cache/artifacts/material_fonts/roboto-regular.ttf')
            .readAsBytes()
            .then((bytes) => ByteData.sublistView(bytes)),
      );
      await loader.load();
      final icons = FontLoader('MaterialIcons');
      icons.addFont(
        File(
          '$sdk/bin/cache/artifacts/material_fonts/materialicons-regular.otf',
        ).readAsBytes().then((bytes) => ByteData.sublistView(bytes)),
      );
      await icons.load();
    });
    final boundaryKey = GlobalKey();
    var frame = 0;
    await tester.runAsync(
      () => Directory('build/lab7_frames').create(recursive: true),
    );
    await tester.pumpWidget(
      RepaintBoundary(key: boundaryKey, child: const SoleStoreApp()),
    );
    await tester.pumpAndSettle();
    Future<void> record(int count) async {
      for (var i = 0; i < count; i++) {
        await tester.pump(const Duration(milliseconds: 80));
        final boundary =
            boundaryKey.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        final image = (await tester.runAsync(() => boundary.toImage()))!;
        final bytes = await tester.runAsync(
          () => image.toByteData(format: ui.ImageByteFormat.png),
        );
        final path =
            'build/lab7_frames/${(frame++).toString().padLeft(4, '0')}.png';
        await tester.runAsync(() async {
          await File(path).writeAsBytes(bytes!.buffer.asUint8List());
        });
        image.dispose();
      }
    }

    await record(16);
    await tester.scrollUntilVisible(
      find.text('Everyday Runner'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Everyday Runner'));
    await tester.pumpAndSettle();
    await record(12);
    await tester.tap(find.text('Everyday Runner'));
    await record(22);
    await tester.tap(find.byTooltip('Save favorite'));
    await record(10);
    await tester.scrollUntilVisible(
      find.byKey(const Key('back-to-list')),
      180,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const Key('back-to-list')));
    await tester.pumpAndSettle();
    await record(12);
    await tester.tap(find.byKey(const Key('back-to-list')));
    await record(18);
    await tester.tap(find.text('Favorites'));
    await record(18);
    await tester.ensureVisible(find.text('Everyday Runner'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Everyday Runner'));
    await record(18);
    await tester.tap(find.byTooltip('Back'));
    await record(18);
    await tester.tap(find.text('Profile'));
    await record(22);
    await tester.tap(find.byType(SwitchListTile));
    await record(12);
    await tester.tap(find.text('Feed'));
    await record(18);
    expect(tester.takeException(), isNull);
  });
}
