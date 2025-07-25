import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';

import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/styles.dart';

class HeaderTotalAccountWidget extends StatelessWidget {
  final String balance;
  final double? target;
  final WalletTypes type;
  final String currency;
  const HeaderTotalAccountWidget({
    super.key,
    required this.balance,
    this.target,
    required this.type,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          // color: Theme.of(context).primaryColor,
          gradient: const LinearGradient(
            begin: Alignment(1.00, 0.00),
            end: Alignment(-1, 0),
            colors: [
              Color(0xFF0B1035),
              Color(0xFF151F68),
              Color(0xFF1A2781),
              Color(0xFF1D2A8E),
              Color(0xFF1E2C94),
              Color(0xFF0B1035)
            ],
          ),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                  text: type == WalletTypes.balance
                      ? LocaleKeys.yourBalance.localize
                      : (type == WalletTypes.giftWallet
                          ? LocaleKeys.yourGift.localize
                          : LocaleKeys.yourWallet.localize),
                  style: Styles.mediumText(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Label(
                      text: FormatNumbers().formatNumberByComma(
                        balance,
                        isArabic: context.isArabic,
                      ),
                      style: Styles.headerText(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                    const Sizer(width: 6),
                    BlocBuilder<MainCategoriesCubit, MainCategoriesState>(
                      builder: (BuildContext context, state) {
                        return Transform.translate(
                          offset: Offset(0, 0.h),
                          child: Label(
                            text: currency,
                            style: Styles.headerText(
                              color: Colors.white,
                              fontSize: 30,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Label(
                    text: LocaleKeys.hUB.localize,
                    style: Styles.mediumText(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
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

  // String _formatBalance(BuildContext context, String? balance) {
  //   if (balance == null || balance.isEmpty) {
  //     return "0"; // Fallback value if balance is null or empty
  //   }
  //
  //   try {
  //     // return double.parse(balance).floor().toString();
  //     final NumberFormat formatter;
  //     if (context.isArabic) {
  //       formatter = NumberFormat('#,###');
  //     } else {
  //       formatter = NumberFormat('#,###', 'en');
  //     }
  //
  //     return formatter.format(num.parse(balance));
  //   } catch (e) {
  //     // If parsing fails, return a fallback value or handle the error as needed
  //     return "0";
  //   }
  // }
}
