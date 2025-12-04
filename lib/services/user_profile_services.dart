import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:no_poverty/models/user_model_fix.dart';

class UserProfileServices {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  void editUserProfile(UserModelFix userProfileData){
    try {
      db.collection("users").doc(user!.uid).set(userProfileData.toMap());
    } catch (e) {
      print(e);
    }
  }
}