import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/styles.dart';

class WalletCardWidget extends StatelessWidget {
  final String balance;
  final String currency;
  final double? target;
  final WalletTypes type;
  const WalletCardWidget(
      {super.key, required this.balance, this.target, required this.type, required this.currency});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight * 2,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (type == WalletTypes.balance)
                  Label(
                    text: LocaleKeys.yourBalance.localize,
                    style: Styles.mediumText(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                if (type == WalletTypes.giftWallet)
                  Label(
                    text: LocaleKeys.yourGift.localize,
                    style: Styles.mediumText(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                if (type == WalletTypes.mainWallet)
                  Label(
                    text: LocaleKeys.yourWallet.localize,
                    style: Styles.mediumText(
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Label(
                      text: _formatBalance(balance),
                      style: Styles.headerText(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        fontSize: 100.sp,
                      ),
                    ),
                    Sizer(width: 10.w),
                    Transform.translate(
                      offset: Offset(0, 8.h),
                      child: Label(
                        text: currency,
                        style: Styles.headerText(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          fontSize: 40.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                Label(
                  text: LocaleKeys.hUB.localize,
                  style: Styles.mediumText(
                      fontWeight: FontWeight.w300,
                      color: Theme.of(context).scaffoldBackgroundColor),
                )
              ],
            ),
          ),
          // if (target != null)
          //   SizedBox(
          //     width: kToolbarHeight * 2,
          //     height: kToolbarHeight,
          //     child: SemicircularIndicator(
          //       color: Colors.white,
          //       progress: balance,
          //       strokeWidth: 10,
          //       child: Text(
          //         '${((balance / (target ?? 1)) * 100).toStringAsFixed(0)} %',
          //         style: const TextStyle(
          //             fontSize: 20.sp,
          //             fontWeight: FontWeight.w600,
          //             color: Colors.white),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }

  String _formatBalance(String? balance) {
    if (balance == null || balance.isEmpty) {
      return "0"; // Fallback value if balance is null or empty
    }

    try {
      return double.parse(balance).floor().toString();
    } catch (e) {
      // If parsing fails, return a fallback value or handle the error as needed
      return "0";
    }
  }
}
