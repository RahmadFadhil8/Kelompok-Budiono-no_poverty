import 'package:flutter/material.dart';
import 'package:no_poverty/screens/auth/login.dart';
import 'package:no_poverty/widgets/custom_Button.dart';
import 'package:no_poverty/widgets/custom_card.dart';
import 'package:no_poverty/widgets/sub_title1.dart';
import 'package:no_poverty/widgets/title1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final List<List<dynamic>> _content = [
    [
      Icon(Icons.cases_outlined, size: 40, color: Colors.blue),
      "Post Pekerjaan dengan Mudah",
      "Buat pekerjaan dalam hitungan menit. Tentukan kategori, lokasi, waktu, dan budget sesuai kebutuhan Anda.",
    ],
    [
      Icon(Icons.person_outlined, size: 40, color: Colors.green),
      "Temukan Pekerja Terpercaya",
      "Pilih dari ribuan helper terverifikasi di sekitar Anda. Lihat rating, portofolio, dan rekam jejak mereka.",
    ],
    [
      Icon(Icons.shield_outlined, size: 40, color: Colors.purple),
      "Keamanan Terjamin",
      "Semua pekerja telah melalui verifikasi KTP, SKCK, dan background check untuk keamanan maksimal.",
    ],
  ];
  int idx = 0;
  Future<void> _startButton() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setBool("isSeeWelcome", true);
      await prefs.reload();
      print("Sampai sini aman");
      if (!mounted) return;
      print("Sampai sini aman juga");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Gagal process shared prefernces");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                  const SizedBox(height: 30),

                  CustomCard(
                    padding: 26,
                    widthContainer: 350,
                    childContainer: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: AlignmentGeometry.center,
                          children: [
                            CircleAvatar(
                              radius: 34,
                              backgroundColor: const Color.fromARGB(
                                255,
                                236,
                                236,
                                236,
                              ),
                            ),
                            _content[idx][0],
                          ],
                        ),
                        const SizedBox(height: 20),
                        Title1(
                          title: _content[idx][1],
                          fontWeight: FontWeight.normal,
                        ),
                        const SizedBox(height: 20),
                        SubTitle1(
                          title: _content[idx][2],
                          textAlign: TextAlign.center,
                          size: 16,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: 100,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 8,
                        inactiveTrackColor: Colors.grey.shade300,
                        activeTrackColor: Colors.blueAccent,
                        thumbColor: Colors.blue,
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 8,
                        ),
                        overlayShape: SliderComponentShape.noOverlay,
                      ),
                      child: AbsorbPointer(
                        child: Slider(
                          value: idx.toDouble(),
                          min: 0,
                          max: 2,
                          onChanged: (_) {},
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: 350,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButton(
                          backgroundColor: idx != 0 ? Colors.blue : Colors.grey,
                          foregroundColor:
                              idx != 0 ? Colors.white : Colors.grey,
                          onPress:
                              idx == 0
                                  ? null
                                  : () {
                                    setState(() {
                                      idx--;
                                    });
                                  },
                          child: Row(
                            children: const [
                              Icon(Icons.chevron_left),
                              SizedBox(width: 4),
                              Text("Kembali"),
                            ],
                          ),
                        ),
                        CustomButton(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          onPress: () {
                            setState(() {
                              if (idx < _content.length - 1) {
                                idx++;
                              } else {
                                _startButton();
                              }
                            });
                          },
                          child: Row(
                            children: [
                              Text(
                                idx + 1 == _content.length ? "Mulai" : "Lanjut",
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.chevron_right),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
