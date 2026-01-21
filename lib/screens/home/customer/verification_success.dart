import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:no_poverty/main.dart';
import 'package:no_poverty/screens/profile/profile.dart';

class VerificationSuccessScreen extends StatefulWidget {
  const VerificationSuccessScreen({super.key});

  @override
  State<VerificationSuccessScreen> createState() =>
      _VerificationSuccessScreenState();
}

class _VerificationSuccessScreenState extends State<VerificationSuccessScreen> {
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
    _loadAndShowAd();
  }

  /// 🔹 Memuat dan menampilkan iklan rewarded
  void _loadAndShowAd() {
    RewardedAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/5224354917',
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;

          _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              print('Iklan ditutup oleh pengguna.');
              ad.dispose();
              _showSuccessAndNavigate();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('Gagal menampilkan iklan: $error');
              ad.dispose();
              _showSuccessAndNavigate();
            },
          );

          _rewardedAd!.show(
            onUserEarnedReward: (ad, reward) {
              print('User mendapatkan reward — lanjut ke verifikasi sukses');
              ad.dispose();
              _showSuccessAndNavigate();
            },
          );

          _rewardedAd = null;
        },
        onAdFailedToLoad: (error) {
          print('Gagal memuat rewarded ad: $error');
          _showSuccessAndNavigate();
        },
      ),
    );
  }

  /// 🔹 Menampilkan notifikasi dan navigasi ke halaman profil
  Future<void> _showSuccessAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isVerified', true);
    await prefs.setBool('verificationPending', false);

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'verification_success',
      'Verifikasi Sukses',
      channelDescription: 'Akun telah terverifikasi',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(
      1005,
      'Selamat! Akunmu Sudah Terverifikasi 🎉',
      'Sekarang kamu bisa akses semua fitur lengkap!',
      details,
    );

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ProfileScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.movie,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 20),
            const Text(
              "Tunggu sebentar, memuat iklan untuk akses lebih cepat...",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
