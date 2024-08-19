import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/wallet_card_widget.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../widgets/wallet_history_card.dart';

class BalanceWalletView extends StatelessWidget {
  const BalanceWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(
          label: Labels.balanceWallet,
        ),
        body: BlocBuilder<WalletCubit, WalletState>(builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WalletCardWidget(
                    balance: 900,
                    target: 1002,
                    type: WalletTypes.balance,
                  ),
                  const Sizer(),
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
                  AppButton(
                    backColor: Colors.red.withOpacity(.5),
                    label: 'Request Withdrawel',
                    onPressed: () => context.push(Routes.PAYMENT),
                    margin: 10,
                  ),
                  _buildWalletActionItem(
                      label: 'Gift / 5 years',
                      subTitle: '0 L.E . 3 years last',
                      ontap: () {}),
                  _buildWalletActionItem(
                      label: 'Gift / 10 years',
                      subTitle: '0 L.E . 8 years last',
                      ontap: () {}),
                  const Sizer(),
                  Label(
                    text: 'History',
                    style: Styles.headerText(),
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = state.balanceHistory![index];
                        return WalletHistoryCard(
                            title: '${item.amount} ${Labels.currency}',
                            subTitle: item.description,
                            onTap: () {},
                            amount: item.amount,
                            icon: FontAwesomeIcons.check);
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox();
                      },
                      itemCount: state.balanceHistory?.length ?? 0)
                ],
              ),
            ),
          );
        }));
  }

  Widget _buildWalletActionItem({
    required String label,
    required String subTitle,
    required Function ontap,
  }) {
    return ListTile(
      title: Label(text: label),
      subtitle: Label(text: subTitle),
      trailing: MaterialButton(
        onPressed: null,
        color: Colors.red,
        disabledColor: const Color.fromARGB(159, 255, 82, 82),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Label(
            text: 'Transfer', style: Styles.mediumText(color: Colors.white)),
      ),
    );
  }
}
