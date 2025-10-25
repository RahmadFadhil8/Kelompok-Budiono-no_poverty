import 'package:flutter/material.dart';
import 'package:no_poverty/Database/job_database/job_database.dart';
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
  UserAPIServices users = UserAPIServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: users.getAll(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index){
              final jobs = data[index];
              return Column(
              children: [
                CustomListile(
                  tileColor: Colors.white,
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://picsum.photos/seed/${jobs.id}/120/120')
                  ),
                  title: jobs.username,
                  subtitle: Row(
                    children: [
                      SubTitle1(title: jobs.pekerjaan, size: 14),
                      SizedBox(width: 10),
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4),
                      SubTitle1(title: jobs.lokasi, size: 14),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${jobs.salary}/jam"),
                      SizedBox(height: 5),
                      CustomButton(child: Text("hire"), onPress: () {}),
                    ],
                  ),
                ),
                SizedBox(height: 16),
              ],
            );
            }
          );
        }
      )
    );
  }
}