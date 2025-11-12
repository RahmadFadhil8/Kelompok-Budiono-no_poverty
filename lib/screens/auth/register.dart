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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nomorHPControler = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final UserApiService userApiService = UserApiService();
  final AuthService1 _authService = AuthService1();
  final MyAnalytics analytics = MyAnalytics();

  bool _isLoading = false;

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

  // ==========================================
  // FIXED REGISTER FUNCTION
  // ==========================================
  Future<void> _registerUser() async {
    String email = _emailController.text.trim();
    String nomorHP = _nomorHPControler.text.trim();
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String nama = _namaController.text.trim();

    // Validasi dasar
    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama lengkap tidak boleh kosong!")),
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
      // REGISTER KE API (UserApiService)
      final user = await userApiService.registerUser(
        email: EmailSelected ? email : "",
        username: username,
        nomorHp: !EmailSelected ? nomorHP : "",
        password: EmailSelected ? password : "",
      );

      // REGISTER KE FIREBASE (JIKA EMAIL MODE)
      if (EmailSelected) {
        final firebaseUser = await _authService.signUpWithEmailPassword(email, password);
        if (firebaseUser == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Gagal membuat akun Firebase")),
          );
          return;
        }
        analytics.userRegister(email);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi berhasil!"), backgroundColor: Colors.green),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registrasi gagal: ${e.toString().replaceAll('Exception: ', '')}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ==========================================
  // BUILD UI
  // ==========================================
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
                  title: Text(
                    "JobWaroeng",
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Temukan Pekerjaan Harianmu",
                      style: TextStyle(color: Colors.white, fontSize: 15)),
                ),
                const SizedBox(height: 40),

                // Toggle Login/Register
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
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                          ),
                          child: const Center(
                            child: Text("Login",
                                style: TextStyle(
                                    color: Colors.black, fontWeight: FontWeight.bold)),
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
                          child: const Text("Daftar",
                              style: TextStyle(
                                  color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // Form Register
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
                      // === Nama Lengkap ===
                      TextField(
                        controller: _namaController,
                        decoration: InputDecoration(
                          hintText: "Nama Lengkap",
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // === Tab Pilihan Email / Telepon ===
                      Container(
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
                      ),
                      const SizedBox(height: 18),

                      // === Form berdasarkan pilihan ===
                      if (EmailSelected)
                        _buildEmailForm()
                      else
                        _buildPhoneForm(),
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

  // === Helper Tab ===
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
            children: [
              Icon(icon, size: 15),
              const SizedBox(width: 10),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }

  // === Form Email ===
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
            hintText: "Confirm Password",
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
          onPressed: _isLoading
              ? null
              : () async {
                  setState(() => _isLoading = true);
                  await _registerUser();
                  setState(() => _isLoading = false);
                },
          child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Text("Register", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ],
    );
  }

  // === Form Telepon + OTP ===
  Widget _buildPhoneForm() {
    return Column(
      children: [
        TextField(
          controller: _nomorHPControler,
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
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(320, 50),
              backgroundColor: const Color(0xFF02457A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: _isLoading
                ? null
                : () async {
                    String phone = _nomorHPControler.text.trim();
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
                : const Text("Kirim OTP",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(320, 50),
                  backgroundColor: const Color(0xFF02457A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() => _isLoading = true);
                        final user = await AuthServices()
                            .verifyOTP(_verificationId!, _otpController.text, context);
                        if (user != null) {
                          await _registerUser();
                        }
                        setState(() => _isLoading = false);
                      },
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text("Verifikasi & Daftar",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
