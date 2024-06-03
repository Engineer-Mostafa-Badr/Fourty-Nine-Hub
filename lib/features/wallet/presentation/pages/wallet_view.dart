import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:go_router/go_router.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../common/widgets/stateless/labels/label.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import 'package:semicircle_indicator/semicircle_indicator.dart';

import '../../../../routes/routes.dart';

class WalletView extends StatelessWidget {
  const WalletView({super.key});

  Widget walletInfo({
    required BuildContext context,
  }) {
    return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 20, bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.PRIMARY_COLOR.withAlpha(230),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            walletInfoCell(
                icon: Icons.wallet,
                context: context,
                label: 'Balance',
                value: '${100}'),
            walletInfoCell(
                icon: Icons.mobile_friendly_sharp,
                label: 'Gift Wallet',
                context: context,
                value: '${50}'),
            walletInfoCell(
                icon: Icons.refresh,
                context: context,
                label: 'Wallet',
                value: '${2000}')
          ],
        ));
  }

  Widget _buildWalletActionItem({
    required String label,
    required String subTitle,
    required Function ontap,
  }) {
    return ListTile(
      title: Label(text: label),
      subtitle: Label(text: subTitle  ),
      trailing: MaterialButton(
        onPressed: () {},
        color: Colors.red,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Label(
            text: 'Transfer', style: Styles.mediumText(color: Colors.white)),
      ),
    );
  }

  Widget walletInfoCell(
      {required IconData icon,
      required String label,
      required String value,
      required BuildContext context}) {
    return Expanded(
      child: InkWell(
        onTap: () => context.push(Routes.WALLETHISTORY),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            Label(
                text: label,
                style: Styles.mediumText(color: Colors.white, fontSize: 10)),
            Label(
                text: value,
                style: Styles.headerText(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const BackAppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Sizer(
                  height: 20,
                ),
                SemicircularIndicator(
                  color: AppColors.PRIMARY_COLOR,
                  progress: .3,
                  bottomPadding: 0,
                  child: Text(
                    '${(.3 * 100).toStringAsFixed(2)} %',
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: AppColors.PRIMARY_COLOR),
                  ),
                ),
                walletInfo(context: context),
                MaterialButton(
                  onPressed: () {},
                  color: Colors.red,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minWidth: double.infinity,
                  child: Label(
                      text: 'Withdrawal',
                      style: Styles.mediumText(color: Colors.white)),
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.grey,
                    ),
                    const Sizer(),
                    Expanded(
                        child: Label(
                      text: 'Minimum 1002 EGP for personal transaction',
                      style: Styles.mediumText(color: Colors.grey),
                    )),
                  ],
                ),
                _buildWalletActionItem(
                    label: 'Gift / 5 years', subTitle: '0 L.E . 3 years last', ontap: () {}),
                _buildWalletActionItem(
                    label: 'Gift / 10 years', subTitle: '0 L.E . 8 years last', ontap: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
