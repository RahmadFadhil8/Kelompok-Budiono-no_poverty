import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:no_poverty/screens/auth/login.dart';
import 'package:no_poverty/screens/auth/login_components.dart';

import '../../test_config.dart';
import '../../helpers/fake_auth_services.dart';

void main() {
  testWidgets('render TextField (email & password)', (tester) async {
    await pumpTestApp(
      tester,
      LoginScreen(
        authServices: FakeAuthFail(),
      ),
    );

    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
  });

  testWidgets('button Login ada', (tester) async {
    await pumpTestApp(
      tester,
      LoginScreen(
        authServices: FakeAuthFail(),
      ),
    );

    expect(find.byKey(const Key('login_button')), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('error muncul kalau field kosong', (tester) async {
    await pumpTestApp(
      tester,
      LoginScreen(
        authServices: FakeAuthFail(),
      ),
    );

    await tester.tap(find.byKey(const Key('login_button')));
    await tester.pump();


    expect(
      find.textContaining('tidak boleh kosong'),
      findsOneWidget,
    );
  });

  testWidgets('toggle password visibility works', (tester) async {
    await pumpTestApp(
      tester,
      LoginScreen(
        authServices: FakeAuthFail(),
      ),
    );

    final visibilityOffIcon = find.byIcon(Icons.visibility_off);
    expect(visibilityOffIcon, findsOneWidget);

    await tester.tap(visibilityOffIcon);
    await tester.pump();

    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });

  testWidgets(
    'AuthToggleButton render Login & Daftar',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AuthToggleButton(isLoginSelected: true),
          ),
        ),
      );

      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Daftar'), findsOneWidget);
    },
  );
}