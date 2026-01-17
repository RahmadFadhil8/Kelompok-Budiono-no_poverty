import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job_model_fix_firestore.dart';
import '../models/transaction_model_fix.dart';

class TransactionService {
  final CollectionReference transactions =
      FirebaseFirestore.instance.collection("transactions");

  Future<void> createTransaction(TransactionModelFix trx) async {
    await transactions.doc(trx.transactionId).set(trx.toMap());
  }

  Future<String> createJobTransaction(JobModelFix job, String workerId) async {
    final String transactionId =
        FirebaseFirestore.instance.collection("transactions").doc().id;

    double amount = job.wage;
    double platformFee = amount * 0.10;
    double workerReceive = amount - platformFee;

    final trx = TransactionModelFix(
      transactionId: transactionId,
      jobId: job.job_id,
      employerId: job.employer_id,
      workerId: workerId,
      status: "pending_payment",
      amount: amount,
      platformFee: platformFee,
      workerReceiveAmount: workerReceive,
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );

    await createTransaction(trx);

    return transactionId; 
  }
}
