import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:no_poverty/models/user_model_fix.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

void editUserProfile(UserModelFix data) {
  db.collection("users").doc(user!.uid).set(
    data.toUpdateMap(),
    SetOptions(merge: true),
  );
}


  Future<String?> uploadUserImage(String userId, File file) async {
    final storage = Supabase.instance.client.storage;

    final path =
        "users/$userId/profile-${DateTime.now().millisecondsSinceEpoch}.jpg";

    final res = await storage.from('jobWaroengStoragePublic').upload(path, file);
    if (res.isEmpty) return null;

    final imageUrl = Supabase.instance.client.storage
        .from('jobWaroengStoragePublic')
        .getPublicUrl(path);
    print(imageUrl);
    return imageUrl;
  }
}
