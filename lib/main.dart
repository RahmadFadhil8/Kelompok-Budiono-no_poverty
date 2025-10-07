import 'package:flutter/material.dart';
import 'package:no_poverty/screens/auth/login.dart';
import 'package:no_poverty/screens/auth/register.dart';
import 'package:no_poverty/screens/home/home.dart';
import 'package:no_poverty/screens/welcome/welcome_screen.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: 
      // WelcomeScreen(),
      // LoginScreen()
      RegisterScreen()
    );
  }
}