// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// import 'package:fourtyninehub/res/style/styles.dart';
// import 'package:fourtyninehub/routes/routes.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../../../../res/style/app_colors.dart';
// import '../../../../../res/style/const.dart';
//
// class TinderPersonCard extends StatelessWidget {
//   const TinderPersonCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: Stack(
//           children: [
//             const Positioned.fill(
//                 child: SquareImage(
//                     radius: 10,
//                     source: NetworkImage(UIConst.profilePlaceHolder))),
//             Positioned.fill(
//                 child: Container(
//               decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                     Colors.transparent,
//                     Colors.black.withOpacity(.2),
//                   ])),
//             )),
//             Positioned.fill(
//                 bottom: 10,
//                 left: 10,
//                 right: 10,
//                 child: _buildPersonInfo(context: context)),
//           ],
//         ));
//   }
//
//   Widget _buildPersonInfo({required BuildContext context}) {
//     return InkWell(
//       onTap: () => context.push(Routes.OTHERSACCOUNT),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: [
//           Expanded(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const BadgedLabel(
//                   color: AppColors.SECONDARY_COLOR,
//                   label: 'Nearby',
//                 ),
//                 Label(
//                   text: 'Mohamed Gammal',
//                   style: Styles.headerText(color: Colors.white),
//                 ),
//                 Row(
//                   children: [
//                     const Icon(
//                       Icons.location_on,
//                       color: Colors.white,
//                     ),
//                     Sizer(),
//                     Label(
//                       text: '2 miles away',
//                       style: Styles.mediumText(color: Colors.white),
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//           const Icon(
//             Icons.arrow_upward_rounded,
//             color: Colors.white,
//           ),
//         ],
//       ),
//     );
//   }
// }
