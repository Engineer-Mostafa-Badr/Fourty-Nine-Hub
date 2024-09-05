import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';

import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums/wallet_types_enums.dart';
import '../../../core/localization/locale_keys.g.dart';
import '../../../features/account_taps/wallet/presentation/pages/balance_wallet_view.dart';
import '../../../features/account_taps/wallet/presentation/pages/gift_wallet_view.dart';
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
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20.zR),
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
          CircleAvatar(
            radius: 6.zW,
            backgroundColor: AppColors.SECONDARY_COLOR,
          ),
          const Sizer(),
          buildItem(
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const BalanceWalletView()));
            },
            LocaleKeys.balance.tr(),
            '900',
          ),
          Container(
            width: 2.zW,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            color: Colors.grey,
            height: kToolbarHeight * 1.3.zH,
          ),
          CircleAvatar(
            radius: 6.zW,
            backgroundColor: AppColors.SECONDARY_COLOR,
          ),
          const Sizer(),
          buildItem(
            () {
              //context.push(Routes.WALLET, extra: WalletTypes.giftWallet);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GiftWalletView()));
            },
            LocaleKeys.gift.tr(),
            '300',
          ),
          Container(
            width: 2.zW,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            color: Colors.grey,
            height: kToolbarHeight * 1.3.zH,
          ),
          CircleAvatar(
            radius: 6.zW,
            backgroundColor: AppColors.SECONDARY_COLOR,
          ),
          const Sizer(),
          buildItem(
            () {
              context.push(Routes.WALLET, extra: WalletTypes.mainWallet);
            },
            LocaleKeys.wallet.tr(),
            '400',
          ),
        ],
      ),
    );
  }

  Widget buildItem(Function function, String title, String amount) => Expanded(
          child: InkWell(
        onTap: () {
          function();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
                text: title,
                style: Styles.mediumText(
                  fontWeight: FontWeight.bold,
                )),
            Label(
                text: amount,
                style: Styles.mediumText(
                    fontWeight: FontWeight.bold, fontSize: 32)),
          ],
        ),
      ));
}
