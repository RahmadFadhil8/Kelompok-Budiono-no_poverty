import 'dart:async';
import 'package:flutter/material.dart';
import 'package:no_poverty/Analytics/analytics_helper.dart';
import 'package:no_poverty/services/auth_serviceDedi.dart';
import 'package:no_poverty/services/auth_services.dart';
import 'package:no_poverty/services/user_api_services.dart';
import 'package:no_poverty/Database/user_database/user_database.dart';
import 'package:no_poverty/screens/auth/register.dart';
import 'package:no_poverty/screens/main_bottom_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool emailSelected = true;
  bool isLoggedIn = false;
  bool _isObscure = true;
  bool _otpSent = false;
  bool _isLoading = false;

  String? _verificationId;

  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final AuthService1 _authService = AuthService1();
  final AuthServices _firebaseAuth = AuthServices();
  final MyAnalytics analytics = MyAnalytics();

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  void dispose() {
    _userController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool logged = prefs.getBool('isLoggedIn') ?? false;
    if (logged) {
      setState(() => isLoggedIn = true);
    }
  }

  Future<void> loginUser() async {
    final input = _userController.text.trim();
    final password = _passwordController.text;

    if (input.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email/Telepon dan password tidak boleh kosong!")),
      );
      return;
    }

    try {
      final user = await _authService.signInWithEmailPassword(input, password);
      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('userId', user.uid);
        await prefs.setString('userEmail', user.email ?? '');

        await analytics.userLogin(input);
        await analytics.usertimeout();
        await analytics.userId(user.uid);
        await analytics.userpoperty(user.email);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login berhasil")),
        );

        setState(() => isLoggedIn = true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login gagal. Periksa email dan password.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }

  // 🔹 OTP Login
  Future<void> sendOtp() async {
    String phone = _userController.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nomor telepon tidak boleh kosong!")),
      );
      return;
    }

    if (!phone.startsWith('+')) phone = '+62$phone';
    setState(() => _isLoading = true);

    final verId = await _firebaseAuth.sendOTP(phone, context);
    if (verId != null) {
      setState(() {
        _verificationId = verId;
        _otpSent = true;
      });
    }

    setState(() => _isLoading = false);
  }

  Future<void> verifyOtp() async {
    if (_verificationId == null) return;
    setState(() => _isLoading = true);

    final user = await _firebaseAuth.verifyOTP(
      _verificationId!,
      _otpController.text.trim(),
      context,
    );

    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      setState(() => isLoggedIn = true);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) return const MainBottomNavigation();

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
                  title: Text(
                    "JobWaroeng",
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Temukan Pekerjaan Harianmu",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                const SizedBox(height: 40),

                // LOGIN / DAFTAR SWITCH
                Container(
                  width: 250,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF018ABE),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const RegisterScreen()),
                            );
                          },
                          child: const Center(
                            child: Text(
                              "Daftar",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 35),

                // FORM LOGIN
                Container(
                  padding: const EdgeInsets.all(20),
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      // Switch Email / Phone
                      Row(
                        children: [
                          Expanded(
                            child: ChoiceChip(
                              label: const Text("Email"),
                              selected: emailSelected,
                              onSelected: (v) => setState(() => emailSelected = true),
                            ),
                          ),
                          Expanded(
                            child: ChoiceChip(
                              label: const Text("Telepon"),
                              selected: !emailSelected,
                              onSelected: (v) => setState(() => emailSelected = false),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      TextField(
                        controller: _userController,
                        keyboardType: emailSelected
                            ? TextInputType.emailAddress
                            : TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: emailSelected ? "Email" : "Nomor Telepon",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Password / OTP input
                      if (emailSelected)
                        TextField(
                          controller: _passwordController,
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            hintText: "Password",
                            suffixIcon: IconButton(
                              icon: Icon(_isObscure
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () => setState(() {
                                _isObscure = !_isObscure;
                              }),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        )
                      else if (!_otpSent)
                        ElevatedButton(
                          onPressed: _isLoading ? null : sendOtp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF02457A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("Kirim OTP"),
                        )
                      else
                        Column(
                          children: [
                            TextField(
                              controller: _otpController,
                              decoration: InputDecoration(
                                hintText: "Masukkan OTP (6 digit)",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            ElevatedButton(
                              onPressed: _isLoading ? null : verifyOtp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF02457A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text("Verifikasi OTP"),
                            ),
                          ],
                        ),

                      const SizedBox(height: 20),

                      // Tombol Login Email
                      if (emailSelected)
                        ElevatedButton(
                          onPressed: loginUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF02457A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),

                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 10),

                      // Social Login Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Google
                          socialButton(
                            iconUrl: 'https://cdn-icons-png.flaticon.com/128/281/281764.png',
                            message: "Google login coming soon!",
                          ),

                          const SizedBox(width: 10),

                          // Facebook
                          socialButton(
                            iconUrl: 'https://cdn-icons-png.flaticon.com/128/733/733547.png',
                            onTap: () async {
                              await _firebaseAuth.signInWithFacebook();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Login Facebook berhasil!")),
                              );
                            },
                          ),

                          const SizedBox(width: 10),

                          // GitHub
                          socialButton(
                            iconUrl:
                                'https://github.githubassets.com/assets/GitHub-Mark-ea2971cee799.png',
                            onTap: () async {
                              await _firebaseAuth.signInWithGitHub();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Login GitHub berhasil!")),
                              );
                            },
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

  Widget socialButton({
    required String iconUrl,
    VoidCallback? onTap,
    String? message,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD6EBEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Image.network(iconUrl, width: 25, height: 25),
        onPressed: onTap ??
            () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message ?? "Coming soon!")),
              );
            },
      ),
    );
  }
}
