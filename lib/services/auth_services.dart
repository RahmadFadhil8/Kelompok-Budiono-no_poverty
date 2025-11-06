import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final currUser = FirebaseAuth.instance.currentUser;
}