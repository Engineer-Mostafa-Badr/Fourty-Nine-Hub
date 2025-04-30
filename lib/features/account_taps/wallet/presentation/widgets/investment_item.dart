import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_button_wallet_and_gift_and_cashback.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InvestmentItem extends StatelessWidget {
  const InvestmentItem({
    super.key,
    required this.onPressed,
    required this.totalYears,
    required this.currentYears,
    required this.price,
    required this.currency,
    required this.isLoading,
    required this.isComplete,
  });

  final void Function() onPressed;
  final String totalYears;
  final String currentYears;
  final num price;
  final String currency;
  final bool isLoading;
  final bool isComplete;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
              text:
                  '${FormatNumbers().formatNumberByComma(currentYears, isArabic: context.isArabic)} / ${FormatNumbers().formatNumberByComma(totalYears, isArabic: context.isArabic)} ${LocaleKeys.years.localize}',
              style: Styles.mediumText(
                fontSize: 32,
                color: context.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Label(
              text:
                  '${FormatNumbers().formatNumber(price, useArabicNumerals: context.isArabic)} $currency',
              style: Styles.smallText(
                fontSize: 24,
              ),
            ),
          ],
        ),
        isComplete
            ? AppButton(
                label: LocaleKeys.received.localize,
                style: Styles.headerText(color: Colors.white, fontSize: 32),
                onPressed: () {},
                backColor: Colors.green,
                padding: 24,
              )
            : isLoading
                ? const Padding(
                    padding: EdgeInsetsDirectional.only(end: 26),
                    child: CircularProgressIndicator(),
                  )
                : CustomButtonWalletAndGiftAndCashback(
                    title: LocaleKeys.transfer.localize,
                    onPressed: onPressed,
                    padding: 24,
                    status: int.parse(currentYears) > int.parse(totalYears),
                  )
      ],
    );
  }
}
