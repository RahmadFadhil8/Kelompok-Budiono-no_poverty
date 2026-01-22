import 'package:flutter/material.dart';
import 'package:no_poverty/screens/auth/login.dart';
import 'package:no_poverty/services/auth_services.dart';
import 'package:no_poverty/services/auth_services_contract.dart';
import 'package:no_poverty/Analytics/analytics_helper.dart';
import 'package:no_poverty/screens/auth/register_components.dart';

class RegisterScreen extends StatefulWidget {
  final AuthServicesContract? authServices;
  final MyAnalytics? analytics;

  const RegisterScreen({
    super.key,
    this.authServices,
    this.analytics,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final AuthServicesContract _authServices;
  MyAnalytics? _analytics;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authServices = widget.authServices ?? AuthServices();
    _analytics = widget.analytics; 
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  Future<void> _registerUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar("Semua field wajib diisi!", Colors.red);
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar("Password tidak cocok!", Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user =
          await _authServices.signUpWithEmailPassword(email, password);

      if (user == null) {
        _showSnackBar("Gagal membuat akun", Colors.red);
        return;
      }

      await _analytics?.userRegister(email);

      _showSnackBar("Registrasi berhasil! Silakan login.", Colors.green);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen(authServices: widget.authServices,)),
        );
      }
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}", Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  const RegisterHeader(),
                  const SizedBox(height: 40),
                  const RegisterAuthToggle(),
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
                        CustomAuthTextField(
                          controller: _emailController,
                          hint: "Email",
                          icon: Icons.email,
                          inputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 18),

                        CustomAuthTextField(
                          controller: _passwordController,
                          hint: "Password",
                          icon: Icons.lock,
                          isPassword: true,
                          isObscure: _obscurePassword,
                          onVisibilityToggle: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        const SizedBox(height: 18),

                        CustomAuthTextField(
                          controller: _confirmPasswordController,
                          hint: "Konfirmasi Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                          isObscure: _obscureConfirm,
                          onVisibilityToggle: () {
                            setState(() {
                              _obscureConfirm = !_obscureConfirm;
                            });
                          },
                        ),
                        const SizedBox(height: 30),

                        ElevatedButton(
                          key: const Key('register_button'), // Key untuk testing
                          onPressed: _isLoading ? null : _registerUser,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: const Color(0xFF02457A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Register",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
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
