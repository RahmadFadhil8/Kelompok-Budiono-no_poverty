import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:no_poverty/Analytics/analytics_helper.dart';
import 'package:no_poverty/Permission/handler.dart';
import 'package:no_poverty/models/user_model_fix.dart';
import 'package:no_poverty/screens/auth/login.dart';
import 'package:no_poverty/screens/profile/edit_profile.dart';
import 'package:no_poverty/services/auth_services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ← TAMBAHAN INI SAJA

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool pushNotif = true;
  bool emailNotif = false;
  bool smsNotif = false;
  bool location = false;

  final Handler_Permission permission = Handler_Permission();
  MyAnalytics analytics = MyAnalytics();
  final AuthServices _authService = AuthServices();

  // TAMBAHAN: Cek status verifikasi dari SharedPreferences
  Future<bool> _checkVerificationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isVerified') ?? false;
  }

  @override
  void initState() {
    super.initState();
    analytics.clikcbutton('open_profile_screen');
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser!;
    final userData = context.watch<UserModelFix?>();
    if (userData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Pengaturan",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======== PROFILE CARD ========
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(userData!.imageUrl),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userData.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(user.email!, style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            SizedBox(width: 4),
                            Text(
                              "4.8 rating",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfile(user: user),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blueAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Edit",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ======== AKUN SECTION ========
            const Text(
              "Akun",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            _buildListTile(
              icon: Icons.person_outline,
              title: "Informasi Akun",
              onTap: () {},
            ),

            // STATUS VERIFIKASI — OTOMATIS GANTI JADI "Verified" KALAU SUDAH SELESAI
            FutureBuilder<bool>(
              future: _checkVerificationStatus(),
              builder: (context, snapshot) {
                final bool isVerified = snapshot.data ?? false;
                return _buildListTile(
                  icon: Icons.verified_user_outlined,
                  title: "Status Verifikasi",
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isVerified ? Colors.green[100] : Colors.yellow[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isVerified ? "Verified" : "Pending",
                      style: TextStyle(
                        color: isVerified ? Colors.green[800] : Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  onTap: () {},
                );
              },
            ),

            _buildListTile(
              icon: Icons.payment_outlined,
              title: "Metode Pembayaran",
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // ======== NOTIFIKASI SECTION ========
            const Text(
              "Notifikasi",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            _buildSwitchTile(
              title: "Push Notifications",
              value: pushNotif,
              onChanged: (v) => setState(() => pushNotif = v),
            ),
            _buildSwitchTile(
              title: "Email Notifications",
              value: emailNotif,
              onChanged: (v) => setState(() => emailNotif = v),
            ),
            _buildSwitchTile(
              title: "SMS Notifications",
              value: smsNotif,
              onChanged: (v) async {
                if (v == true) {}
              },
            ),
            _buildSwitchTile(
              title: "Location Permission",
              value: location,
              onChanged: (v) async {
                if (v == true) {
                  try {
                    Position? pos = await permission.getLocation();

                    if (pos != null) {
                      setState(() => location = true);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Lokasi diaktifkan: ${pos.latitude}, ${pos.longitude}",
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    setState(() => location = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal mengaktifkan lokasi: $e")),
                    );
                  }
                } else {
                  setState(() => location = false);
                  openAppSettings();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Permission tidak bisa dicabut lewat aplikasi.\nMatikan lewat Pengaturan Sistem.",
                      ),
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 32),

            // ======== LOGOUT BUTTON ========
            Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await analytics.userlogout();
                  await _authService.signOut();
                  await analytics.resetData();
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Logout",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        value: value,
        activeColor: Colors.blueAccent,
        onChanged: onChanged,
      ),
    );
  }
}
