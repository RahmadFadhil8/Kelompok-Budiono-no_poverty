import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthServicesContract {
  Future<User?> signInWithEmailPassword(
    String email,
    String password,
  );
  Future<User?> signUpWithEmailPassword(
    String email,
    String password,
  );
}
