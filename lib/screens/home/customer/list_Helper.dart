import 'package:flutter/material.dart';
import 'datailHelper.dart';
import 'package:no_poverty/services/user_api_services.dart';
import 'package:no_poverty/widgets/custom_Button.dart';
import 'package:no_poverty/widgets/custom_Listtile.dart';
import 'package:no_poverty/widgets/sub_title1.dart';

class ListHelper extends StatefulWidget {
  const ListHelper({super.key});

  @override
  State<ListHelper> createState() => _ListHelperState();
}

class _ListHelperState extends State<ListHelper> {
  final UserApiService users = UserApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: users.getAll(),
        builder: (context, snapshot) {
          // === LOADING STATE ===
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // === ERROR STATE ===
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // === EMPTY STATE ===
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada data helper tersedia."));
          }

          final data = snapshot.data!;

          // === SUCCESS STATE ===
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final helper = data[index];

              return Column(
                children: [
                  CustomListile(
                    tileColor: Colors.white,
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        'https://picsum.photos/seed/${helper.id}/120/120',
                      ),
                    ),
                    title: helper.username,
                    subtitle: Row(
                      children: [
                        SubTitle1(title: helper.pekerjaan, size: 14),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        SubTitle1(title: helper.lokasi, size: 14),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("${helper.salary}/jam"),
                        const SizedBox(height: 5),
                        CustomButton(
                          child: const Text("Detail"),
                          onPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailHelper(userId: helper.id),
                              ),
                            );
                          },
                        ),
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
