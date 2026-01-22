import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:no_poverty/services/job_services_firestore.dart';
import 'package:no_poverty/widgets/sub_title1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailJob extends StatefulWidget {
  final String JobId;
  const DetailJob({super.key, required this.JobId});

  @override
  State<DetailJob> createState() => _DetailJobState();
}

class _DetailJobState extends State<DetailJob> {

String? currentUserId;

@override
void initState() {
  super.initState();
  _getCurrentUserId();
}

Future<void> _getCurrentUserId() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    currentUserId = prefs.getString("userId");
  });
}


  JobService jobs = JobService();

  final formatWaktu = DateFormat.Hm();
  
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

          // === ERROR STATE ===
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // === EMPTY STATE ===
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Data tidak tersedia."));
          }

          final job = snapshot.data!;
          final bool isOwner = job.employer_id == currentUserId;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 22, 
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: SubTitle1(
                            title: job.status.toUpperCase(),
                            size: 12,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10,),
            
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
                
                const SizedBox(height: 20),
            
                Text("Deskripsi:", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
            
                SizedBox(height: 8),
            
                Text(job.description),
            
                const SizedBox(height: 20),
            
                Text("Kategori:", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
            
                SizedBox(height: 8),
            
                Text(job.category),
            
                const SizedBox(height: 20),
            
                Text("Alamat:", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
            
                SizedBox(height: 8),
            
                Text(job.address),
            
                const SizedBox(height: 20),
            
                Text("Helper yang dibutuhkan:", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
            
                SizedBox(height: 8),
            
                Text("${job.max_applicants.toString()} orang"),
            
                const SizedBox(height: 20),
            
                Text("Waktu Mulai Kerja dan berakhir", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
            
                SizedBox(height: 8),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${formatWaktu.format(job.start_time.toDate())} Mulai"),
                    Text("${formatWaktu.format(job.end_time.toDate())} Berakhir"),
                  ],
                ),
            
                const SizedBox(height: 20),
            
                Text("Skill yang dibutuhkan:", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
            
                SizedBox(height: 8),
            
                Text("${job.requiredSkills.join(", ")}"),
            
                const SizedBox(height: 20),
            
                Text("worker yang apply:", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
            
                SizedBox(height: 8),
            
                Text(job.worker_id_apply.isEmpty ? "Belum ada worker yang apply" : job.worker_id_apply.join(", ")),
            
                const SizedBox(height: 20),
            
                Text("Upah: Rp ${job.wage.toStringAsFixed(0)}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
            
                const SizedBox(height: 20),
            
                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      side: BorderSide(color: isOwner ? Colors.grey : Colors.blue,),
                    ),
                    onPressed: isOwner ? null : (){
            
                    },
                    child: Text(
                      isOwner ? "Anda pemilik job ini" : "Apply",
                      style: TextStyle(color: isOwner ? Colors.grey : Colors.blue,),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      )
    );
  }
}