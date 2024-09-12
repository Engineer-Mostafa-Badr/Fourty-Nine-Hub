import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/pages/balance_wallet_view.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/pages/gift_wallet_view.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/pages/normal_wallet_view.dart';
import 'package:fourtyninehub/features/competition/presentation/pages/competition_view.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/pages/wallet_history.dart';
import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class WalletView extends StatelessWidget {
  final WalletTypes type;

  const WalletView({super.key, required this.type});

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
                onTap: () => bottomSheet(
                    context: context,
                    isScrollControlled: true,
                    widget: const WalletHistory(
                      list: [],
                    )),
                label: 'Balance',
                value: '${100}'),
            walletInfoCell(
                icon: Icons.mobile_friendly_sharp,
                label: 'Gift Wallet',
                onTap: () => bottomSheet(
                    isScrollControlled: true,
                    context: context,
                    widget: const CompetitionView(
                      list: [],
                    )),
                value: '${50}'),
            walletInfoCell(
                icon: Icons.refresh,
                onTap: () => bottomSheet(
                    context: context,
                    isScrollControlled: true,
                    widget: const WalletHistory(
                      list: [],
                    )),
                label: 'Wallet',
                value: '${2000}')
          ],
        ));
  }
  //
  // Widget _buildWalletActionItem({
  //   required String label,
  //   required String subTitle,
  //   required Function ontap,
  // }) {
  //   return ListTile(
  //     title: Label(text: label),
  //     subtitle: Label(text: subTitle),
  //     trailing: MaterialButton(
  //       onPressed: () {},
  //       color: Colors.red,
  //       textColor: Colors.white,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(10),
  //       ),
  //       child: Label(
  //           text: 'Transfer', style: Styles.mediumText(color: Colors.white)),
  //     ),
  //   );
  // }

  Widget walletInfoCell(
      {required IconData icon,
      required String label,
      required String value,
      required Function onTap}) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(),
        child: Column(
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            Label(
                text: label,
                style: Styles.mediumText(
                    color: Colors.white,
                    fontSize: 10,
                    decoration: TextDecoration.underline)),
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
    // final controller = context.read<WalletCubit>();
    if (type == WalletTypes.balance) {
      return const BalanceWalletView();
    } else if (type == WalletTypes.giftWallet) {
      return const GiftWalletView();
    } else {
      return const NormalWalletView();
    }
    //   return DefaultTabController(
    //     length: 3,
    //     child: Scaffold(
    //       appBar: const BackAppBar(),
    //       body: SingleChildScrollView(
    //         physics: const BouncingScrollPhysics(),
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(horizontal: 8.0),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.center,
    //             children: [
    //               const Sizer(
    //                 height: 20,
    //               ),
    //               SemicircularIndicator(
    //                 color: AppColors.SECONDARY_COLOR,
    //                 progress: 900 / 1002,
    //                 bottomPadding: 0,
    //                 child: Text(
    //                   '${((900 / 1002) * 100).toStringAsFixed(0)} %',
    //                   style: const TextStyle(
    //                       fontSize: 32,
    //                       fontWeight: FontWeight.w600,
    //                       color: AppColors.PRIMARY_COLOR),
    //                 ),
    //               ),
    //               const Sizer(),

    //               // MaterialButton(
    //               //   onPressed: () async {
    //               //     if (await LocalAuth().checkBiometrics()) {
    //               //       context.push(Routes.TRANSFERMONEY);
    //               //     }
    //               //   },
    //               //   color: Colors.red,
    //               //   textColor: Colors.white,
    //               //   shape: RoundedRectangleBorder(
    //               //     borderRadius: BorderRadius.circular(10),
    //               //   ),
    //               //   minWidth: double.infinity,
    //               //   child: Row(
    //               //     mainAxisAlignment: MainAxisAlignment.center,
    //               //     children: [
    //               //       const Icon(Icons.send_to_mobile_rounded),
    //               //       const Sizer(),
    //               //       Label(
    //               //           text: Labels.transferMoney,
    //               //           style: Styles.mediumText(color: Colors.white)),
    //               //     ],
    //               //   ),
    //               // ),
    //               // _buildWalletActionItem(
    //               //     label: 'Gift / 5 years',
    //               //     subTitle: '0 L.E . 3 years last',
    //               //     ontap: () {}),
    //               // _buildWalletActionItem(
    //               //     label: 'Gift / 10 years',
    //               //     subTitle: '0 L.E . 8 years last',
    //               //     ontap: () {}),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
  }
}
