import 'package:flutter/material.dart';
import 'package:no_poverty/Database/job_database/job_database.dart';
import 'package:no_poverty/services/user_api_services.dart';
import 'package:no_poverty/widgets/custom_card.dart';
import 'package:no_poverty/widgets/sub_title1.dart';
import 'package:no_poverty/widgets/title1.dart';

class JobActive extends StatefulWidget {
  final String searchQuery;

  const JobActive({super.key, required this.searchQuery});

  @override
  State<JobActive> createState() => _JobActiveState();
}

class _JobActiveState extends State<JobActive> {
  UserAPIServices users = UserAPIServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: users.getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada data job.'));
          }

          final datas = snapshot.data!;

          final filterData = datas.where((job) {
            final query = widget.searchQuery.toLowerCase();
            return job.nama.toLowerCase().contains(query) ||
            job.username.toLowerCase().contains(query) ||
            job.lokasi.toLowerCase().contains(query);
            }
          ).toList();

          if (filterData.isEmpty) {
          return const Center(child: Text('Tidak ada hasil yang cocok.'));
        }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: filterData.length,
            itemBuilder: (context, index) {
              final job = filterData[index];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomCard(
                  childContainer: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Title1(title: job.username),
                                SubTitle1(title: job.nama),
                                SubTitle1(title: job.pekerjaan),
                                SubTitle1(title: job.lokasi),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Title1(title: job.salary, color: Colors.blue),
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
