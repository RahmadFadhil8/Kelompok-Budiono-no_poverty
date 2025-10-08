import 'package:flutter/material.dart';
import 'package:no_poverty/screens/auth/login.dart';
import 'package:no_poverty/screens/welcome/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  bool? isSeeWelcome;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkWelcomeStatus();
  }

  Future<void> _checkWelcomeStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('isSeeWelcome') ?? false;

    print("isWelcomeSee: $seen");

    setState(() {
      isSeeWelcome = seen;
      isLoading = false; 
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (isSeeWelcome == true) {
      return const LoginScreen();
    }

    return const WelcomeScreen();
  }
}
