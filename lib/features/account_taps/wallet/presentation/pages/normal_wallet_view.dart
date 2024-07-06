import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/functions/helper/local_auth.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../domain/entities/wallet_entity.dart';
import '../cubit/wallet_cubit.dart';
import '../widgets/wallet_card_widget.dart';
import '../widgets/wallet_history_card.dart';

class NormalWalletView extends StatelessWidget {
  const NormalWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const BackAppBar(
          label: Labels.normalWallet,
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(10),
          child: MaterialButton(
            onPressed: () async {
              if (await LocalAuth().checkBiometrics()) {
                context.push(Routes.TRANSFERMONEY);
              }
            },
            color: Colors.red,
            textColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minWidth: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.send_to_mobile_rounded),
                const Sizer(),
                Label(
                    text: Labels.transferMoney,
                    style: Styles.mediumText(color: Colors.white)),
              ],
            ),
          ),
        ),
        body: BlocBuilder<WalletCubit, WalletState>(builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const WalletCardWidget(
                    balance: 400,
                    type: WalletTypes.normal,

                    // target: 1002,
                  ),
                  const Sizer(),
                  AppButton(
                    label: 'Withdrawel',
                    backColor: AppColors.SECONDARY_COLOR.withOpacity(.5),
                    onPressed: () => context.push(Routes.PAYMENT),
                  ),
                  const Sizer(),
                  Label(
                    text: 'History',
                    style: Styles.headerText(),
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final item = state.walletHistory![index];
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
}
