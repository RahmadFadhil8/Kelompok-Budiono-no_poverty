import 'package:flutter/material.dart';
import 'package:no_poverty/Analytics/analytics_helper.dart';
import 'package:no_poverty/widgets/custom_Button.dart';
import 'package:no_poverty/widgets/title1.dart';

class KategotiList extends StatefulWidget {
  const KategotiList({super.key});

  @override
  State<KategotiList> createState() => _KategotiListState();
}

class _KategotiListState extends State<KategotiList> {
  MyAnalytics analytics = MyAnalytics();

  List<Map<String, dynamic>> daftarKetegori = [
    {"nama": "Cleaning", "icon": Icons.cleaning_services},
    {"nama": "Home Assistance", "icon": Icons.home_repair_service},
    {"nama": "Gardening", "icon": Icons.local_florist},
    {"nama": "Repair & Maintenance", "icon": Icons.build},
    {"nama": "Construction", "icon": Icons.construction},
    {"nama": "Delivery", "icon": Icons.delivery_dining},
  ];

  Future<List<Map<String, dynamic>>> getData(){
    return Future.delayed(Duration(seconds:1), () {
      return daftarKetegori;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getData(), 
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Tidak ada Kategori"),);
          }
          final data = snapshot.data!;
          return 
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                separatorBuilder: (context, index) {return const SizedBox(width: 8,);},
                itemBuilder: (context, index) {
                  final kategori = data[index];
                  return CustomButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 12,
                      ),
                      child: Column(
                        children: [
                          Icon(kategori['icon'], size: 24, color: Colors.white,),
                          SizedBox(height: 2),
                          Title1(title: kategori['nama'], color: Colors.white),
                        ],
                      ),
                    ),
                    onPress: () {
                      analytics.clikcbutton("kategori_${kategori['nama']}");
                    },
                  );
                },
              ),
            );
        }
      );
  }
}