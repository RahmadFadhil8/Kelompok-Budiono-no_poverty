import 'package:flutter/material.dart';
import 'package:no_poverty/widgets/custom_Button.dart';
import 'package:no_poverty/widgets/custom_Listtile.dart';
import 'package:no_poverty/widgets/custom_card.dart';
import 'package:no_poverty/widgets/sub_title1.dart';
import 'package:no_poverty/widgets/title1.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage("https://picsum.photos/id/237/200/300")
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubTitle1(title: "Selamat Datang"),
                Title1(title: "Wonhee"),
              ],
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
                    onPress: () {},
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
            Row(
              children: [
                CustomButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 4,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 2),
                        Icon(Icons.home),
                        Title1(title: "Claening", color: Colors.white),
                      ],
                    ),
                  ),
                  onPress: () {},
                ),
                SizedBox(width: 10),

                // tambahan
                CustomButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 4,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 2),
                        Icon(Icons.home),
                        Title1(title: "Claening", color: Colors.white),
                      ],
                    ),
                  ),
                  onPress: () {},
                ),
              ],
            ),

            // judul Job Aktif
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Job Akif"),
                TextButton(onPressed: () {}, child: Text("Lainnya >")),
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
                            child: const Text("Detail"),
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
            Column(
              children: [
                CustomListile(
                  tileColor: Colors.white,
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage("https://picsum.photos/id/237/200/300")
                  ),
                  title: "Budi",
                  subtitle: Row(
                    children: [
                      SubTitle1(title: "Cleaning", size: 14),
                      SizedBox(width: 10),
                      Icon(Icons.star, size: 14, color: Colors.yellow),
                      SizedBox(width: 4),
                      SubTitle1(title: "4.9", size: 14),
                      SizedBox(width: 10),
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 4),
                      SubTitle1(title: "2.5 Km", size: 14),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Rp 50.000/jam"),
                      SizedBox(height: 5),
                      CustomButton(child: Text("hire"), onPress: () {}),
                    ],
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
