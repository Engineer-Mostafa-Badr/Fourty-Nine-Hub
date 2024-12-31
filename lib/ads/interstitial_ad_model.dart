import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';

class AdInterstitialTop {
  static InterstitialAd? _interstitialAd;
  static bool _isAdReady = false;

  static void loadIntersitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.InterstitialAd,
      request: const AdRequest(),
       adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad){
          _isAdReady = true;
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error){
          print(error.message);
        },
      ),
    );
    print('====================================================================================');
  }

  static void showInterstitialAd(){
    if(_isAdReady){
      _interstitialAd!.show();
    }
    else{
      print('the ad not ready now try later');
    }
  }
}
