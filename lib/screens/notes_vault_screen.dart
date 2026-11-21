import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/vault_provider.dart';

class NotesVaultScreen extends StatefulWidget {
  const NotesVaultScreen({super.key});
  @override
  State<NotesVaultScreen> createState() => _NotesVaultScreenState();
}

class _NotesVaultScreenState extends State<NotesVaultScreen> {
  final name = TextEditingController();
  final title = TextEditingController();
  bool ready = false;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!ready) {
      name.text = context.read<VaultProvider>().displayName;
      ready = true;
    }
  }

  @override
  void dispose() {
    name.dispose();
    title.dispose();
    super.dispose();
  }

  Future<void> save(
    Future<void> Function() action,
    String message, {
    bool clearNote = false,
  }) async {
    FocusScope.of(context).unfocus();
    try {
      await action();
      if (!mounted) return;
      if (clearNote) setState(() => title.clear());
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Could not save. Please try again.')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vault = context.watch<VaultProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('LW11 Notes Vault', overflow: TextOverflow.ellipsis),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Hello, ${vault.displayName}',
                  key: const Key('vault-greeting'),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text('Your notes and preferences stay on this device.'),
                SwitchListTile(
                  key: const Key('vault-theme'),
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Dark Mode'),
                  value: vault.darkMode,
                  onChanged: vault.busy
                      ? null
                      : (value) =>
                            save(() => vault.setDarkMode(value), 'Theme saved'),
                ),
                TextField(
                  key: const Key('vault-name'),
                  controller: name,
                  enabled: !vault.busy,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  key: const Key('vault-save-name'),
                  onPressed: vault.busy
                      ? null
                      : () => save(
                          () => vault.saveName(name.text),
                          'Username saved',
                        ),
                  child: const Text('Save'),
                ),
                const SizedBox(height: 24),
                TextField(
                  key: const Key('vault-note-title'),
                  controller: title,
                  enabled: !vault.busy,
                  decoration: const InputDecoration(
                    labelText: 'New note',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                  onSubmitted: (_) {
                    if (!vault.busy && title.text.trim().isNotEmpty) {
                      save(
                        () => vault.addNote(title.text),
                        'Note saved',
                        clearNote: true,
                      );
                    }
                  },
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  key: const Key('vault-add-note'),
                  onPressed: vault.busy || title.text.trim().isEmpty
                      ? null
                      : () => save(
                          () => vault.addNote(title.text),
                          'Note saved',
                          clearNote: true,
                        ),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Note'),
                ),
                if (vault.busy)
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: LinearProgressIndicator(),
                  ),
                if (vault.loadWarning != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      vault.loadWarning!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                Text(
                  'Notes (${vault.notes.length})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (vault.notes.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Column(
                      children: [
                        Icon(Icons.note_alt_outlined, size: 48),
                        SizedBox(height: 8),
                        Text('No notes yet. Add your first note.'),
                      ],
                    ),
                  ),
                for (final note in vault.notes)
                  Card(
                    key: ValueKey(note.id),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                      leading: Checkbox(
                        key: ValueKey('toggle-${note.id}'),
                        value: note.isCompleted,
                        onChanged: vault.busy
                            ? null
                            : (_) => save(
                                () => vault.toggleNote(note.id),
                                'Note updated',
                              ),
                      ),
                      title: Text(
                        note.title,
                        style: TextStyle(
                          decoration: note.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      subtitle: Text(note.dateText),
                      trailing: IconButton(
                        key: ValueKey('delete-${note.id}'),
                        tooltip: 'Delete ${note.title}',
                        onPressed: vault.busy
                            ? null
                            : () => save(
                                () => vault.deleteNote(note.id),
                                'Note deleted',
                              ),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                const Text(
                  'Local preferences are not encrypted storage. Do not store passwords here.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
