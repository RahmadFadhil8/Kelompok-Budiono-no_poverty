import 'package:flutter/material.dart';
import 'package:no_poverty/Analytics/analytics_helper.dart';
import 'package:no_poverty/widgets/custom_card.dart';

class WorkHomeScreen extends StatefulWidget {
  const WorkHomeScreen({super.key});

  @override
  State<WorkHomeScreen> createState() => _WorkHomeScreenState();
}

class _WorkHomeScreenState extends State<WorkHomeScreen> {
  MyAnalytics analytics = MyAnalytics();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cardWidth = (size.width - 36) / 2;

    return Scaffold(
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 4, 202, 103),
                    Color.fromARGB(255, 0, 190, 76),
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
                children: const [
                  Row(
                    children: [
                      Icon(Icons.attach_money, color: Colors.white, size: 28),
                      SizedBox(width: 8),
                      Text(
                        "Total Earnings",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
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
                    "Bulan ini",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomCard(
                  widthContainer: cardWidth,
                  childContainer: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 26),
                          SizedBox(width: 6),
                          Text(
                            "Rating",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "4.0",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "Rata-rata",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                CustomCard(
                  widthContainer: cardWidth,
                  childContainer: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 26),
                          SizedBox(width: 6),
                          Text(
                            "Completed",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        "20",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        "Total jobs",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomCard(
                  widthContainer: cardWidth,
                  cardColor: const Color(0xFF007BFF),
                  onTapCard: () {},
                  childContainer: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.work, color: Colors.white, size: 36),
                      SizedBox(height: 8),
                      Text(
                        "Cari Job",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomCard(
                  widthContainer: cardWidth,
                  onTapCard: () {},
                  childContainer: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.person, color: Color(0xFF00B686), size: 36),
                      SizedBox(height: 8),
                      Text(
                        "Profil Saya",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
