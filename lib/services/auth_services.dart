import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

    Future<UserCredential?> signInWithGitHub() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      GithubAuthProvider githubProvider = GithubAuthProvider();
      final tmp = await _auth.signInWithProvider(githubProvider);
      prefs.setBool("isLoggedIn", true);
      return tmp;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
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

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      prefs.setBool("isLoggedIn", true);
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

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}
