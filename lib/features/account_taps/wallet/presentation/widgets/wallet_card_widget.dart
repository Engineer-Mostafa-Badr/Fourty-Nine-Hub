import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/account_taps/wallet/domain/entities/wallet_entity.dart';

import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import 'semi_circle_indicator.dart';

class WalletCardWidget extends StatelessWidget {
  final double balance;
  final double? target;
  final WalletTypes type;
  const WalletCardWidget(
      {super.key, required this.balance, this.target, required this.type});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight * 2,
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.PRIMARY_COLOR,
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
                    text: 'Your Balance is',
                    style: Styles.mediumText(color: Colors.white),
                  ),
                if (type == WalletTypes.giftWallet)
                  Label(
                    text: 'Your Gift is',
                    style: Styles.mediumText(color: Colors.white),
                  ),
                if (type == WalletTypes.mainWallet)
                  Label(
                    text: 'Your Wallet is',
                    style: Styles.mediumText(color: Colors.white),
                  ),
                Label(
                  text: '${Labels.currency} ${balance.toStringAsFixed(0)}',
                  style: Styles.headerText(color: Colors.white, fontSize: 25),
                ),
                Label(
                  text: '49 HUB WALLET',
                  style: Styles.mediumText(
                      fontWeight: FontWeight.w300, color: Colors.white),
                )
              ],
            ),
          ),
          if (target != null)
            SizedBox(
              width: kToolbarHeight * 2,
              height: kToolbarHeight,
              child: SemicircularIndicator(
                color: Colors.white,
                progress: balance / (target ?? 1),
                strokeWidth: 10,
                child: Text(
                  '${((balance / (target ?? 1)) * 100).toStringAsFixed(0)} %',
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
