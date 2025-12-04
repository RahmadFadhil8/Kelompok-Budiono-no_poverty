import 'package:flutter/material.dart';
import 'package:no_poverty/Analytics/analytics_helper.dart';
import 'package:no_poverty/Database/database_Service.dart';
import 'package:no_poverty/screens/add_job/add_job.dart';
import 'package:no_poverty/screens/home/customer/account_verification.dart';
import 'package:no_poverty/screens/home/customer/list_Helper.dart';
import 'package:no_poverty/screens/home/customer/list_ketegori.dart';
import 'package:no_poverty/widgets/custom_Button.dart';
import 'package:no_poverty/widgets/custom_card.dart';
import 'package:no_poverty/widgets/sub_title1.dart';
import 'package:no_poverty/widgets/title1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  bool isWorkMode = false;

  MyAnalytics analytics = MyAnalytics();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            CustomCard(
              isShadow: false,
              borderColor: Colors.deepOrange,
              cardColor: Colors.orangeAccent,
              childContainer: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Verifikasi Akun",
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 4),
                      const Text("Lengkapi verifikasi untuk akses penuh"),
                    ],
                  ),
                  CustomButton(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    child: Text("Mulai"),
                    onPress: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AccountVerificationScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 44, 93, 255),
                    Color.fromARGB(255, 30, 83, 255),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.wallet, color: Colors.white, size: 28),
                          SizedBox(width: 8),
                          Text(
                            "Balance",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      CustomButton(
                        backgroundColor: Colors.transparent,
                        child: Text("Top Up"),
                        onPress: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Rp 5.500.000",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Available Balance",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            ),

            const SizedBox(height: 20),

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
                    onPress: () async {
                      await analytics.clikcbutton("buat job");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => addJob()),
                      );
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
                    onPress: () async {
                      await analytics.clikcbutton("cari helper");
                    },
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
                TextButton(
                  onPressed: () async {
                    await analytics.clikcbutton("job aktif lainnya");
                  },
                  child: Text(
                    "Lainnya >",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
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
            Expanded(child: const ListHelper()),
          ],
        ),
      ),
    );
  }
}