import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../common/widgets/stateless/buttons/app_button.dart';
import '../../common/widgets/stateless/buttons/default_button.dart';
import '../../common/widgets/stateless/buttons/elevated_button.dart';
import '../../features/RideFeature/presentation/pages/widgets/dialog_widget/show_custom_dialog_trip.dart';
import '../../features/RideFeature/presentation/pages/widgets/font_manager.dart';
import '../../features/subscripe/presentation/controllers/subscription_controller.dart';
import '../../helpers/subscription_method.dart';
import '../../service_locator/service_locator.dart';
import '../enums/wallet_types_enums.dart';
import '../utils/custom_show_dialog.dart';

showErrorMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.error,
            color: Colors.red,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      padding: EdgeInsets.symmetric(
        vertical: 20.h,
        horizontal: 20,
      ),
      margin: const EdgeInsets.only(
        bottom: 25,
        right: 20,
        left: 20,
      ),
    ),
  );
}

showSuccessMessage(
  BuildContext context,
  String message, {
  Color color = Colors.green,
  IconData icon = Icons.check_circle,
}) {
  WidgetsBinding.instance.addPostFrameCallback(
    (_) => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppColors.QUANTITY_COLOR,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              icon,
              color: color,
            ),
          ],
        ),
        backgroundColor: Colors.white,
        behavior: SnackBarBehavior.floating,
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
          horizontal: 20,
        ),
        margin: const EdgeInsets.only(
          bottom: 25,
          right: 20,
          left: 20,
        ),
      ),
    ),
  );
}

void showSuccessDialog(BuildContext context, String text) => showAnimatedDialog(
      context,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        content: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
          ),
          textAlign: TextAlign.center,
        ),
        contentPadding: const EdgeInsets.only(
          right: 20,
          left: 20,
          top: 20,
          bottom: 40,
        ),
      ),
    );
//     showDialog(
//       context: context,
//       builder: (_) =>
// AlertDialog(
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(5),
//         ),
//         content: Text(
//           text,
//           style: TextStyle(
//             fontSize: 16.sp,
//           ),
//           textAlign: TextAlign.center,
//         ),
//         contentPadding: const EdgeInsets.only(
//           right: 20,
//           left: 20,
//           top: 20,
//           bottom: 40,
//         ),
//       ),
//     );

Future<void> showPermissionDialog({required String message}) async =>
    showAnimatedDialog(
      AppPages.router.configuration.navigatorKey.currentContext!,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontSize: 16.sp,
          ),
          textAlign: TextAlign.center,
        ),
        contentPadding: const EdgeInsets.only(
          right: 20,
          left: 20,
          top: 20,
          bottom: 40,
        ),
        actions: [
          TextAppButton(
            label: LocaleKeys.openAppSettings.tr(),
            onPressed: () async {
              await openAppSettings();
              AppPages.router.configuration.navigatorKey.currentContext!.pop();
            },
          ),
        ],
      ),
    );
// await showDialog(
//   context: AppPages.router.configuration.navigatorKey.currentContext!,
//   builder: (_) => AlertDialog(
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(5),
//     ),
//     content: Text(
//       message,
//       style: TextStyle(
//         fontSize: 16.sp,
//       ),
//       textAlign: TextAlign.center,
//     ),
//     contentPadding: const EdgeInsets.only(
//       right: 20,
//       left: 20,
//       top: 20,
//       bottom: 40,
//     ),
//     actions: [
//       TextAppButton(
//         label: LocaleKeys.openAppSettings.tr(),
//         onPressed: () async {
//           await openAppSettings();
//           AppPages.router.configuration.navigatorKey.currentContext!.pop();
//         },
//       ),
//     ],
//   ),
// );

