import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Assuming you have a class like this
// Define constants for ad frequency and card intervals
const int adFrequency = 3; // Show ad after every 3rd item (i.e., after 2 cards)
const int nativeAdStart = 0; // Start inserting ads from the beginning
const int nativeAdEnd = 5; // Adjust this if needed, for now it's unused

class AdsManager {
  static final AdsManager _instance = AdsManager._internal();
  factory AdsManager() => _instance;
  AdsManager._internal();

  final String adUnitId =
      "ca-app-pub-3940256099942544/2247696110"; // Test ad ID
  final List<NativeAd> nativeAds = [];
  bool isLoading = false;

  void preloadAds({int numberOfAds = 10}) {
    if (isLoading) return;
    print('Starting to load ads...');
    isLoading = true;
    for (var i = 0; i < numberOfAds; i++) {
      _loadAd();
    }
  }

  void _loadAd() {
    final nativeAd = NativeAd(
      factoryId: "",
      adUnitId: adUnitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          print('Ad loaded');
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
      // nativeTemplateStyle: NativeTemplateStyle(
      //   templateType: TemplateType.medium,
      // ),
    );
    nativeAd.load();
  }

  Widget getAdWidget(int index) {
    // If nativeAds is empty, return a placeholder widget
    if (nativeAds.isEmpty) return const SizedBox();

    // Ensure unique ad index and avoid reusing the same ad
    final ad = nativeAds[index % nativeAds.length];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 300),
        child: AdWidget(ad: ad), // Unique ad widget
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
/*
Widget getAdIfNeeded1(int index, AdsManager adsManager) {
  // Show ad after every 2 cards (i.e., index 2, 5, 8, ...)
  if (index % adFrequency == adFrequency - 1) {  // Every adFrequency-th index (e.g., 2, 5, 8, ...)
    return adsManager.getAdWidget(index ~/ adFrequency);  // Provide unique ad per 3 cards
  }
  return  Text("No Ads now");  // No ad for other indices
}


Widget getAdIfNeededwork(int index, AdsManager adsManager) {
  if (index % adFrequency == adFrequency - 1) {
    return adsManager.getAdWidget(index ~/ adFrequency); // Provide unique ad per frequency
  }
  return Text("No Ads now"); // Placeholder text
}
*/

Widget getAdIfNeeded(int index, AdsManager adsManager) {
  // Check if an ad is already placed in the widget tree
  if (index % adFrequency == adFrequency - 1) {
    // Return ad widget if needed, else show a placeholder Text
    return adsManager.nativeAds.isNotEmpty
        ? adsManager.getAdWidget(index ~/ adFrequency)
        : const SizedBox.shrink();
  }
  return const SizedBox(); // No ad for other indices
}

/*
class AdsManager1 {
  static final AdsManager _instance = AdsManager._internal();
  factory AdsManager() => _instance;
  AdsManager._internal();

  final String adUnitId = "ca-app-pub-3940256099942544/2247696110"; // Test ad ID
  final List<NativeAd> nativeAds = [];
  bool isLoading = false;

  void preloadAds({int numberOfAds = 10}) {
    if (isLoading) return;
    print('Starting to load ads...');
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
          print('Ad loaded');
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

    // Ensure unique ad index
    final ad = nativeAds[index % nativeAds.length];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 300),
        child: AdWidget(ad: ad), // Unique ad widget
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
*/

// Widget getAdIfNeeded(int index, AdsManager adsManager) {
//   if (index > 0 && index % 5 == 0) {
//     // Ensure unique ad instance for every 5th item in the list
//     return adsManager.getAdWidget(index ~/ 5);
//   }
//   return const SizedBox(); // Return an empty widget if no ad is needed
// }

class AdsManagerWidget extends StatefulWidget {
  const AdsManagerWidget({super.key});

  @override
  _AdsManagerWidgetState createState() => _AdsManagerWidgetState();
}

class _AdsManagerWidgetState extends State<AdsManagerWidget> {
  final String adUnitId =
      "ca-app-pub-3940256099942544/2247696110"; // Test ad ID
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
      factoryId: "",
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
      // nativeTemplateStyle: NativeTemplateStyle(
      //   templateType: TemplateType.medium,
      // ),
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
    print("Hi");
    return ListView.builder(
      itemCount: 1, // For example, show 20 items
      itemBuilder: (context, index) {
        return getAdWidget(index);
      },
    );
  }
}
