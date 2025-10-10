import 'package:flutter/material.dart';
import 'package:no_poverty/widgets/custom_Button.dart';
import 'package:no_poverty/widgets/custom_card.dart';
import 'package:no_poverty/widgets/sub_title1.dart';
import 'package:no_poverty/widgets/title1.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final List<Widget> screen = [
    Text("Card 1"),
    Text("Card 2"),
    Text("Card 3"),
  ];

  int idx = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCard(
              isShadow: false,
              cardColor: Colors.blue,
              childContainer: const Text(
                "BKL",
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Title1(title: "BKL Worker", size: 24),
            const SizedBox(height: 10),
            const SubTitle1(
              title: "Platform Menemukan Pekerja yang Anda Butuhkan",
            ),

            const SizedBox(height: 20),

            CustomCard(
              widthContainer: 350,
              childContainer: Center(heightFactor: 15, child: screen[idx]),
            ),

            const SizedBox(height: 20),
            SizedBox(
              width: 350,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    backgroundColor: idx!=0?Colors.blue:Colors.grey,
                    foregroundColor: idx!=0?Colors.white:Colors.grey,
                    onPress:
                        idx == 0
                            ? null
                            : () {
                              setState(() {
                                idx--;
                              });
                            },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.chevron_left),
                        const Text("Kembali"),
                      ],
                    ),
                  ),
                  CustomButton(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(idx+1 == screen.length ? "Mulai" : "Lanjut"),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onPress: () {
                      setState(() {
                        if (idx >= screen.length) {
                          return;
                        }

                        idx++;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
