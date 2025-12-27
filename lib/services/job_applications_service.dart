import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class JobApplicationsService {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> createApplication({required String jobId}) async {
    try {
      print("JOB ID YG DITERIMA: $jobId");

      final userId = _auth.currentUser!.uid;
      // final userDoc = await db.collection("users").doc(userId).get();

      // final userData = userDoc.data()!;
      // final role = userData["role"];

      // // cek role user worker atau both
      // if (role != "worker" && role != "both") {
      //   return "bukan worker";
      // }

      final workerId = userId;

      //ambil data job
      final jobDoc = await db.collection("jobs").doc(jobId).get();

      if (!jobDoc.exists) {
        return "job_not_found";
      }

      final jobData = jobDoc.data()!;
      final employerId = jobData["employer_id"];

      //cek sudah pernah lamar atau tidak
      final existing =
          await db
              .collection("applications")
              .where("job_id", isEqualTo: jobId)
              .where("worker_id", isEqualTo: workerId)
              .get();

      if (existing.docs.isNotEmpty) {
        return "sudah ada";
      }

      await db.collection("applications").add({
        "job_id": jobId,
        "worker_id": workerId,
        "employer_id": employerId,
        "status":
            "pending", // sementara, akan bisa di update berdasarkan status di job collection
        "expected_wage": null,
        "message": "",
        "applied_at": FieldValue.serverTimestamp(),
        "updated_at": FieldValue.serverTimestamp(),
      });

      return "success";
      
    } catch (e) {
      print("Gagal menambahkan data $e");
      return "error";
    }
  }

  Future<List<QueryDocumentSnapshot>> getApplications() async {
    try {
      final workerId = _auth.currentUser!.uid;

      final query =
          await db
              .collection("applications")
              .where("worker_id", isEqualTo: workerId)
              .orderBy("applied_at", descending: false)
              .get();

      return query.docs;
    } catch (e) {
      print("Gagal mengambil data $e");
      return [];
    }
  }


  Stream<List<Map<String, dynamic>>> getAppliedJobs() {
    final workerId = _auth.currentUser!.uid;

    return db.collection("applications").where("worker_id", isEqualTo: workerId).orderBy('applied_at', descending: false).snapshots().asyncMap((applicationSnapshot) async {
      if(applicationSnapshot.docs.isEmpty)
      return [];

      List<Map<String, dynamic>> listDilamar = [];

      for (var appDoc in applicationSnapshot.docs) {
        final appData = appDoc.data();

        final jobsDoc = await db.collection("jobs").doc(appData["job_id"]).get();

      listDilamar.add({
        "jobId": jobsDoc.id,
        "job": jobsDoc.data(),
        "application": appData,
      });
      }

      return listDilamar;
    });
  }


  Stream<List<Map<String, dynamic>>> getAvailableJobs() {
  final workerId = _auth.currentUser!.uid;

  return db.collection("jobs").snapshots().asyncMap((jobSnap) async {
    final appliedSnap = await db.collection("applications").where("worker_id", isEqualTo: workerId).get();

    final appliedJobIds = appliedSnap.docs.map((doc) => doc["job_id"].toString()).toSet();

    List<Map<String, dynamic>> availableJobs = [];
    for (var jobDoc in jobSnap.docs) {
      final data = jobDoc.data();
      final status = (data["status"] ?? '').toString().toLowerCase();

      if (!appliedJobIds.contains(jobDoc.id) && status == "open") { 
        availableJobs.add({
          "jobId": jobDoc.id,
          "job": data,

        });
      }
    }

    return availableJobs;
  });
}

    
}
