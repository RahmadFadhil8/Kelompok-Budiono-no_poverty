import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModelFix {
  final String transactionId;
  final String jobId;
  final String employerId;
  final String workerId;
  final String status; 
  final double amount;
  final double platformFee;
  final double workerReceiveAmount;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  TransactionModelFix({
    required this.transactionId,
    required this.jobId,
    required this.employerId,
    required this.workerId,
    required this.status,
    required this.amount,
    required this.platformFee,
    required this.workerReceiveAmount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TransactionModelFix.fromMap(String id, Map<String, dynamic> data) {
    return TransactionModelFix(
      transactionId: id,
      jobId: data["job_id"],
      employerId: data["employer_id"],
      workerId: data["worker_id"],
      status: data["status"],
      amount: (data["amount"] as num).toDouble(),
      platformFee: (data["platform_fee"] as num).toDouble(),
      workerReceiveAmount: (data["worker_receive_amount"] as num).toDouble(),
      createdAt: data["created_at"],
      updatedAt: data["updated_at"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "job_id": jobId,
      "employer_id": employerId,
      "worker_id": workerId,
      "status": status,
      "amount": amount,
      "platform_fee": platformFee,
      "worker_receive_amount": workerReceiveAmount,
      "created_at": createdAt,
      "updated_at": updatedAt,
    };
  }
}
