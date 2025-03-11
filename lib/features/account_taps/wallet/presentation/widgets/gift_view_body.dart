import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/competition_section.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_button_wallet_and_gift_and_cashback.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/header_total_account_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/investment_section.dart';

class GiftViewBody extends StatelessWidget {
  const GiftViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const HeaderTotalAccountWidget(
              balance: '1222',
              // state.wallet?.realAmount?.toStringAsFixed(2) ?? '',
              type: WalletTypes.giftWallet,
            ),
            const SizedBox(
              height: 16,
            ),
            CustomButtonWalletAndGiftAndCashback(
              title: 'Bill Gift',
              onpressed: () {},
            ),
            const SizedBox(
              height: 16,
            ),
            const InvestmentSection(),
            const SizedBox(
              height: 16,
            ),
            CompetitionsSection(),
          ],
        ),
      ),
    );
  }
}
