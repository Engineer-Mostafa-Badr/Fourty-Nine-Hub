import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:fourtyninehub/core/share/context_utilty.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_links/uni_links.dart';

class UniService {
  static String _code = '';
  static String get code => _code;
  static bool get hasCode => _code.isNotEmpty;
  static void rest() => _code = '';
  static String baseUrl = "https://app-af0a7.web.app";
  static String trip = "$baseUrl/trip";
  static String product = "$baseUrl/ourProductSea";
  static String training = "$baseUrl/training";
  static String waterSport = "$baseUrl/waterSport";
  static String recreationalSea = "$baseUrl/recreationalSea";
  static String recreationalLand = "$baseUrl/recreationalLand";
  static String safariSport = "$baseUrl/safariSport";
  static String camping = "$baseUrl/camping";
  static String eventLand = "$baseUrl/eventLand";
  static String coach = "$baseUrl/coach";
  static String reel = "$baseUrl/reel";
  static String package = "$baseUrl/package";
  static init() async {
    try {
      final Uri? url = await getInitialUri();
      // log(hurl.toString());
      // log(url!.path.toString());
      uniHandler(url);
    } on PlatformException catch (e) {
      log(e.toString());
    } on FormatException catch (e) {
      log(e.toString());
    }
    uriLinkStream.listen(
      (event) {
        log(event.toString());
        uniHandler(event);
      },
      onError: (error) {
        log(error.toString());
      },
    );
  }

