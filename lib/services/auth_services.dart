import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/material.dart';

class AuthServices {
  final currUser = FirebaseAuth.instance.currentUser;

  Future<UserCredential> signInWithFacebook() async {
    final LoginResult loginResult = await FacebookAuth.instance.login();

    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  // ==========================================
  // PHONE AUTH DENGAN OTP — DIPERBAIKI & DIPERHALUS
  // ==========================================

  /// Kirim OTP ke nomor telepon
  /// Gunakan di emulator: +1 650-555-1234 → OTP otomatis: 5555453
  Future<String?> sendOTP(String phoneNumber, BuildContext context) async {
    String? verificationId;
    Completer<String?> completer = Completer();

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (!completer.isCompleted) completer.complete(null);
        },
        verificationFailed: (FirebaseAuthException e) {
          String errorMsg = e.message ?? "Gagal verifikasi nomor";
          if (e.code == 'invalid-phone-number') {
            errorMsg = "Nomor telepon tidak valid";
          } else if (e.code == 'quota-exceeded') {
            errorMsg = "Kuota SMS Firebase habis. Coba lagi nanti.";
          } else if (e.code.contains('BILLING')) {
            errorMsg = "Billing belum diaktifkan di Firebase. Aktifkan di console.firebase.google.com";
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMsg)),
          );
          if (!completer.isCompleted) completer.complete(null);
        },
        codeSent: (String verId, int? resendToken) {
          verificationId = verId;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("OTP terkirim! (Emulator: 5555453)"),
              backgroundColor: Colors.green,
            ),
          );
          if (!completer.isCompleted) completer.complete(verificationId);
        },
        codeAutoRetrievalTimeout: (String verId) {
          verificationId = verId;
          if (!completer.isCompleted && verificationId != null) {
            completer.complete(verificationId);
          }
        },
        timeout: const Duration(seconds: 60),
      );

      verificationId = await completer.future;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    return verificationId;
  }

  /// Verifikasi OTP dan login
  Future<User?> verifyOTP(String verificationId, String otp, BuildContext context) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Login dengan OTP berhasil!"),
          backgroundColor: Colors.green,
        ),
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String errorMsg = "OTP salah atau kadaluarsa";
      if (e.code == 'invalid-verification-code') {
        errorMsg = "Kode OTP tidak valid";
      } else if (e.code == 'session-expired') {
        errorMsg = "Sesi OTP kadaluarsa. Kirim ulang.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
      return null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      return null;
    }
    print(FirebaseAuth.instance.signInWithCredential(facebookAuthCredential));
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential> signInWithGitHub() async {
    GithubAuthProvider githubProvider = GithubAuthProvider();
    return await FirebaseAuth.instance.signInWithProvider(githubProvider);
  }
}
