import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:no_poverty/screens/home/customer/detailJob.dart';
import 'package:no_poverty/services/job_applications_service.dart';
import 'package:no_poverty/widgets/custom_card.dart';
import 'package:no_poverty/widgets/sub_title1.dart';
import 'package:no_poverty/widgets/title1.dart';

class JadwalHarian extends StatefulWidget {
  const JadwalHarian({super.key});

  @override
  State<JadwalHarian> createState() => _JadwalHarianState();
}

class _JadwalHarianState extends State<JadwalHarian> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: JobApplicationsService().getAppliedJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Job Belum tersedia."));
          }

          final jobs = snapshot.data!;

          return SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: jobs.length,
              padding: const EdgeInsets.only(left: 16),
              itemBuilder: (context, index) {
                final item = jobs[index];
                final job = item["job"];
                final app = item["application"];
                final jobId = item["jobId"];

                DateTime? jobDate;
                if (job["date_time"] is Timestamp) {
                  jobDate = (job["date_time"] as Timestamp).toDate();
                }

                return Container(
                  width: MediaQuery.of(context).size.width * 0.88,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: CustomCard(
                    padding: 16,
                    onTapCard: () {},
                    childContainer: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Title1(title: job["title"] ?? "-", size: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.deepOrangeAccent),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: SubTitle1(
                                title: app["status"] ?? "-",
                                size: 10,
                                color: Colors.deepOrangeAccent,
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            SubTitle1(
                              title: job["city"] ?? "-",
                              size: 13,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 16),
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 4),
                            SubTitle1(
                              title:
                                  jobDate != null
                                      ? DateFormat("dd/MM/yyyy").format(jobDate)
                                      : "-",
                              size: 13,
                              color: Colors.grey,
                            ),
                          ],
                        ),

                        SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Title1(
                                  title:
                                      "Rp ${(job["wage"] as num?)?.toStringAsFixed(0) ?? "0"}",
                                  size: 14,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 16),
                                Icon(
                                  Icons.people,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 4),
                                SubTitle1(
                                  title:
                                      (job["max_applicants"] ?? 0).toString(),
                                  size: 13,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                side: const BorderSide(color: Colors.grey),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => DetailJob(JobId: jobId),
                                  ),
                                );
                              },
                              child: const Text(
                                "Detail",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
