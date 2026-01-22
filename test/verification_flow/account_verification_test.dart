import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:no_poverty/screens/home/customer/account_verification.dart';
import 'package:no_poverty/screens/home/customer/account_verification2.dart';
import 'package:no_poverty/screens/home/customer/account_verification3.dart';
import 'package:no_poverty/screens/home/customer/account_verification4.dart';

void main() {
  group('Account Verification Flow Tests', () {
    testWidgets('Step 1 - Menampilkan UI Awal Verifikasi Akun', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountVerificationScreen()));
      expect(find.text('Verifikasi Akun'), findsOneWidget);
      expect(find.text('Step 1/4'), findsOneWidget);
      expect(find.text('Upload KTP'), findsOneWidget);
    });

    testWidgets('Step 1 - Tombol Lanjut Nonaktif Sebelum Upload', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountVerificationScreen()));
      expect(find.text('Lanjut'), findsOneWidget);
    });
    testWidgets('Step 2 - Menampilkan Upload SKCK', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountVerificationStep2()));
      expect(find.text('Step 2/4'), findsOneWidget);
      expect(find.text('Upload SKCK'), findsOneWidget);
    });

    testWidgets('Step 2 - Tombol Lanjut Ada', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountVerificationStep2()));
      expect(find.text('Lanjut'), findsOneWidget);
    });

    testWidgets('Step 3 - Tampilkan Background Check Premium', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountVerificationStep3()));
      expect(find.text('Background Check Premium'), findsOneWidget);
    });

    testWidgets('Step 3 - Tombol Toggle Background Check Berubah ke Dipilih', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: AccountVerificationStep3()));

      final toggleButton = find.textContaining('Pilih Background Check');
      await tester.ensureVisible(toggleButton);
      await tester.tap(toggleButton);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.text('Dipilih'), findsOneWidget);
    });

    testWidgets('Step 4 - Menampilkan Review Dokumen', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: AccountVerificationStep4(isPremiumSelected: true),
      ));
      expect(find.text('Step 4/4'), findsOneWidget);
      expect(find.text('Review Dokumen'), findsOneWidget);
    });

    testWidgets('Step 4 - Tampilkan Background Check Premium Bila Dipilih', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: AccountVerificationStep4(isPremiumSelected: true),
      ));
      expect(find.text('Background Check Premium'), findsOneWidget);
      expect(find.text('Rp 50.000'), findsOneWidget);
    });

    testWidgets('Step 4 - Tombol Submit Verifikasi Ada', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: AccountVerificationStep4(isPremiumSelected: false),
      ));
      expect(find.text('Submit Verifikasi'), findsOneWidget);
    });

    testWidgets('Step 4 - Tekan Submit Verifikasi menampilkan loading indikator', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: AccountVerificationStep4(isPremiumSelected: false),
      ));

      final submitButton = find.text('Submit Verifikasi');
      await tester.ensureVisible(submitButton);
      await tester.tap(submitButton);
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('Verifikasi Akun'), findsOneWidget);
      expect(find.text('Submit Verifikasi'), findsOneWidget);
    });
  });
}
