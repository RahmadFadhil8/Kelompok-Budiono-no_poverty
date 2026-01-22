import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:no_poverty/screens/home/work/work_home_screen.dart';

void main() {
  Widget testWidget() {
    return const MaterialApp(
      home: WorkHomeScreen(
        isTest: true,
        enableAnalytics: false,
      ),
    );
  }

  testWidgets('WorkHomeScreen tampil', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget());

    expect(find.byType(WorkHomeScreen), findsOneWidget);
  });

  testWidgets('Total Earnings tampil', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget());

    expect(find.text('Total Earnings'), findsOneWidget);
  });

  testWidgets('Card Rating tampil', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget());

    expect(find.text('Rating'), findsOneWidget);
  });

  testWidgets('Card Completed Job tampil', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget());

    expect(find.text('Completed'), findsOneWidget);
  });

  testWidgets('Halaman WorkHomeScreen bisa di scroll', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget());

    final scrollView = find.byType(SingleChildScrollView);
    expect(scrollView, findsOneWidget);

    await tester.drag(scrollView, const Offset(0, -300));

    expect(tester.takeException(), isNull);
  });

  testWidgets('Widget Jadwal Harian tampil', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget());

    expect(find.textContaining('Jadwal Hari ini'), findsOneWidget);
  });

  testWidgets('Section Job Tersedia tampil', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget());

    expect(find.text('Job Tersedia'), findsOneWidget);
  });

  testWidgets('Tombol Cari Job bisa di tap', (WidgetTester tester) async {
    await tester.pumpWidget(testWidget());

    final cariJobButton = find.text('Cari Job');
    expect(cariJobButton, findsOneWidget);

    await tester.tap(cariJobButton);

    expect(tester.takeException(), isNull);
  });

  testWidgets('Mode Test tampil saat isTest = true', (tester) async {
  await tester.pumpWidget(testWidget());

  expect(find.textContaining('Mode Test'), findsWidgets);
});

testWidgets('Tombol Profil Saya bisa di tap', (WidgetTester tester) async {
  await tester.pumpWidget(testWidget());

  final profilButton = find.text('Profil Saya');
  expect(profilButton, findsOneWidget);

  await tester.tap(profilButton);

  expect(tester.takeException(), isNull);
});


}
