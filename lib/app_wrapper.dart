import 'package:flutter/material.dart';
import 'package:no_poverty/screens/auth/login.dart';
import 'package:no_poverty/screens/home/home.dart';
import 'package:no_poverty/screens/welcome/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool? isSeeWelcome;
  SharedPreferences? prefs;

  @override
  void initState() {
    super.initState();
    print("object");
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
    checkLoginStatus();
  });
  }



  Future<void> checkLoginStatus() async {
      prefs = await SharedPreferences.getInstance();
      print( await prefs?.getBool('isSeeWelcome'));
      print("test");
        isSeeWelcome = prefs?.getBool('isSeeWelcome');
    
  }

  @override
  Widget build(BuildContext context) {
    if (isSeeWelcome == null) {
      return WelcomeScreen();
    }

    return isSeeWelcome! ? Home() : LoginScreen();
  }
}
