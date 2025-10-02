import 'package:flutter/material.dart';
import 'package:no_poverty/widgets/custom_Button.dart';
import 'package:no_poverty/widgets/custom_card.dart';
import 'package:no_poverty/widgets/job_card.dart';
import 'package:no_poverty/widgets/sub_title1.dart';
import 'package:no_poverty/widgets/title1.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage("data:image/jpeg;base64,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"),
            ),
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubTitle1(title: "Selamat Datang"),
                Title1(title: "Wonhee")
              ],
            )
          ],
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none, color: Colors.black)),
          IconButton(onPressed: () {}, icon: Icon(Icons.settings, color: Colors.black))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    child: Column(
                      children: [
                        Icon(Icons.add),
                        Title1(title: "Buat Job"),
                      ],
                    ), onPress: (){}
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: CustomButton(
                    child: Column(
                      children: [
                        Icon(Icons.search),
                        Title1(title: "Cari Helper"),
                      ],
                    ), onPress: (){}
                  ),
                )
              ],
            ),
            SizedBox(height: 10,),
            Row(
              children: [
                Text("Kategori Populer")
              ],
            ),
            Row(
              children: [
                CustomButton(
                  child: Column(
                    children: [
                      Icon(Icons.home),
                      Title1(title: "Claening"),
                    ],
                  ), 
                  onPress: () {}
                )
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Job Akif"),
                CustomButton(child: Text("Lainnya"), onPress: (){}),
              ],
            ),
            SizedBox(height: 16,),
            Column(
              children: [
                CustomCard(
                  padding: 16,
                  onTapCard: () {
                    
                  },
                  childContainer: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Title1(title: "Pembersihan Rumah", size: 16,),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.green),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: SubTitle1(title: "Active", size: 12,color: Colors.green,),
                          )
                        ],
                      ),
                      SizedBox(height: 8,),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          SubTitle1(title: "Surabaya", size: 13,color: Colors.grey,),
                          SizedBox(width: 16),
                          Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                          SizedBox(width: 4),
                          SubTitle1(title: "2024-01-15", size: 13, color: Colors.grey,)
                        ],
                      ),

                      SizedBox(height: 16,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Title1(title: "RP 150.000", size: 14, color: Colors.black,),
                              SizedBox(width: 16),
                              Icon(Icons.people, size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              SubTitle1(title: "8 Pelamar", size: 13,)
                            ],
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            onPressed: () {},
                            child: const Text("Detail"),
                          )
                        ],
                      )
                    ],
                  )
                ),
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Helper Terdekat"),
                CustomButton(child: Text("Lainnya"), onPress: (){})
              ],
            ),
            Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage("data:image/jpeg;base64,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"),
                  ),
                  title: Text("Budi"),
                  subtitle: Text("Cleaning"),
                  trailing: Column(
                    children: [
                      Text("Rp 50.000/jam"),
                      CustomButton(child: Text("hire"), onPress:() {}),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const[BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: "Jobs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),]
      ),
    );
  }
}