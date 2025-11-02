import 'package:flutter/material.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';


void pleaseLoginDialog(BuildContext context) {
  context.push(Routes.FirstLoginScreen);
  // showAnimatedDialog(
  //   context,
  //   Container(
  //     decoration: BoxDecoration(
  //         color: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.white,
  //         borderRadius: BorderRadius.circular(20)),
  //     padding: const EdgeInsets.all(16),
  //     margin: const EdgeInsets.all(32),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Image.asset(
  //           Assets.login,
  //           width: 100,
  //           height: 100,
  //           color: context.isDarkMode ? Colors.white : Colors.black,
  //         ),
  //         const Sizer(
  //           height: 32,
  //         ),
  //         Row(
  //           children: [
  //             Expanded(
  //               child: AppButton(
  //                   label: LocaleKeys.login.localize,
  //                   style: Styles.mediumText(
  //                       color: context.isDarkMode
  //                           ? AppColors.PRIMARY_COLOR
  //                           : Colors.white),
  //                   backColor: context.isDarkMode
  //                       ? Colors.white
  //                       : AppColors.PRIMARY_COLOR,
  //                   onPressed: () {
  //                     ManageVibration.vibrate();
  //                     context.go(Routes.LOGIN);
  //                   }),
  //             ),
  //             const Sizer(),
  //             Expanded(
  //               child: AppButton(
  //                   label: LocaleKeys.close.localize,
  //                   onPressed: () {
  //                     ManageVibration.vibrate();
  //                     Navigator.pop(context);
  //                   }),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   ),
  // );
}
