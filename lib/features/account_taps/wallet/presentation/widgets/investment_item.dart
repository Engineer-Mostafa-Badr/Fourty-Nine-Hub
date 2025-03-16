import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_two_cubit/wallet_two_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_button_wallet_and_gift_and_cashback.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class InvestmentItem extends StatelessWidget {
  const InvestmentItem({
    super.key,
    required this.onPressed,
    required this.totalYears,
    required this.currentYears,
    required this.isLoading,
  });

  final void Function() onPressed;
  final int totalYears;
  final int currentYears;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
              text: 'Gift / $totalYears Years',
              style: Styles.mediumText(fontSize: 32),
            ),
            const SizedBox(
              height: 4,
            ),
            Label(
              text: '$currentYears Years',
              style: Styles.smallText(
                fontSize: 24,
              ),
            ),
          ],
        ),
        isLoading
            ? const CircularProgressIndicator()
            : CustomButtonWalletAndGiftAndCashback(
                title: LocaleKeys.transfer.localize,
                onPressed: onPressed,
                padding: 24,
                status: totalYears == currentYears,
              ),
      ],
    );
  }
}
