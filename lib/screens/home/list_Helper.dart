import 'package:flutter/material.dart';
import 'package:no_poverty/Database/job_database/job_database.dart';
import 'package:no_poverty/widgets/custom_Button.dart';
import 'package:no_poverty/widgets/custom_Listtile.dart';
import 'package:no_poverty/widgets/sub_title1.dart';

class ListHelper extends StatefulWidget {
  const ListHelper({super.key});

  @override
  State<ListHelper> createState() => _ListHelperState();
}

class _ListHelperState extends State<ListHelper> {
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
          final data = snapshot.data ?? [];
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final jobs = data[index];

              return Column(
                children: [
                  CustomListile(
                    tileColor: Colors.white,
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        'https://picsum.photos/seed/${jobs.id}/120/120',
                      ),
                    ),
                    title: jobs.username ?? '', // fix nullable
                    subtitle: Row(
                      children: [
                        SubTitle1(title: jobs.title ?? '', size: 14),
                        const SizedBox(width: 10),
                        const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        SubTitle1(title: jobs.location ?? '', size: 14),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${jobs.salary?.toString() ?? '0'}/jam"), // numeric ke string
                        const SizedBox(height: 5),
                        CustomButton(child: const Text("hire"), onPress: () {}),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
