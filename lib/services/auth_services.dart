import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthServices {
  final currUser = FirebaseAuth.instance.currentUser;

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

    // Once signed in, return the UserCredential

    print(FirebaseAuth.instance.signInWithCredential(facebookAuthCredential));
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }
}
