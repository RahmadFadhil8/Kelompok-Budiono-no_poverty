import 'package:flutter/material.dart';
import 'package:no_poverty/screens/auth/login.dart';
import 'package:no_poverty/services/user_api_services.dart';
import 'package:no_poverty/Analytics/analytics_helper.dart';
import 'package:no_poverty/services/auth_serviceDedi.dart';
import 'package:no_poverty/services/auth_services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool EmailSelected = true;
  bool _otpSent = false;
  String? _verificationId;
  bool _isLoading = false;

  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomorHPController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final UserApiService userApiService = UserApiService();
  final AuthService1 _authService = AuthService1();
  final MyAnalytics analytics = MyAnalytics();

  @override
  void dispose() {
    _emailController.dispose();
    _nomorHPController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpController.dispose();
    _namaController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    final email = _emailController.text.trim();
    final nomorHP = _nomorHPController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final nama = _namaController.text.trim();

    if (nama.isEmpty) {
      _showSnackBar("Nama lengkap tidak boleh kosong!", Colors.red);
      return;
    }

    if (EmailSelected) {
      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        _showSnackBar("Email dan password tidak boleh kosong!", Colors.red);
        return;
      }
      if (password != confirmPassword) {
        _showSnackBar("Password tidak cocok!", Colors.red);
        return;
      }
    } else {
      if (nomorHP.isEmpty) {
        _showSnackBar("Nomor HP tidak boleh kosong!", Colors.red);
        return;
      }
    }

    try {
      if (EmailSelected) {
        final firebaseUser = await _authService.signUpWithEmailPassword(email, password);
        if (firebaseUser == null) {
          _showSnackBar("Gagal membuat akun Firebase", Colors.red);
          return;
        }

        analytics.userRegister(email);
      }

      await userApiService.registerUser(
        email: EmailSelected ? email : "",
        username: username,
        nomorHp: !EmailSelected ? nomorHP : "",
        password: password,
      );

      _showSnackBar("Registrasi berhasil!", Colors.green);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}", Colors.red);
    }
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
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
                const ListTile(
                  leading: Icon(Icons.storefront, size: 70, color: Colors.white),
                  title: Text("JobWaroeng",
                      style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  subtitle: Text("Temukan Pekerjaan Harianmu",
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
                const SizedBox(height: 40),
                _buildSwitchButton(),
                const SizedBox(height: 35),
                _buildRegisterForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchButton() {
    return Container(
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
    );
  }

  Widget _buildRegisterForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(300), blurRadius: 4, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          TextField(
            controller: _namaController,
            decoration: InputDecoration(
              hintText: "Nama Lengkap",
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
            ),
          ),
          const SizedBox(height: 18),
          _buildModeSelector(),
          const SizedBox(height: 18),
          if (EmailSelected) _buildEmailForm() else _buildPhoneForm(),
        ],
      ),
    );
  }

  Widget _buildModeSelector() {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: const Color(0xFFD6EBEE),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _buildTab("Email", Icons.email_outlined, true),
          _buildTab("Telepon", Icons.phone, false),
        ],
      ),
    );
  }

  Widget _buildTab(String title, IconData icon, bool isEmailTab) {
    bool selected = EmailSelected == isEmailTab;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            EmailSelected = isEmailTab;
            _otpSent = false;
            _otpController.clear();
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(icon, size: 15), const SizedBox(width: 10), Text(title)],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailForm() {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "Email",
            prefixIcon: const Icon(Icons.email),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ),
        const SizedBox(height: 18),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: "Password",
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ),
        const SizedBox(height: 18),
        TextField(
          controller: _confirmPasswordController,
          obscureText: _obscureConfirm,
          decoration: InputDecoration(
            hintText: "Konfirmasi Password",
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ),
        const SizedBox(height: 18),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(320, 50),
            backgroundColor: const Color(0xFF02457A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          ),
          onPressed: _isLoading ? null : () async {
            setState(() => _isLoading = true);
            await _registerUser();
            setState(() => _isLoading = false);
          },
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Register", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildPhoneForm() {
    return Column(
      children: [
        TextField(
          controller: _nomorHPController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: "Nomor Telepon",
            prefixIcon: const Icon(Icons.phone),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ),
        const SizedBox(height: 18),
        if (!_otpSent)
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () async {
                    String phone = _nomorHPController.text.trim();
                    if (!phone.startsWith('+')) phone = '+62$phone';
                    setState(() => _isLoading = true);
                    final verId = await AuthServices().sendOTP(phone, context);
                    if (verId != null) {
                      setState(() {
                        _verificationId = verId;
                        _otpSent = true;
                      });
                    }
                    setState(() => _isLoading = false);
                  },
            child: _isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text("Kirim OTP", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          )
        else
          Column(
            children: [
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Masukkan OTP",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                ),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() => _isLoading = true);
                        final user = await AuthServices().verifyOTP(_verificationId!, _otpController.text, context);
                        if (user != null) {
                          await _registerUser();
                        }
                        setState(() => _isLoading = false);
                      },
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verifikasi & Daftar", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _otpSent = false;
                    _otpController.clear();
                  });
                },
                child: const Text("Kirim ulang OTP"),
              ),
            ],
          ),
      ],
    );
  }
}
