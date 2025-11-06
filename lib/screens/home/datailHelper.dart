import 'package:flutter/material.dart';
import 'package:no_poverty/services/user_api_services.dart';
import 'package:no_poverty/widgets/custom_card.dart';
import 'package:no_poverty/widgets/title1.dart';

class DetailHelper extends StatefulWidget {
  final String Userid;

  const DetailHelper({super.key, required this.Userid});

  @override
  State<DetailHelper> createState() => _DetailHelperState();
}

class _DetailHelperState extends State<DetailHelper> {
  UserAPIServices users = UserAPIServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Helper")),
      body: FutureBuilder(
        future: users.getByid(widget.Userid), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(12),
            child: CustomCard(
              padding: 16,
              childContainer: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Title1(title: "Nama: ${data.nama}"),
                    SizedBox(height: 8,),
                    Text("Nomor Hp: ${data.nomorHp}"),
                    Text("Pekerjaan: ${data.pekerjaan}"),
                    Text("Lokasi: ${data.lokasi}"),
                    Text("Salary: ${data.salary}/jam")
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}



