// import 'package:flutter/material.dart';
// import 'package:fourtyninehub/res/style/const.dart';

// import '../../../res/style/app_colors.dart';
// import 'package:admob_flutter/admob_flutter.dart';

// class GoogleAddsBanner extends StatelessWidget {
//   final double margin;
//   const GoogleAddsBanner({super.key, this.margin = 5});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: kToolbarHeight,
//       width: double.infinity,
//       margin:  EdgeInsets.symmetric(horizontal: margin),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(5),
//           boxShadow: const [
//             BoxShadow(
//               color: AppColors.GRAY_LIGHT_COLOR3,
//               blurRadius: 5,
//               spreadRadius: 5,
//             )
//           ]),
//       child: AdmobBanner(
//               adUnitId: UIConst.adHomeUnitId,
//               adSize: AdmobBannerSize.BANNER,
//               listener: (AdmobAdEvent event, Map<String, dynamic>? args) {},
//             )
//     );
//   }
// }
