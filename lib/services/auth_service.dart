import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 🔹 Register user (Email + Password)
  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      // Handle error codes lebih spesifik
      switch (e.code) {
        case 'email-already-in-use':
          print(" Email sudah terdaftar");
          break;
        case 'invalid-email':
          print(" Format email tidak valid");
          break;
        case 'weak-password':
          print(" Password terlalu lemah");
          break;
        default:
          print(" Error tidak diketahui: ${e.code}");
      }
      return null;
    }
  }

  // 🔹 Login user (Email + Password)
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          print(" Pengguna tidak ditemukan");
          break;
        case 'wrong-password':
          print(" Password salah");
          break;
        case 'invalid-email':
          print(" Email tidak valid");
          break;
        default:
          print(" Error tidak diketahui: ${e.code}");
      }
      return null;
    }
  }

  // 🔹 Logout user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 🔹 Ambil user yang sedang login
  User? get currentUser => _auth.currentUser;
}
