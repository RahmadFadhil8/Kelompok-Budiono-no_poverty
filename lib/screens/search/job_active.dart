import 'package:flutter/material.dart';
import 'package:no_poverty/Database/job_database/job_database.dart';
import 'package:no_poverty/widgets/custom_card.dart';
import 'package:no_poverty/widgets/sub_title1.dart';
import 'package:no_poverty/widgets/title1.dart';

class JobActive extends StatefulWidget {
  const JobActive({super.key});

  @override
  State<JobActive> createState() => _JobActiveState();
}

class _JobActiveState extends State<JobActive> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: JobDatabase().getJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final datas = snapshot.data ?? [];
          if (datas.isEmpty) {
            return const Center(child: Text('Belum ada data job.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: datas.length,
            itemBuilder: (context, index) {
              final job = datas[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomCard(
                  childContainer: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              'https://picsum.photos/seed/${job.id}/120/120',
                              width: 85,
                              height: 85,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Title1(title: job.username ?? ''),
                              SubTitle1(title: job.title ?? ''),
                              SubTitle1(title: job.date ?? ''),
                              SubTitle1(title: job.location ?? ''),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Title1(title: job.salary?.toString() ?? '0', color: Colors.blue),
                          const SizedBox(height: 5),
                          CustomCard(
                            cardColor: Colors.blue,
                            childContainer: const Text(
                              "Online",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
