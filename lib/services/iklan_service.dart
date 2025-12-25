import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class admobService {
  static const String InterstitialAdId = "ca-app-pub-3940256099942544/1033173712";

  InterstitialAd? _interstitialAd;

  void loadInterstitialAd(){
    InterstitialAd.load(
      adUnitId: InterstitialAdId, 
      request: const AdRequest(), 
      adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad){
        _interstitialAd = ad;
      }, onAdFailedToLoad: (er) {
        _interstitialAd = null;
      }));
  }
  void showInterstitialAd(){
    if (_interstitialAd == null)
    return;

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent:(ad) {
        ad.dispose();
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint("error: $error");
        ad.dispose();
        loadInterstitialAd();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }

}