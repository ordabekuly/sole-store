import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/note_item.dart';

class VaultProvider extends ChangeNotifier {
  static const themeKey = 'app_theme_dark_mode';
  static const nameKey = 'user_display_name';
  static const notesKey = 'vault_notes_json';
  final SharedPreferences? _preferences;
  bool _dark;
  String _name;
  List<NoteItem> _notes;
  bool _busy = false;
  String? loadWarning;
  int _sequence = 0;
  VaultProvider._(
    this._preferences,
    this._dark,
    this._name,
    this._notes,
    this.loadWarning,
  );

  /// For widget previews/tests only. Production main always passes load()'s result.
  factory VaultProvider.memory() =>
      VaultProvider._(null, false, 'Guest User', [], null);
  static Future<VaultProvider> load() async {
    final prefs = await SharedPreferences.getInstance();
    final dark = prefs.getBool(themeKey) ?? false;
    final name = prefs.getString(nameKey) ?? 'Guest User';
    final raw = prefs.getString(notesKey) ?? '[]';
    List<NoteItem> notes = [];
    String? warning;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) throw const FormatException('Expected notes list');
      notes = decoded.map((row) {
        if (row is! Map<String, dynamic>) {
          throw const FormatException('Invalid note');
        }
        return NoteItem.fromJson(row);
      }).toList();
      if (notes.any((n) => n.id.isEmpty) ||
          notes.map((n) => n.id).toSet().length != notes.length) {
        throw const FormatException('Invalid note IDs');
      }
    } catch (_) {
      notes = [];
      warning = 'Saved notes could not be read. Adding a note will replace the unreadable list.';
    }
    return VaultProvider._(
      prefs,
      dark,
      name.trim().isEmpty ? 'Guest User' : name,
      notes,
      warning,
    );
  }

  bool get darkMode => _dark;
  String get displayName => _name;
  List<NoteItem> get notes => List.unmodifiable(_notes);
  bool get busy => _busy;
  Future<void> _write(Future<bool> Function() save, VoidCallback apply) async {
    if (_busy) throw StateError('A save is already running. Please wait.');
    _busy = true;
    notifyListeners();
    try {
      if (!await save()) throw StateError('Storage did not confirm the save.');
      apply();
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  Future<void> setDarkMode(bool value) => _write(
    () async => _preferences == null
        ? true
        : await _preferences.setBool(themeKey, value),
    () => _dark = value,
  );
  Future<void> saveName(String value) {
    final name = value.trim().isEmpty ? 'Guest User' : value.trim();
    return _write(
      () async => _preferences == null
          ? true
          : await _preferences.setString(nameKey, name),
      () => _name = name,
    );
  }

  Future<void> _saveNotes(List<NoteItem> next) => _write(
    () async => _preferences == null
        ? true
        : await _preferences.setString(
            notesKey,
            jsonEncode(next.map((n) => n.toJson()).toList()),
          ),
    () {
      _notes = next;
      loadWarning = null;
    },
  );
  Future<void> addNote(String title) async {
    if (title.trim().isEmpty) throw ArgumentError('Enter a note title.');
    final now = DateTime.now();
    final date =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    await _saveNotes([
      NoteItem(
        id: '${now.microsecondsSinceEpoch}-${_sequence++}',
        title: title.trim(),
        dateText: date,
      ),
      ..._notes,
    ]);
  }

  Future<void> toggleNote(String id) =>
      _saveNotes(_notes.map((n) => n.id == id ? n.toggled() : n).toList());
  Future<void> deleteNote(String id) =>
      _saveNotes(_notes.where((n) => n.id != id).toList());
}
