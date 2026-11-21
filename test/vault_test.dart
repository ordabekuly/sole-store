import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sole_store/main.dart';
import 'package:sole_store/models/note_item.dart';
import 'package:sole_store/providers/vault_provider.dart';
import 'package:sole_store/screens/notes_vault_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test('Note JSON round trip and safe field defaults', () {
    const note = NoteItem(
      id: '1',
      title: 'Read lecture',
      dateText: '2026-11-21',
      isCompleted: true,
    );
    final restored = NoteItem.fromJson(
      jsonDecode(jsonEncode(note.toJson())) as Map<String, dynamic>,
    );
    expect(restored.toJson(), note.toJson());
    expect(NoteItem.fromJson({}).isCompleted, false);
  });
  test(
    'Defaults, persisted CRUD and restoration using a fresh provider',
    () async {
      var vault = await VaultProvider.load();
      expect(vault.darkMode, false);
      expect(vault.displayName, 'Guest User');
      expect(vault.notes, isEmpty);
      await vault.saveName('  Maksat  ');
      await vault.setDarkMode(true);
      await vault.addNote('First');
      await vault.addNote('Second');
      final secondId = vault.notes.first.id;
      expect(vault.notes.map((n) => n.title), ['Second', 'First']);
      await vault.toggleNote(secondId);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool(VaultProvider.themeKey), true);
      expect(prefs.getString(VaultProvider.nameKey), 'Maksat');
      final rows = jsonDecode(prefs.getString(VaultProvider.notesKey)!) as List;
      expect(rows.first['isCompleted'], true);
      expect(() => vault.notes.clear(), throwsUnsupportedError);
      vault.dispose();
      await prefs.reload();
      vault = await VaultProvider.load();
      expect(vault.darkMode, true);
      expect(vault.displayName, 'Maksat');
      expect(vault.notes.length, 2);
      expect(vault.notes.first.id, secondId);
      expect(vault.notes.first.isCompleted, true);
      await vault.deleteNote(secondId);
      vault.dispose();
      await prefs.reload();
      vault = await VaultProvider.load();
      expect(vault.notes.single.title, 'First');
      await vault.saveName('   ');
      expect(vault.displayName, 'Guest User');
      vault.dispose();
    },
  );
  test(
    'Corrupt JSON does not crash or erase the original saved data on load',
    () async {
      SharedPreferences.setMockInitialValues({
        VaultProvider.notesKey: 'not-json',
      });
      final vault = await VaultProvider.load();
      addTearDown(vault.dispose);
      expect(vault.notes, isEmpty);
      expect(vault.loadWarning, isNotNull);
      expect(
        (await SharedPreferences.getInstance()).getString(
          VaultProvider.notesKey,
        ),
        'not-json',
      );
    },
  );
  testWidgets('Preloaded dark theme is selected on the first app frame', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      VaultProvider.themeKey: true,
      VaultProvider.nameKey: 'Maksat',
    });
    final vault = await VaultProvider.load();
    await tester.pumpWidget(SoleStoreApp(vault: vault));
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
  });
  for (final size in [
    const Size(280, 568),
    const Size(390, 844),
    const Size(1440, 900),
  ]) {
    testWidgets('Vault UI persists name/note/theme at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final vault = await VaultProvider.load();
      addTearDown(vault.dispose);
      Widget app() => ChangeNotifierProvider.value(
        value: vault,
        child: const MaterialApp(home: NotesVaultScreen()),
      );
      await tester.pumpWidget(app());
      await tester.enterText(find.byKey(const Key('vault-name')), 'Student');
      await tester.ensureVisible(find.byKey(const Key('vault-save-name')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('vault-save-name')));
      await tester.pumpAndSettle();
      expect(vault.displayName, 'Student');
      await tester.scrollUntilVisible(
        find.byKey(const Key('vault-greeting')),
        -160,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      expect(find.text('Hello, Student'), findsOneWidget);
      await tester.ensureVisible(find.byKey(const Key('vault-theme')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('vault-theme')));
      await tester.pumpAndSettle();
      expect(
        (await SharedPreferences.getInstance()).getBool(VaultProvider.themeKey),
        true,
      );
      await tester.enterText(
        find.byKey(const Key('vault-note-title')),
        'Prepare defense',
      );
      await tester.ensureVisible(find.byKey(const Key('vault-add-note')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('vault-add-note')));
      await tester.pumpAndSettle();
      expect(vault.notes.single.title, 'Prepare defense');
      final id = vault.notes.single.id;
      await tester.scrollUntilVisible(
        find.byKey(ValueKey('toggle-$id')),
        160,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.byKey(ValueKey('toggle-$id')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(ValueKey('toggle-$id')));
      await tester.pumpAndSettle();
      expect(vault.notes.single.isCompleted, true);
      await tester.tap(find.byKey(ValueKey('delete-$id')));
      await tester.pumpAndSettle();
      expect(vault.notes, isEmpty);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('Profile exposes LW11 route', (tester) async {
    await tester.pumpWidget(const SoleStoreApp());
    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('LW11 Notes Vault'),
      160,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('LW11 Notes Vault'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('LW11 Notes Vault'));
    await tester.pumpAndSettle();
    expect(find.byType(NotesVaultScreen), findsOneWidget);
  });
}