  static uniHandler(Uri? uri) {
    if (uri == null || uri.queryParameters.isEmpty) {
      return;
    }
    Map<String, dynamic> param = uri.queryParameters;
    String id = param['id'] ?? "";
    String favorite = param['fav'] ?? "";
    log(uri.queryParameters.toString());
    log(uri.path.toString());

    String finalUrl = uri.replace(queryParameters: {}).toString();
    log(finalUrl.split("?")[0]);
    //Trip

    // if (ContextUtilty.context != null) {
    //   if (finalUrl.split("?")[0] == trip) {
    //     if (id.isEmpty) {
    //       log("Empty");
    //       ContextUtilty.context!.goNamed(AppRouter.homeScreenSea);
    //     } else if (id.isNotEmpty) {
    //       log("id is not empty");
    //       ContextUtilty.context!
    //           .goNamed(AppRouter.tripScreen, extra: int.parse(id));
    //     }
    //   }
    // }
    // //Product
    // if (finalUrl.split("?")[0] == product) {
    //   if (id.isEmpty) {
    //     log("Empty");
    //     ContextUtilty.context!.goNamed(AppRouter.homeScreenSea);
    //   } else if (id.isNotEmpty) {
    //     log("id is not empty");
    //     // GoRouter.of(ContextUtilty.context!)
    //     //     .goNamed(AppRouter.productScreen, extra: int.parse(id));

    //     ContextUtilty.context!
    //         .goNamed(AppRouter.productScreen, extra: int.parse(id));
    //   }
    // }
    // //Training
    // if (finalUrl.split("?")[0] == training) {
    //   if (id.isEmpty) {
    //     log("Empty");
    //     // GoRouter.of(ContextUtilty.navigatorKey.currentState!.context)
    //     //     .pushNamed(AppRouter.homeScreenSea);
    //     ContextUtilty.context!.goNamed(AppRouter.homeScreenSea);
    //   } else if (id.isNotEmpty) {
    //     log("id is not empty");
    //     // GoRouter.of(ContextUtilty.context!)
    //     //     .goNamed(AppRouter.trainingScreen, extra: int.parse(id));
    //     ContextUtilty.context!
    //         .goNamed(AppRouter.trainingScreen, extra: int.parse(id));
    //   }
    // }
    // //WaterSport
    // if (finalUrl.split("?")[0] == waterSport) {
    //   if (id.isEmpty) {
    //     log("Empty");
    //     // GoRouter.of(ContextUtilty.navigatorKey.currentState!.context)
    //     //     .pushNamed(AppRouter.homeScreenSea);
    //     ContextUtilty.context!.goNamed(AppRouter.homeScreenSea);
    //   } else if (id.isNotEmpty) {
    //     log("id is not empty");
    //     // GoRouter.of(ContextUtilty.context!)
    //     //     .goNamed(AppRouter.waterSportsCategories, extra: int.parse(id));
    //     ContextUtilty.context!
    //         .goNamed(AppRouter.waterSportsInfo, extra: int.parse(id));
    //   }
    // }
    // //RecreationalSea
    // if (finalUrl.split("?")[0] == recreationalSea) {
    //   if (id.isEmpty) {
    //     log("Empty");
    //     // GoRouter.of(ContextUtilty.navigatorKey.currentState!.context)
    //     //     .pushNamed(AppRouter.homeScreenSea);
    //     ContextUtilty.context!.goNamed(AppRouter.homeScreenSea);
    //   } else if (id.isNotEmpty) {
    //     log("id is not empty");
    //     // GoRouter.of(ContextUtilty.context!)
    //     //     .goNamed(AppRouter.recreationalScreen, extra: int.parse(id));
    //     ContextUtilty.context!
    //         .goNamed(AppRouter.recreationalScreen, extra: int.parse(id));
    //   }
    // }
    // //RecreationalLand
    // if (finalUrl.split("?")[0] == recreationalLand) {
    //   if (id.isEmpty) {
    //     log("Empty");
    //     // GoRouter.of(ContextUtilty.navigatorKey.currentState!.context)
    //     //     .pushNamed(AppRouter.homeScreenSea);
    //     ContextUtilty.context!.goNamed(AppRouter.homeScreenSea);
    //   } else if (id.isNotEmpty) {
    //     log("id is not empty");
    //     // GoRouter.of(ContextUtilty.context!)
    //     //     .goNamed();
    //     ContextUtilty.context!
    //         .goNamed(AppRouter.recreationalScreenLand, extra: int.parse(id));
    //   }
    // }
    // //SafariSport
    // if (finalUrl.split("?")[0] == safariSport) {
    //   if (id.isEmpty) {
    //     log("Empty");
    //     // GoRouter.of(ContextUtilty.navigatorKey.currentState!.context)
    //     //     .pushNamed(AppRouter.homeScreenSea);
    //     ContextUtilty.context!.goNamed(AppRouter.homeScreenSea);
    //   } else if (id.isNotEmpty) {
    //     log("id is not empty");
    //     // GoRouter.of(ContextUtilty.context!).goNamed();
    //     ContextUtilty.context!
    //         .goNamed(AppRouter.safariSportInfo, extra: int.parse(id));
    //   }
    // }
    // //Camping
    // if (finalUrl.split("?")[0] == camping) {
    //   if (id.isEmpty) {
    //     log("Empty");
    //     // GoRouter.of(ContextUtilty.navigatorKey.currentState!.context)
    //     //     .pushNamed(AppRouter.homeScreenSea);
    //     ContextUtilty.context!.goNamed(AppRouter.homeScreenLand);
    //   } else if (id.isNotEmpty) {
    //     log("id is not empty");
    //     ContextUtilty.context!
    //         .goNamed(AppRouter.campingScreen, extra: int.parse(id));
    //   }
    // }
    // //Coach
    // if (finalUrl.split("?")[0] == coach) {
    //   if (id.isEmpty) {
    //     log("Empty");
    //     // GoRouter.of(ContextUtilty.navigatorKey.currentState!.context)
    //     //     .pushNamed(AppRouter.homeScreenSea);
    //     ContextUtilty.context!.goNamed(AppRouter.homeScreenLand);
    //   } else if (id.isNotEmpty) {
    //     log("id is not empty");
    //     ContextUtilty.context!.goNamed(AppRouter.coacheScreen,
    //         extra: {"id": int.parse(id), "isFavorite": favorite == "0"});
    //   }
    // }
    // //event
    // if (finalUrl.split("?")[0] == eventLand) {
    //   if (id.isEmpty) {
    //     log("Empty");
    //     // GoRouter.of(ContextUtilty.navigatorKey.currentState!.context)
    //     //     .pushNamed(AppRouter.homeScreenSea);
    //     ContextUtilty.context!.goNamed(AppRouter.homeScreenLand);
    //   } else if (id.isNotEmpty) {
    //     log("id is not empty");
    //     log(id);
    //     ContextUtilty.context!
    //         .goNamed(AppRouter.eventInfo, extra: int.parse(id));
    //   }
    // }
    //reel
    // if (finalUrl.split("?")[0] == reel) {
    //   if (id.isEmpty) {
    //     log("Empty");
    //     // GoRouter.of(ContextUtilty.navigatorKey.currentState!.context)
    //     //     .pushNamed(AppRouter.homeScreenSea);
    //     ContextUtilty.context!.goNamed(AppRouter.customBottomNavigationBarSea, extra: id);
    //   } else if (id.isNotEmpty) {
    //     log("id is not empty");
    //     log(id);
    //     ContextUtilty.context!
    //         .goNamed(AppRouter.reelScreen, extra: int.parse(id));
    //   }
    // }
    // //package
    // if (finalUrl.split("?")[0] == reel) {
    //   if (id.isEmpty) {
    //     log("Empty");
    //     // GoRouter.of(ContextUtilty.navigatorKey.currentState!.context)
    //     //     .pushNamed(AppRouter.homeScreenSea);
    //     ContextUtilty.context!.goNamed(AppRouter.customBottomNavigationBarSea, extra: id);
    //   } else if (id.isNotEmpty) {
    //     log("id is not empty");
    //     log(id);
    //     ContextUtilty.context!
    //         .pushNamed(AppRouter.packageScreen,
    //                             extra: id);
    //   }
    // }
  }
}
