import 'package:flutter/material.dart';
import 'package:no_poverty/screens/auth/login.dart';
import 'package:no_poverty/services/auth_services.dart';
import 'package:no_poverty/Analytics/analytics_helper.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final AuthServices _authService = AuthServices();
  final MyAnalytics analytics = MyAnalytics();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
      final firebaseUser = await _authService.signUpWithEmailPassword(email, password);
      if (firebaseUser == null) {
        _showSnackBar("Gagal membuat akun Firebase", Colors.red);
        return;
      }

      analytics.userRegister(email);
      
      _showSnackBar("Registrasi berhasil! Silakan login.", Colors.green);
      if (mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
      }
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}", Colors.red);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String hint, IconData icon, [bool isPassword = false, bool isConfirm = false]) {
    bool obscure = false;
    VoidCallback? toggle;

    if (isPassword) {
      obscure = _obscurePassword;
      toggle = () => setState(() => _obscurePassword = !_obscurePassword);
    } else if (isConfirm) {
      obscure = _obscureConfirm;
      toggle = () => setState(() => _obscureConfirm = !_obscureConfirm);
    }
    
    return TextField(
      controller: controller,
      keyboardType: isPassword || isConfirm ? TextInputType.text : TextInputType.emailAddress,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
        suffixIcon: (isPassword || isConfirm)
            ? IconButton(
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: toggle,
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF001B48), Color(0xFF018ABE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // === HEADER & LOGO ===
                const ListTile(
                  leading: Icon(Icons.storefront, size: 70, color: Colors.white),
                  title: Text("JobWaroeng",
                      style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  subtitle: Text("Temukan Pekerjaan Harianmu",
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
                const SizedBox(height: 40),
                
                Container(
                  width: 250,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withAlpha(300), blurRadius: 4, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen())),
                          child: const Center(child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold))),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(color: const Color(0xFF018ABE), borderRadius: BorderRadius.circular(30)),
                          alignment: Alignment.center,
                          child: const Text("Daftar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),
                
                Container(
                  padding: const EdgeInsets.all(20),
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(300), blurRadius: 4, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    children: [
                      _buildTextField(_emailController, "Email", Icons.email),
                      const SizedBox(height: 18),

                      _buildTextField(_passwordController, "Password", Icons.lock, true, false),
                      const SizedBox(height: 18),
                      
                      _buildTextField(_confirmPasswordController, "Konfirmasi Password", Icons.lock_outline, false, true),
                      const SizedBox(height: 30),
                      
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(320, 50),
                          backgroundColor: const Color(0xFF02457A),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: _isLoading ? null : _registerUser,
                        child: _isLoading
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : const Text("Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}