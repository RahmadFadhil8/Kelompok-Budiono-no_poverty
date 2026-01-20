import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:no_poverty/screens/home/customer/customer_home_screen.dart';


void main() {
  
  // Screen berhasil dirender 
  testWidgets('CustomerHomeScreen tampil tanpa error', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CustomerHomeScreen(enableAnalytics: false, isTest: true,),),);

    expect(find.byType(CustomerHomeScreen), findsOneWidget); 
  });

  // Informasi dompet digital atau Balance tampil 
  testWidgets('menampilkan informasi dompet digital atau Balance', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CustomerHomeScreen(enableAnalytics: false, isTest: true,),),);

    expect(find.text('Balance'), findsOneWidget); 
    expect(find.text('Rp 5.500.000'), findsOneWidget);
    expect(find.text('Available Balance'), findsOneWidget);
  });

  // tombol Top Up Tampil 
  testWidgets('Tombol Top up tampil', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CustomerHomeScreen(enableAnalytics: false, isTest: true,),),);

    expect(find.text('Top Up'), findsOneWidget);
  });

  // Tombol Buat Job Tampil
  testWidgets('Tombol Buat job tampil', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CustomerHomeScreen(enableAnalytics: false, isTest: true,),),);

    expect(find.text('Buat Job'), findsOneWidget);
  });

  // Icon wallet tampil
  testWidgets('Icon wallet tampil', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CustomerHomeScreen(enableAnalytics: false, isTest: true,),),);

    expect(find.byIcon(Icons.wallet), findsOneWidget); 
  });

  // Icon search (Cari Helper)
  testWidgets('Icon search (Cari Helper) tampil', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CustomerHomeScreen(enableAnalytics: false, isTest: true,),),);

    expect(find.byIcon(Icons.search), findsOneWidget); 
  });

  // Tombol Buat Job di Tekan
  testWidgets('Tombol Buat Job bisa ditekan', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CustomerHomeScreen(enableAnalytics: false, isTest: true,),),);

    final buatJob = find.text('Buat Job');
    expect(buatJob, findsOneWidget);
    await tester.tap(buatJob);
    await tester.pump(); 
  });

  // Tombol Mulai pada Verifikasi Akun
  testWidgets('Tombol Mulai pada Verifikasi Akun bisa ditekan', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: CustomerHomeScreen(enableAnalytics: false, isTest: true,),),);

    final VerifikasiTombol = find.text('Mulai');
    expect(VerifikasiTombol, findsOneWidget);
    await tester.tap(VerifikasiTombol);
    await tester.pump(); 
  });
}

// nim : 231111932