import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:no_poverty/screens/profile/profile.dart';
import 'verification_success.dart';

class VerificationProcessingScreen extends StatefulWidget {
  const VerificationProcessingScreen({super.key});

  @override
  State<VerificationProcessingScreen> createState() =>
      _VerificationProcessingScreenState();
}

class _VerificationProcessingScreenState
    extends State<VerificationProcessingScreen> {
  @override
  void initState() {
    super.initState();
    _completeVerification();
  }

  Future<void> _completeVerification() async {
    // Simulasi proses verifikasi (delay 3 detik)
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('verificationPending', true);

    if (!mounted) return;

    // Navigasi ke ProfileScreen setelah verifikasi sementara
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
      (route) => false,
    );

    // Delay tambahan sebelum masuk ke halaman sukses
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VerificationSuccessScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(32),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // --- Icon Proses ---
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(
                    Icons.access_time_filled,
                    size: 60,
                    color: Colors.blue.shade700,
                  ),
                ),

                const SizedBox(height: 32),

                // --- Judul Utama ---
                const Text(
                  "Memproses Verifikasi",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 16),

                // --- Deskripsi Proses ---
                const Text(
                  "Dokumen Anda sedang diverifikasi. "
                  "Proses ini membutuhkan waktu 1-3 hari kerja.",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // --- Progress Bar ---
                LinearProgressIndicator(
                  value: 0.7,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation(Colors.blue.shade600),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),

                const SizedBox(height: 32),

                // --- Info Tambahan ---
                const Text(
                  "Anda akan mendapat notifikasi setelah verifikasi selesai.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
