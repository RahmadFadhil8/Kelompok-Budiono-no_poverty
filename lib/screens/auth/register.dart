import 'package:flutter/material.dart';
import 'package:no_poverty/Analytics/analytics_helper.dart';
import 'package:no_poverty/services/auth_serviceDedi.dart';
import 'package:no_poverty/services/user_api_services.dart';
import 'login.dart';
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
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();

  final _emailController = TextEditingController();
  final _nomorHPControler = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  final UserApiService userApiService = UserApiService();

  bool _isLoading = false;
  MyAnalytics analytics = MyAnalytics();

  final AuthService1 _authService = AuthService1();
 
  @override
  void dispose() {
    _emailController.dispose();
    _nomorHPControler.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpController.dispose();
    _namaController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    String email = _emailController.text.trim();
    String nomorHP = _nomorHPControler.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String nama = _namaController.text.trim();

    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama lengkap tidak boleh kosong!")),

    // validasi sama seperti sebelumnya
    if (email.isEmpty || nomorHP.isEmpty || username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua field wajib diisi!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (EmailSelected) {
      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email dan password tidak boleh kosong!")),
        );
        return;
      }
      if (password != confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Password tidak cocok!")),
        );
        return;
      }
    } else {
      if (nomorHP.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nomor HP tidak boleh kosong!")),
        );
        return;
      }
    }

    try {
      final user = await userApiService.registerUser(
        email: EmailSelected ? email : "",
        username: username,
        nomorHp: !EmailSelected ? nomorHP : "",
        password: EmailSelected ? password : "",
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi berhasil!'),
          backgroundColor: Colors.green,
        ),
      );

      // LANGSUNG KE LOGIN — DIPINDAH KE SINI
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password dan konfirmasi tidak sama!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final user = await _authService.signUpWithEmailPassword(
        email,
        password,
      );

      analytics.userRegister(email);

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registrasi berhasil!'),
            backgroundColor: Colors.green,
          ),
        );

        // Setelah register, langsung arahkan ke halaman login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registrasi gagal. Coba lagi."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registrasi gagal: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                  leading: Icon(
                    Icons.storefront,
                    size: 70,
                    color: Colors.white,
                  ),
                  title: Text(
                    "JobWaroeng",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "Temukan Pekerjaan Harianmu",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  width: 250,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(300),
                        blurRadius: 4,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF018ABE),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Daftar",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(300),
                        blurRadius: 4,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // === NAMA LENGKAP ===
                      TextField(
                        controller: _namaController,
                        decoration: InputDecoration(
                          hintText: "Nama Lengkap",
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // === TAB EMAIL / TELEPON ===
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD6EBEE),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    EmailSelected = true;
                                    _otpSent = false;
                                    _otpController.clear();
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: EmailSelected ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.email_outlined, size: 15),
                                      SizedBox(width: 10),
                                      Text("Email"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    EmailSelected = false;
                                    _otpSent = false;
                                    _otpController.clear();
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: !EmailSelected ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.phone, size: 15),
                                      SizedBox(width: 10),
                                      Text("Telepon"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // === FORM BERDASARKAN PILIHAN ===
                      if (EmailSelected) ...[
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: const Icon(Icons.email),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                        const SizedBox(height: 18),
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirm,
                          decoration: InputDecoration(
                            hintText: "Confirm Password",
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                            if (_namaController.text.trim().isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Nama lengkap wajib diisi!")),
                              );
                              return;
                            }
                            setState(() => _isLoading = true);
                            await _registerUser();
                            setState(() => _isLoading = false);
                          },
                          child: _isLoading
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text(
                                  "Register",
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                        ),
                      ] else ...[
                        TextField(
                          controller: _nomorHPControler,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: "Nomor Telepon",
                            prefixIcon: const Icon(Icons.phone),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                        const SizedBox(height: 18),
                        if (!_otpSent)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(320, 50),
                              backgroundColor: const Color(0xFF02457A),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            onPressed: _isLoading ? null : () async {
                              String nama = _namaController.text.trim();
                              String phone = _nomorHPControler.text.trim();

                              if (nama.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Nama lengkap wajib diisi sebelum kirim OTP!")),
                                );
                                return;
                              }
                              if (phone.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Nomor HP tidak boleh kosong!")),
                                );
                                return;
                              }

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
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
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
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                              ),
                              const SizedBox(height: 18),
                              // TOMBOL INI YANG DIPERBAIKI
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(320, 50),
                                  backgroundColor: const Color(0xFF02457A),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                                onPressed: _isLoading ? null : () async {
                                  setState(() => _isLoading = true);

                                  final user = await AuthServices().verifyOTP(_verificationId!, _otpController.text, context);
                                  if (user != null) {
                                    await _registerUser(); // Ini akan langsung ke Login karena Navigator di dalam _registerUser
                                  }

                                  setState(() => _isLoading = false);
                                },
                                child: _isLoading
                                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
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

                      const SizedBox(height: 10),
                      const Row(
                        children: [
                          Expanded(child: Divider(thickness: 1)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("atau"),
                          ),
                          Expanded(child: Divider(thickness: 1)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFD6EBEE),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: () {
                                final snackbar = SnackBar(
                                  content: const Row(
                                    children: [
                                      Icon(
                                        Icons.notifications_active,
                                        color: Color.fromARGB(255, 75, 74, 74),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Sign up for Google coming soon!",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: const Color(0xFFD6EBEE),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                              },
                              icon: Image.network(
                                'https://cdn-icons-png.flaticon.com/128/281/281764.png',
                                width: 25,
                                height: 25,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFD6EBEE),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: () {
                                final snackbar = SnackBar(
                                  content: const Row(
                                    children: [
                                      Icon(
                                        Icons.notifications_active,
                                        color: Color.fromARGB(255, 75, 74, 74),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Sign up for Facebook coming soon!",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: const Color(0xFFD6EBEE),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                              },
                              icon: Image.network(
                                'https://cdn-icons-png.flaticon.com/128/5968/5968764.png',
                                width: 25,
                                height: 25,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFD6EBEE),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              onPressed: () {
                                final snackbar = SnackBar(
                                  content: const Row(
                                    children: [
                                      Icon(
                                        Icons.notifications_active,
                                        color: Color.fromARGB(255, 75, 74, 74),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        "Sign up for Apple coming soon!",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  duration: const Duration(seconds: 3),
                                  backgroundColor: const Color(0xFFD6EBEE),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                              },
                              icon: Image.network(
                                'https://cdn-icons-png.flaticon.com/128/0/747.png',
                                width: 25,
                                height: 25,
                              ),
                            ),
                          ),
                        ],
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