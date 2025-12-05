import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:no_poverty/models/user_model_fix.dart';

class UserProfileServices {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  Stream<UserModelFix> getUserProfile() {
    return db.collection("users").doc(user!.uid).snapshots().map((snapshot) {
      final data = snapshot.data();
      if (data == null) {
        return UserModelFix.empty(user!.uid);
      }
      return UserModelFix.fromMap(user!.uid, data);
    });
  }

  Future<UserModelFix> getUserProfileOnce() async {
    final doc = await db.collection("users").doc(user!.uid).get();
    final data = doc.data();

    if (data == null) {
      return UserModelFix.empty(user!.uid);
    }

    return UserModelFix.fromMap(user!.uid, data);
  }

  void editUserProfile(UserModelFix userProfileData) {
    try {
      db.collection("users").doc(user!.uid).set(userProfileData.toMap());
    } catch (e) {
      print(e);
    }
  }
}
