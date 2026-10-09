import 'dart:convert';

import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _confirmKey = GlobalKey<FormFieldState<String>>();
  bool _accepted = false;
  bool _submitted = false;
  String _role = 'Student';

  @override
  void dispose() {
    for (final controller in [_name, _email, _password, _confirm]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _register() {
    FocusScope.of(context).unfocus();
    setState(() => _submitted = true);
    final valid = _formKey.currentState!.validate();
    if (!valid || !_accepted) return;
    debugPrint(
      'Registration: ${jsonEncode({'fullName': _name.text.trim(), 'email': _email.text.trim(), 'role': _role, 'acceptedTerms': _accepted, 'password': '[REDACTED]', 'confirmPassword': '[REDACTED]'})}',
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Registration successful! Welcome, ${_name.text.trim()}.',
          ),
        ),
      );
  }

  InputDecoration _decoration(String label, IconData icon) => InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    border: const OutlineInputBorder(),
    errorMaxLines: 3,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Create account', overflow: TextOverflow.ellipsis),
    ),
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              autovalidateMode: _submitted
                  ? AutovalidateMode.always
                  : AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.person_add_alt_1_outlined,
                    size: 48,
                    color: Color(0xFF315D45),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Make it yours.',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Set up your SOLE profile. Find your next favorite pair.',
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    key: const Key('full-name'),
                    controller: _name,
                    decoration: _decoration('Full Name', Icons.person_outline),
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.name],
                    validator: (value) => value == null || value.trim().isEmpty
                        ? 'Full name is required.'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('email'),
                    controller: _email,
                    decoration: _decoration('Email', Icons.alternate_email),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    autofillHints: const [AutofillHints.email],
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      if (email.isEmpty) return 'Email is required.';
                      if (!RegExp(r'^[^\s@]+@[^\s@.]+(?:\.[^\s@.]+)+$')
                          .hasMatch(email)) {
                        return 'Enter a valid email, e.g. name@narxoz.kz.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('password'),
                    controller: _password,
                    decoration: _decoration('Password', Icons.lock_outline),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    onChanged: (_) {
                      if (_confirm.text.isNotEmpty || _submitted) {
                        _confirmKey.currentState?.validate();
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required.';
                      }
                      return value.length < 6
                          ? 'Use at least 6 characters.'
                          : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: _confirmKey,
                    controller: _confirm,
                    decoration: _decoration(
                      'Confirm Password',
                      Icons.lock_outline,
                    ),
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _register(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm your password.';
                      }
                      return value != _password.text
                          ? 'Passwords must match exactly.'
                          : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    key: const Key('role'),
                    initialValue: _role,
                    isExpanded: true,
                    decoration: _decoration('Role', Icons.badge_outlined),
                    items: ['Student', 'Teacher', 'Developer']
                        .map(
                          (role) =>
                              DropdownMenuItem(value: role, child: Text(role)),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _role = value ?? 'Student'),
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    key: const Key('terms'),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _accepted,
                    title: const Text('I accept the Terms and Conditions'),
                    onChanged: (value) =>
                        setState(() => _accepted = value ?? false),
                  ),
                  if (_submitted && !_accepted)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        'Accept the Terms and Conditions to register.',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  FilledButton(
                    key: const Key('register'),
                    onPressed: _register,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    child: const Text('Register'),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Demo profile setup. No account is stored or sent to a server.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