void showLoadingDialog(BuildContext context,
        {String? message,
        bool canPop = false,
        bool barrierDismissible = false}) =>
    showAnimatedDialog(
      context,
      barrierDismissible: barrierDismissible,
      PopScope(
        canPop: canPop,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator.adaptive(),
              Sizer(height: 20.h),
              Text(
                message ?? Labels.loading,
                style: Styles.headerText(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          contentPadding: const EdgeInsets.only(
            right: 20,
            left: 20,
            top: 20,
            bottom: 40,
          ),
        ),
      ),
    );
// showDialog(
//   context: context,
//   barrierDismissible: barrierDismissible,
//   builder: (_) => PopScope(
//     canPop: canPop,
//     child: AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(5),
//       ),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           const CircularProgressIndicator.adaptive(),
//           Sizer(height: 20.h),
//           Text(
//             message ?? Labels.loading,
//             style: TextStyle(
//               fontSize: 16.sp,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         ],
//       ),
//       contentPadding: const EdgeInsets.only(
//         right: 20,
//         left: 20,
//         top: 20,
//         bottom: 40,
//       ),
//     ),
//   ),
// );

void showConfirmDialog(
  BuildContext context,
  String text,
  VoidCallback? onConfirm, {
  String? confirmText,
  String? cancelText,
  VoidCallback? onCancel,
  TextStyle? cancelTextStyle,
  TextStyle? confirmTextStyle,
}) {
  showAnimatedDialog(
      context,
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        content: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
          ),
          textAlign: TextAlign.center,
        ),
        contentPadding: const EdgeInsets.only(
          right: 20,
          left: 20,
          top: 20,
          bottom: 40,
        ),
        actions: [
          Row(
            children: [
              Expanded(
                child: DefaultButton(
                  label: cancelText ?? 'Cancel',
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    onCancel?.call();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedAppButton(
                  label: confirmText ?? 'Delete',
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    onConfirm?.call();
                  },
                ),
              ),
            ],
          )
        ],
      ));
  // showDialog(
  //   context: context,
  //   builder: (_) => AlertDialog(
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     content: Text(
  //       text,
  //       style: TextStyle(
  //         fontSize: 16.sp,
  //       ),
  //       textAlign: TextAlign.center,
  //     ),
  //     contentPadding: const EdgeInsets.only(
  //       right: 20,
  //       left: 20,
  //       top: 20,
  //       bottom: 40,
  //     ),
  //     actions: [
  //       Row(
  //         children: [
  //           Expanded(
  //             child: DefaultButton(
  //               label: cancelText ?? 'Cancel',
  //               onPressed: () {
  //                 Navigator.of(context, rootNavigator: true).pop();
  //                 onCancel?.call();
  //               },
  //             ),
  //           ),
  //           const SizedBox(width: 8),
  //           Expanded(
  //             child: ElevatedAppButton(
  //               label: confirmText ?? 'Delete',
  //               onPressed: () {
  //                 Navigator.of(context, rootNavigator: true).pop();
  //                 onConfirm?.call();
  //               },
  //             ),
  //           ),
  //         ],
  //       )
  //     ],
  //   ),
  // );
}

showSubscribeDialog(BuildContext context, String subCategoryId) {
    showCustomDialogTrip(
        context,
        Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.alert.localize,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Please Subscribe for more trips',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: FontSize.s16,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                )),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                    width: context.screenWidth / 3.4,
                    label: 'Close',
                    backColor: AppColors.SECONDARY_COLOR_DARK2,
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                const SizedBox(width: 16),
                AppButton(
                    width: context.screenWidth / 3.4,
                    label: 'Subscribe',
                    backColor: AppColors.PRIMARY_COLOR,
                    onPressed: () {
                      Navigator.of(context).pop();
                      SubscriptionMethod().subscribe(
                          subscribeId: subCategoryId,
                          showRegular: true,
                          title: '');
                    }),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ));
  }

  showDebtDialog(BuildContext context, String subCategoryId) {
    showCustomDialogTrip(
        context,
        Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.alert.localize,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Please pay the Debt for more trips',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: FontSize.s16,
                  color: context.isDarkMode ? Colors.white : Colors.black,
                )),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppButton(
                    width: context.screenWidth / 3.4,
                    label: 'Close',
                    backColor: AppColors.SECONDARY_COLOR_DARK2,
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                const SizedBox(width: 16),
                AppButton(
                    width: context.screenWidth / 3.4,
                    label: 'Pay',
                    backColor: AppColors.PRIMARY_COLOR,
                    onPressed: () {
                      Navigator.of(context).pop();
                      serviceLocator<SubscriptionController>()
                          .showActiveSubscriptionAmounts(
                              walletType: WalletTypes.mainWallet, price: 50);
                    }),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ));
  }