import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:no_poverty/screens/home/customer/list_ketegori.dart';

void main() {

  // Kategori dapat di-scroll secara horizontal
  testWidgets('Kategori dapat di-scroll secara horizontal', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: KategotiList(enableAnalytics: false),),);

    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    final listView = find.byType(ListView);
    expect(listView, findsOneWidget);

    // test Scroll
    await tester.drag(find.byType(ListView), const Offset(-600, 0));
    await tester.pump(); 

    //ketegori terakhir sekarang tampil
    expect(find.text('Delivery',skipOffstage: false), findsOneWidget);
  });

  // tap salah satu tombol kategori
  testWidgets('Salah satu Tombol Kategori bisa ditekan', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: KategotiList(enableAnalytics: false),),);

    await tester.pump(const Duration(seconds: 1));
    await tester.pump();

    await tester.tap(find.text('Cleaning'));
    await tester.tap(find.text('Home Assistance'));
    await tester.pump(); 
  });
}

// nim : 231111932
// Rahmad fadhil