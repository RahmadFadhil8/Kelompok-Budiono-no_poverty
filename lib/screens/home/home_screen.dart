import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:no_poverty/Database/database_Service.dart';
import 'package:no_poverty/screens/add_job/add_job.dart';
import 'package:no_poverty/screens/home/list_Helper.dart';
import 'package:no_poverty/screens/home/list_ketegori.dart';
import 'package:no_poverty/widgets/custom_Button.dart';
import 'package:no_poverty/widgets/custom_Listtile.dart';
import 'package:no_poverty/widgets/custom_card.dart';
import 'package:no_poverty/widgets/sub_title1.dart';
import 'package:no_poverty/widgets/title1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isWorkMode = false;
  String? username;
  
  @override
  void initState() {
    super.initState();
    loadusername();
  }
  // fungsi untuk mengambil nama sesuai id yang login
  Future<void> loadusername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId");

    if(userId != null) {
      final dbpath = await getDatabasesPath();
      final path = join(dbpath, DatabaseService.DB_NAME);
      final db = await openDatabase(path);

      final List<Map<String, dynamic>> result = await db.query(
        "users",
        where: "id = ?",
        whereArgs: [userId],
      );
      if (result.isNotEmpty) {
        setState(() {
          username = result.first['username'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print("isWorkMode");
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AnimatedToggleSwitch<bool>.dual(
              current: isWorkMode,
              first: false,
              second: true,
              spacing: 50,
              style: const ToggleStyle(
                borderColor: Color.fromARGB(31, 155, 155, 155),
              ),
              borderWidth: 5.0,
              height: 55,
              onChanged: (value) => setState(() => isWorkMode = value),
              styleBuilder:
                  (value) => ToggleStyle(
                    indicatorColor: value ? Colors.green : Colors.blue,
                  ),
              iconBuilder:
                  (value) =>
                      value
                          ? const Icon(Icons.engineering, color: Colors.white,size: 32)
                          : const Icon(Icons.business_center, color: Colors.white, size: 32,),
              textBuilder:
                  (value) =>
                      value
                          ? const Center(child: Text('Work'))
                          : const Center(child: Text('Hire')),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none, color: Colors.black),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings, color: Colors.black),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),

        // bagian tombol job dan cari helper
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 4,
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.add),
                          Title1(title: "Buat Job", color: Colors.white),
                        ],
                      ),
                    ),
                    onPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => addJob()));
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: CustomButton(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 4,
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.search),
                          Title1(title: "Cari Helper", color: Colors.white),
                        ],
                      ),
                    ),
                    onPress: () {},
                  ),
                ),
              ],
            ),

            // cari kategoti
            SizedBox(height: 10),
            Row(children: [Text("Kategori Populer")]),
            SizedBox(height: 10),
            KategotiList(),
            

            // judul Job Aktif
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Job Akif"),
                TextButton(onPressed: () {}, child: Text("Lainnya >", style: TextStyle(color: Colors.black),)),
              ],
            ),

            // CardJob
            SizedBox(height: 16),
            Column(
              children: [
                //custom card
                CustomCard(
                  padding: 16,
                  onTapCard: () {},
                  childContainer: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Title1(title: "Pembersihan Rumah", size: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SubTitle1(
                              title: "Active",
                              size: 12,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          SubTitle1(
                            title: "Surabaya",
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
                            title: "2024-01-15",
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
                                title: "RP 150.000",
                                size: 14,
                                color: Colors.black,
                              ),
                              SizedBox(width: 16),
                              Icon(Icons.people, size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              SubTitle1(title: "8 Pelamar", size: 13),
                            ],
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            onPressed: () {},
                            child: const Text("Detail", style: TextStyle(color: Colors.black),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // judul helper
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Helper Terdekat"),
                TextButton(onPressed: () {}, child: Text("Lainnya >")),
              ],
            ),

            // Helper
            SizedBox(height: 12),
            Expanded(child: const ListHelper())
          ],
        ),
      ),
    );
  }
}
