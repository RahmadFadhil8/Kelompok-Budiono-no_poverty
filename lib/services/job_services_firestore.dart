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

  Future<JobModelFix?> getByid (String id) async {
    final Data = await jobs.doc(id).get();

    if(!Data.exists) return null;

    return JobModelFix.fromMap(Data.id, Data.data() as Map<String, dynamic>);
  }
}