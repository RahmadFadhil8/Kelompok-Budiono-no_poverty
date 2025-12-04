import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:no_poverty/models/job_model_fix_firestore.dart';

class JobService {
  final CollectionReference jobs = FirebaseFirestore.instance.collection("jobs");

  Future<void> createJob(JobModelFix job) async {
    await jobs.doc(job.job_id).set(job.toMap());
  }

  Future<List<JobModelFix>> getallJob() async {
    final Data = await jobs.get();

    return Data.docs.map((doc) => JobModelFix.fromMap(doc.id, doc.data() as Map<String, dynamic>)).toList();
  }
}