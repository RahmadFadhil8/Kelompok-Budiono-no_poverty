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

  bool EmailSelected = true;
  bool isLoggedIn = false;
  bool _isObscure = true;

  // TAMBAHAN UNTUK OTP
  String? _verificationId;
  bool _otpSent = false;
  final TextEditingController _otpController = TextEditingController();

  UserApiService users = UserApiService();
  MyAnalytics analytics = MyAnalytics();
  

  final AuthService1 _authService = AuthService1();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final UserApiService userApiService = UserApiService();

  // TAMBAHAN: Loading state
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

    _userController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool Log = prefs.getBool('isLoggedIn') ?? false;
    if (Log) {
      setState(() {
        isLoggedIn = true;
      });
    }
  }

  Future<void> loginUser() async {
    String input = _userController.text.trim();
    String password = _passwordController.text;

    if (input.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email/Telepon dan password tidak boleh kosong!"),
        ),
      );
      return;
    }
    try {
      final user = await _authService.signInWithEmailPassword(input,password,);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userEmail', user.email);
      
      
      if (user != null) {  

        SharedPreferences prefs = await SharedPreferences.getInstance();
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
        setState(() {
          isLoggedIn = true;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Login berhasil")));
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

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return const MainBottomNavigation();
    }
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
                SizedBox(height: 40),
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
                        offset: Offset(0, 5),
                      ),
                    ],
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
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              "Daftar",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 35),
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
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD6EBEE),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: EmailSelected
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(300),
                                    blurRadius: 3,
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    EmailSelected = true;
                                    _userController.clear();
                                    _passwordController.clear();
                                    _isObscure = true;
                                    _otpSent = false;
                                    _otpController.clear();
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: EmailSelected ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: EmailSelected
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(300),
                                              blurRadius: 3,
                                            ),
                                          ]
                                        : null,
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
                                    _userController.clear();
                                    _passwordController.clear();
                                    _isObscure = true;
                                    _otpSent = false;
                                    _otpController.clear();
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: !EmailSelected ? Colors.white : Colors.transparent,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: !EmailSelected
                                        ? [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(300),
                                              blurRadius: 3,
                                            ),
                                          ]
                                        : null,
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
                      const SizedBox(height: 30),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          TextField(
                            controller: _userController,
                            keyboardType: EmailSelected ? TextInputType.emailAddress : TextInputType.phone, // ANGKA
                            decoration: InputDecoration(
                              hintText: EmailSelected ? "Email" : "Nomor Telepon",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // === PASSWORD / OTP FIELD (LANGSUNG MUNCUL, TANPA ANIMASI) ===
                          if (EmailSelected)
                            TextField(
                              controller: _passwordController,
                              obscureText: _isObscure,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  },
                                  icon: Icon(
                                    _isObscure ? Icons.visibility_off : Icons.visibility,
                                    color: Color(0xFF808080),
                                  ),
                                ),
                                hintText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            )
                          else if (!_otpSent)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(320, 50),
                                backgroundColor: Color(0xFF02457A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: _isLoading ? null : () async {
                                String phone = _userController.text.trim();

                                if (phone.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Nomor telepon tidak boleh kosong!")),
                                  );
                                  return;
                                }

                                if (!phone.startsWith('+')) phone = '+62$phone';

                                setState(() => _isLoading = true);

                                final verId = await AuthServices().sendOTP(phone, context);
                                if (verId != null) {
                                  setState(() {
                                    _verificationId = verId;
                                    _otpSent = true; // LANGSUNG MUNCUL — TIDAK ADA TRANSISI HITAM
                                  });
                                }

                                setState(() => _isLoading = false);
                              },
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
                                      "Kirim OTP",
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                            )
                          else
                            Column(
                              children: [
                                TextField(
                                  controller: _otpController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: "Masukkan OTP (6 digit)",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  ),
                                ),
                                const SizedBox(height: 18),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(320, 50),
                                    backgroundColor: Color(0xFF02457A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: _isLoading ? null : () async {
                                    if (_verificationId == null) return;

                                    setState(() => _isLoading = true);

                                    final user = await AuthServices().verifyOTP(
                                      _verificationId!,
                                      _otpController.text.trim(),
                                      context,
                                    );
                                    if (user != null) {
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      await prefs.setBool('isLoggedIn', true);
                                      setState(() {
                                        isLoggedIn = true;
                                      });
                                    }

                                    setState(() => _isLoading = false);
                                  },
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
                                          "Verifikasi OTP",
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
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

                          // untuk login
                          const SizedBox(height: 18),

                          // === TOMBOL LOGIN (HANYA EMAIL) ===
                          if (EmailSelected)
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(320, 50),
                                backgroundColor: Color(0xFF02457A),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: loginUser,
                              child: const Text(
                                "Login",
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),

                          const SizedBox(height: 10),
                          Row(
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
                                  color: Color(0xFFD6EBEE),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    final snackbar = SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.notifications_active,
                                            color: const Color.fromARGB(255, 75, 74, 74),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Sign up for Google coming soon!",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Color(0xFFD6EBEE),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                              SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFD6EBEE),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    await AuthServices().signInWithFacebook();
                                    await AuthServices().signInWithGitHub();
                                    print("sign with github");

                                    final snackbar = SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.notifications_active,
                                            color: const Color.fromARGB(255, 75, 74, 74),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Sign up for Facebook coming soon!",
                                            style: TextStyle(color: Colors.black),
                                            "Sign up with github success",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Color(0xFFD6EBEE),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snackbar);
                                  },
                                  icon: Image.network(
                                    'https://github.githubassets.com/assets/GitHub-Mark-ea2971cee799.png',
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFD6EBEE),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    print("login dengan github");
                                    final snackbar = SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(
                                            Icons.notifications_active,
                                            color: const Color.fromARGB(255, 75, 74, 74),
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            "Sign up for Apple coming soon!",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Color(0xFFD6EBEE),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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