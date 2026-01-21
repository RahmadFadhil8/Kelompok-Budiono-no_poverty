import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:no_poverty/Permission/handler.dart';
import 'package:no_poverty/models/job_model_fix_firestore.dart';
import 'package:no_poverty/screens/home/customer/detailJob.dart';
import 'package:no_poverty/services/job_services_firestore.dart';
import 'package:no_poverty/widgets/custom_card.dart';
import 'package:no_poverty/widgets/sub_title1.dart';
import 'package:no_poverty/widgets/title1.dart';

class ListJobActive extends StatefulWidget {
  const ListJobActive({super.key});

  @override
  State<ListJobActive> createState() => _ListJobActiveState();
}

class _ListJobActiveState extends State<ListJobActive> {
  JobService jobs = JobService();

  // <============Iklan Interstitial============>

  InterstitialAd? _interstitialAd;
  String Interstitialid = "ca-app-pub-3940256099942544/1033173712";

  @override
  void initState() {
    _loadInterstitialAd();
    super.initState();
  }


  void _loadInterstitialAd() {
    InterstitialAd.load( 
      adUnitId: Interstitialid, 
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _loadInterstitialAd();
              
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _loadInterstitialAd();
            },
          );
        }, 
        onAdFailedToLoad: (error) {
          print("Filed to load ad:${error.message}");
        }),
      request: AdRequest(),
    );
  }
  // <================================================>
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:StreamBuilder<List<JobModelFix>>(
        stream: jobs.getallJob(), 
        builder: (context, snapshot) {
          // === LOADING STATE ===
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // === ERROR STATE ===
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // === EMPTY STATE ===
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("job Belum tersedia."));
          }

          final data = snapshot.data!;

          return SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              padding: const EdgeInsets.only(left: 16),
              itemBuilder: (context, index) {
                final job = data[index];
                return Container(
                  width: MediaQuery.of(context).size.width * 0.88,
                  margin: const EdgeInsets.only(right: 16),
                  child: CustomCard(
                    padding: 16,
                    onTapCard: () {},
                    childContainer: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Title1(title: job.title ?? "-", size: 16),
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
                                title: job.status ?? "-",
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
                              title: job.city ?? "-",
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
                              title: DateFormat('dd/MM/yyyy').format(
                                (job.date_time as Timestamp).toDate()
                              ),
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
                                  title: "Rp ${job.wage.toStringAsFixed(0)}",
                                  size: 14,
                                  color: Colors.black,
                                ),
                                SizedBox(width: 16),
                                Icon(Icons.people, size: 16, color: Colors.grey),
                                SizedBox(width: 4),
                                SubTitle1(title: job.max_applicants.toString(), size: 13),
                              ],
                            ),
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                side: const BorderSide(color: Colors.grey),
                              ),
                              onPressed: () {
                                _interstitialAd?.show();
                                Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => DetailJob(JobId: job.job_id,)),
                              );
                              },
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
                ); 
              }
            ),
          );
        }
      )  
    );
  }
}