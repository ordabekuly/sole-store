import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sole_store/main.dart';
import 'package:sole_store/screens/registration_screen.dart';

void main() {
  Future<void> submit(WidgetTester tester) async {
    await tester.ensureVisible(find.byKey(const Key('register')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('register')));
    await tester.pumpAndSettle();
  }

  testWidgets('Discovery opens registration', (tester) async {
    await tester.pumpWidget(const SoleStoreApp());
    await tester.tap(find.byTooltip('Create account'));
    await tester.pumpAndSettle();
    expect(find.byType(RegistrationScreen), findsOneWidget);
  });

  testWidgets('Required, live validation, password dependency and terms gate', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: RegistrationScreen()));
    await submit(tester);
    expect(find.text('Full name is required.'), findsOneWidget);
    expect(find.text('Email is required.'), findsOneWidget);
    expect(find.text('Password is required.'), findsOneWidget);
    expect(find.text('Confirm your password.'), findsOneWidget);
    expect(
      find.text('Accept the Terms and Conditions to register.'),
      findsOneWidget,
    );
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '   ');
    await tester.enterText(fields.at(1), 'invalid@');
    await tester.enterText(fields.at(2), '12345');
    await tester.enterText(fields.at(3), 'different');
    await tester.pump();
    expect(find.text('Full name is required.'), findsOneWidget);
    expect(
      find.text('Enter a valid email, e.g. name@narxoz.kz.'),
      findsOneWidget,
    );
    expect(find.text('Use at least 6 characters.'), findsOneWidget);
    expect(find.text('Passwords must match exactly.'), findsOneWidget);
    await tester.enterText(fields.at(0), 'Demo Student');
    await tester.enterText(fields.at(1), 'demo@narxoz.kz');
    await tester.enterText(fields.at(2), 'secret1');
    await tester.enterText(fields.at(3), 'secret1');
    await tester.pump();
    expect(find.text('Passwords must match exactly.'), findsNothing);
    await tester.enterText(fields.at(2), 'secret2');
    await tester.pump();
    expect(find.text('Passwords must match exactly.'), findsOneWidget);
    await tester.enterText(fields.at(3), 'secret2');
    await submit(tester);
    expect(find.textContaining('Registration successful!'), findsNothing);
    await tester.tap(find.byKey(const Key('terms')));
    await tester.pumpAndSettle();
    await submit(tester);
    expect(find.textContaining('Registration successful!'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final size in [
    const Size(280, 568),
    const Size(390, 844),
    const Size(1440, 900),
  ]) {
    testWidgets('Registration layout and role at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const MaterialApp(home: RegistrationScreen()));
      await submit(tester);
      await tester.ensureVisible(find.byKey(const Key('role')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('role')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Developer').last);
      await tester.pumpAndSettle();
      expect(find.text('Developer'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
