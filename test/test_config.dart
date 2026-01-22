import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> pumpTestApp(
  WidgetTester tester,
  Widget widget,
) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  await tester.pumpWidget(
    MaterialApp(
      home: widget,
    ),
  );

  await tester.pump(); 
}
