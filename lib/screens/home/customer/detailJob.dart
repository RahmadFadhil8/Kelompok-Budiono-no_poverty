import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:no_poverty/models/job_model_fix_firestore.dart';
import 'package:no_poverty/services/job_services_firestore.dart';
import 'package:no_poverty/services/notification_services.dart';
import 'package:no_poverty/services/transaction_services_firestore.dart';
import 'package:no_poverty/widgets/sub_title1.dart';
import 'package:no_poverty/screens/home/customer/transaction_succes_screen.dart';
import 'package:no_poverty/services/notification_service.dart';

class DetailJob extends StatefulWidget {
  final String JobId;
  const DetailJob({super.key, required this.JobId});

  @override
  State<DetailJob> createState() => _DetailJobState();
}

class _DetailJobState extends State<DetailJob> {
  JobService jobs = JobService();
  final formatWaktu = DateFormat.Hm();

  Future<void> applyJob(JobModelFix job) async {
    final String workerId = "WORKER_ID_LOGIN";  

    try {
      await FirebaseFirestore.instance
          .collection("jobs")
          .doc(job.job_id)
          .update({
        "worker_id_apply": FieldValue.arrayUnion([workerId]),
        "updated_at": Timestamp.now(),
      });

      final transactionId =
          await TransactionService().createJobTransaction(job, workerId);

      await NotificationServices.showNotification(
      title: "Lamaran Berhasil",
      body: "Kamu berhasil melamar pekerjaan ${job.title}",
    );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => TransactionSuccessScreen(
            transactionId: transactionId,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // =======================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Job"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: jobs.getByid(widget.JobId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Data tidak tersedia."));
          }

          final job = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SubTitle1(
                        title: job.status,
                        size: 12,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey),
                        SizedBox(width: 6),
                        Text(job.city, style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.calendar_month, color: Colors.grey),
                        SizedBox(width: 6),
                        Text(
                          DateFormat('dd/MM/yyyy')
                              .format(job.date_time.toDate()),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  ],
                ),

                SizedBox(height: 20),

                Text("Deskripsi:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text(job.description),

                SizedBox(height: 20),

                Text("Kategori:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text(job.category),

                SizedBox(height: 20),

                Text("Alamat:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text(job.address),

                SizedBox(height: 20),

                Text("Helper yang dibutuhkan:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text("${job.max_applicants} orang"),

                SizedBox(height: 20),

                Text("Waktu kerja",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${formatWaktu.format(job.start_time.toDate())} Mulai"),
                    Text("${formatWaktu.format(job.end_time.toDate())} Selesai"),
                  ],
                ),

                SizedBox(height: 20),

                Text("Skill yang dibutuhkan:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text(job.requiredSkills.join(", ")),


                SizedBox(height: 20),

                Text("Worker yang apply:",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 8),
                Text(job.worker_id_apply.isEmpty
                    ? "Belum ada"
                    : job.worker_id_apply.join(", ")),


                SizedBox(height: 20),

                Text("Upah: Rp ${job.wage.toStringAsFixed(0)}",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                SizedBox(height: 30),

                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        side: BorderSide(color: Colors.blue)),
                    onPressed: () {
                      applyJob(job);
                    },
                    child: Text("Apply", style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
