import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:no_poverty/screens/auth/login.dart';
import 'package:no_poverty/screens/auth/register.dart';

import '../../test_config.dart';
import '../../helpers/fake_auth_services.dart';

void main() {
  testWidgets('render TextField (email & password)', (tester) async {
    await pumpTestApp(
      tester,
      RegisterScreen(
        authServices: FakeAuthFail(),
      ),
    );

    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Konfirmasi Password'), findsOneWidget);
  });

  testWidgets('button Register ada', (tester) async {
    await pumpTestApp(
      tester,
      RegisterScreen(
        authServices: FakeAuthFail(),
      ),
    );

    expect(find.byKey(const Key('register_button')), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('error muncul kalau field kosong', (tester) async {
    await pumpTestApp(
      tester,
      RegisterScreen(
        authServices: FakeAuthFail(),
      ),
    );

    await tester.tap(find.byKey(const Key('register_button')));
    await tester.pump();


    expect(
      find.textContaining('Semua field wajib diisi!'),
      findsOneWidget,
    );
  });

  testWidgets(
    'error muncul kalau password dan konfirmasi tidak sama',
    (tester) async {
      await pumpTestApp(
        tester,
        RegisterScreen(
          authServices: FakeAuthFail(),
        ),
      );

      await tester.enterText(
        find.byType(TextField).at(0),
        'test@email.com',
      );

      await tester.enterText(
        find.byType(TextField).at(1),
        'password123',
      );

      await tester.enterText(
        find.byType(TextField).at(2),
        'password_salah',
      );

      await tester.tap(find.byKey(const Key('register_button')));
      await tester.pump(); 

      expect(
        find.textContaining('Password tidak cocok'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
  'setelah register sukses, pindah ke LoginScreen',
  (tester) async {
    await pumpTestApp(
      tester,
      RegisterScreen(
        authServices: FakeAuthSuccess(),
      ),
    );

    await tester.enterText(
      find.byType(TextField).at(0),
      'test01@email.com',
    );

    await tester.enterText(
      find.byType(TextField).at(1),
      'password123',
    );

    await tester.enterText(
      find.byType(TextField).at(2),
      'password123',
    );

    await tester.tap(find.byKey(const Key('register_button')));

    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);

    expect(find.byType(RegisterScreen), findsNothing);
  },
);
}


