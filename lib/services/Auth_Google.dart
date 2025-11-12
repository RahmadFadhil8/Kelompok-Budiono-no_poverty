import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthGoogle {
  static final AuthGoogle _instance = AuthGoogle._internal();
  factory AuthGoogle() => _instance;
  AuthGoogle._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

Future<UserCredential?> signInWithGoogle() async{
  try {
    final GoogleSignInAccount? user = await _googleSignIn.signIn();
    if (user == null) return null;

    final GoogleSignInAuthentication googleAuth = await user.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await _auth.signInWithCredential(credential);

  } catch (e) {
    print("Google SignIn Error: $e");
    rethrow;
    
  }
}

Future<void> signOut() async {
  await _googleSignIn.signOut();
  await _auth.signOut();
}
  Stream<User?> get userStream => _auth.authStateChanges();

}