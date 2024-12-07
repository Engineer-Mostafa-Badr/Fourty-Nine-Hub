import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Assuming you have a class like this
int nativeAdStart = 0;
int nativeAdEnd = 5;
Widget getAdIfNeeded(int index, AdsManager adsManager) {
  if (index > 0 && index % 5 == 0) {
    // Ensure unique ad instance for every 5th item in the list
    return adsManager.getAdWidget(index ~/ 5);
  }
  return const SizedBox(); // Return an empty widget if no ad is needed
}

class AdsManagerWidget extends StatefulWidget {
  const AdsManagerWidget({Key? key}) : super(key: key);

  @override
  _AdsManagerWidgetState createState() => _AdsManagerWidgetState();
}

class _AdsManagerWidgetState extends State<AdsManagerWidget> {
  final String adUnitId = "ca-app-pub-3940256099942544/2247696110"; // Test ad ID
  final List<NativeAd> nativeAds = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    preloadAds(); // Preload ads when widget is initialized
  }

  void preloadAds({int numberOfAds = 10}) {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    for (var i = 0; i < numberOfAds; i++) {
      _loadAd();
    }
  }

  void _loadAd() {
    final nativeAd = NativeAd(
      adUnitId: adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            nativeAds.add(ad as NativeAd);
            isLoading = false; // Stop loading once the ad is loaded
          });
        },
        onAdFailedToLoad: (ad, error) {
          print('Ad failed to load: $error');
          ad.dispose();
          setState(() {
            isLoading = false; // Stop loading if the ad fails
          });
        },
      ),
      request: const AdRequest(),
      nativeAdOptions: NativeAdOptions(
        mediaAspectRatio: MediaAspectRatio.any,
        videoOptions: VideoOptions(startMuted: true),
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
      ),
    );
    nativeAd.load();
  }

  Widget getAdWidget(int index) {
    if (nativeAds.isEmpty) return const SizedBox();

    final ad = nativeAds[index % nativeAds.length]; // Ensure unique ad index
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 300,
        ),
        child: AdWidget(ad: ad), // Ensure the AdWidget is unique
      ),
    );
  }

  @override
  void dispose() {
    for (var ad in nativeAds) {
      ad.dispose();
    }
    nativeAds.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 1, // For example, show 20 items
      itemBuilder: (context, index) {
        return getAdWidget(index);
      },
    );
  }
}

class AdsManager {
  static final AdsManager _instance = AdsManager._internal();
  factory AdsManager() => _instance;
  AdsManager._internal();

  final String adUnitId = "ca-app-pub-3940256099942544/2247696110"; // Test ad ID
  final List<NativeAd> nativeAds = [];
  bool isLoading = false;

  void preloadAds({int numberOfAds = 10}) {
    if (isLoading) return;

    isLoading = true;

    for (var i = 0; i < numberOfAds; i++) {
      _loadAd();
    }
  }

  void _loadAd() {
    final nativeAd = NativeAd(
      adUnitId: adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          nativeAds.add(ad as NativeAd);
          isLoading = false;
        },
        onAdFailedToLoad: (ad, error) {
          print('Ad failed to load: $error');
          ad.dispose();
          isLoading = false;
        },
      ),
      request: const AdRequest(),
      nativeAdOptions: NativeAdOptions(
        mediaAspectRatio: MediaAspectRatio.any,
        videoOptions: VideoOptions(startMuted: true),
      ),
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
      ),
    );
    nativeAd.load();
  }

  Widget getAdWidget(int index) {
    if (nativeAds.isEmpty) return const SizedBox();

    final ad = nativeAds[index % nativeAds.length]; // Ensure unique ad index
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 300,
        ),
        child: AdWidget(ad: ad), // Ensure the AdWidget is unique
      ),
    );
  }

  void dispose() {
    for (var ad in nativeAds) {
      ad.dispose();
    }
    nativeAds.clear();
  }
}
