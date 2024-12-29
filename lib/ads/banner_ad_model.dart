
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';

class AddBanner extends StatefulWidget {
  const AddBanner({super.key});

  @override
  State<AddBanner> createState() => _AddBannerState();
}

class _AddBannerState extends State<AddBanner> {
  BannerAd? bannerAd;
  bool _isAdReady = false;
  final AdSize _adSize = AdSize.fullBanner;

  void _createBannerAd() {
    bannerAd = BannerAd(
      size: _adSize,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad){
          setState(() {
            _isAdReady = true;
          });
        },
        onAdFailedToLoad: (ad,error){
          // log("ad faild to load${error.message}");
          print("ad faild to load${error.message}");
          ad.dispose();
        }
      ),
      request: const AdRequest(),
    )..load();
    // bannerAd!.load();
  }
  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }
  @override
  void dispose() {
    super.dispose();
    bannerAd!.dispose();
  }
  @override
  Widget build(BuildContext context) {
  if(_isAdReady){
    return Container(
      alignment: Alignment.center,
      width: _adSize.width.toDouble(),
      height: _adSize.height.toDouble(),
      child: AdWidget(ad: bannerAd!),
    );
  }else{
    return const SizedBox(
      width: double.infinity,
      height: 15,
    );
  }
  }
}
