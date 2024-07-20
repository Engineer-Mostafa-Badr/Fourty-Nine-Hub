import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../res/style/app_colors.dart';
import '../../../res/style/styles.dart';
import '../stateless/labels/label.dart';
import 'sizer.dart';

class WalletWidget extends StatelessWidget {
  final double? margin;
  final bool details;
  final Function(BuildContext context)? onBalanceClicked;
  final Function(BuildContext context)? onWalletClicked;
  final Function(BuildContext context)? onGiftClicked;

  const WalletWidget(
      {super.key,
      this.margin,
      this.details = false,
      this.onBalanceClicked,
      this.onGiftClicked,
      this.onWalletClicked});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: margin ?? 0),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: AppColors.GRAY_LIGHT_COLOR3,
              blurRadius: 5,
              spreadRadius: 5,
            )
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Expanded(
              child: InkWell(
            onTap: () {
              context.push(Routes.WALLET, extra: WalletTypes.balance);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Label(
                    text: 'Balance',
                    style: Styles.mediumText(
                        fontWeight: FontWeight.bold, color: Colors.grey)),
                const Sizer(),
                Label(
                    text: '900',
                    style: Styles.mediumText(
                        color: AppColors.PRIMARY_COLOR,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ],
            ),
          )),
          Container(
            width: .5,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            color: Colors.grey,
            height: kToolbarHeight * .6,
          ),
        
          Expanded(
              child: InkWell(
            onTap: () {
              context.push(Routes.WALLET, extra: WalletTypes.gift);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Label(
                    text: 'Gift',
                    style: Styles.mediumText(
                        fontWeight: FontWeight.bold, color: Colors.grey)),
                const Sizer(),
                Label(
                    text: '300',
                    style: Styles.mediumText(
                        color: const Color.fromARGB(255, 87, 87, 87),
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ],
            ),
          )),
          Container(
            width: .5,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            color: Colors.grey,
            height: kToolbarHeight * .6,
          ),
          
          Expanded(
              child: InkWell(
            onTap: () {
              context.push(Routes.WALLET, extra: WalletTypes.normal);
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Label(
                    text: 'Wallet',
                    style: Styles.mediumText(
                        fontWeight: FontWeight.bold, color: Colors.grey)),
                const Sizer(),
                Label(
                    text: '400',
                    style: Styles.mediumText(
                        color: const Color.fromARGB(255, 87, 87, 87),
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
