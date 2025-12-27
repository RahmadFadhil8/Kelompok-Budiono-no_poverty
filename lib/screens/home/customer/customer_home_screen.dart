import 'package:flutter/material.dart';
import 'package:no_poverty/Analytics/analytics_helper.dart';
import 'package:no_poverty/screens/add_job/add_job.dart';
import 'package:no_poverty/screens/home/customer/account_verification.dart';
import 'package:no_poverty/screens/home/customer/list_Helper.dart';
import 'package:no_poverty/screens/home/customer/list_job_active.dart';
import 'package:no_poverty/screens/home/customer/list_ketegori.dart';
import 'package:no_poverty/widgets/custom_Button.dart';
import 'package:no_poverty/widgets/custom_card.dart';
import 'package:no_poverty/widgets/sub_title1.dart';
import 'package:no_poverty/widgets/title1.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:no_poverty/main.dart'; 

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
      body: SingleChildScrollView(
        child: Padding(
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
                      onPress: () async {
                        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
                            notificationsPlugin.resolvePlatformSpecificImplementation<
                                AndroidFlutterLocalNotificationsPlugin>();

                        final bool? granted = await androidImplementation?.requestNotificationsPermission();

                        if (granted == true || granted == null) {
                          const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
                            'verification_start',
                            'Verifikasi Akun',
                            channelDescription: 'Notifikasi saat memulai proses verifikasi akun',
                            importance: Importance.high,
                            priority: Priority.high,
                            playSound: true,
                            enableVibration: true,
                            icon: '@mipmap/ic_launcher',
                          );

                          const NotificationDetails notificationDetails =
                              NotificationDetails(android: androidDetails);

                          await notificationsPlugin.show(
                            1001,
                            'Yuk Lengkapi Verifikasi Akunmu! 👤',
                            'Siapkan KTP, selfie, dan dokumen lain ya. Prosesnya cepat dan mudah!',
                            notificationDetails,
                          );
                        }

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

              SizedBox(
                height: 170,
                child: ListJobActive(),
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
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: const ListHelper()
              ),
            ],
          ),
        ),
      ),
    );
  }
}