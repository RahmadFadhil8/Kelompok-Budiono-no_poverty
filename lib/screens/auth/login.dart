import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:no_poverty/services/auth_services.dart';
import 'package:no_poverty/services/auth_services_contract.dart';
import 'package:no_poverty/screens/main_bottom_navigation.dart';
import 'package:no_poverty/Analytics/analytics_helper.dart';
import 'package:no_poverty/screens/auth/login_components.dart';

class LoginScreen extends StatefulWidget {
  final AuthServicesContract? authServices;

  const LoginScreen({
    super.key,
    this.authServices, 
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final AuthServicesContract _authServices;
  MyAnalytics? _analytics; 

  bool isLoggedIn = false;
  bool _isObscure = true;
  bool _loading = false;

  @override
  void initState() {
    super.initState();

    _authServices = widget.authServices ?? AuthServices();

    checkLoginStatus();
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final logged = prefs.getBool('isLoggedIn') ?? false;

    if (logged && mounted) {
      setState(() => isLoggedIn = true);
    }
  }

  MyAnalytics get analytics {
    _analytics ??= MyAnalytics();
    return _analytics!;
  }

  Future<void> loginUser() async {
    final email = _userController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar("Email dan password tidak boleh kosong!", Colors.red);
      return;
    }

    setState(() => _loading = true);

    try {
      final user =
          await _authServices.signInWithEmailPassword(email, password);

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', user.uid);
        await prefs.setString('userEmail', user.email ?? '');

        await analytics.userLogin(email);
        await analytics.usertimeout();
        await analytics.userId(user.uid);
        await analytics.userpoperty(user.email);

        _showSnackBar("Login berhasil", Colors.green);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const MainBottomNavigation(),
            ),
          );
        }
      } else {
        _showSnackBar(
          "Login gagal. Periksa email dan password.",
          Colors.red,
        );
      }
    } catch (e) {
      _showSnackBar(
        "Terjadi kesalahan: ${e.toString()}",
        Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return const MainBottomNavigation();
    }

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF001B48), Color(0xFF018ABE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const LoginHeader(),
                  const SizedBox(height: 40),
                  const AuthToggleButton(isLoginSelected: true),
                  const SizedBox(height: 35),

                  Container(
                    padding: const EdgeInsets.all(20),
                    width: 400,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _userController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        TextField(
                          controller: _passwordController,
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        ElevatedButton(
                          key: const Key('login_button'),
                          onPressed: _loading ? null : loginUser,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: _loading
                              ? const CircularProgressIndicator()
                              : const Text("Login"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
