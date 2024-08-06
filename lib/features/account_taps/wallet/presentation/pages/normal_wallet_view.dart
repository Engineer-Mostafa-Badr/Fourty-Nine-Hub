import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/subscription_widget.dart';
import 'package:go_router/go_router.dart';

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

class NormalWalletView extends StatefulWidget {
  const NormalWalletView({super.key});

  @override
  State<NormalWalletView> createState() => _NormalWalletViewState();
}

class _NormalWalletViewState extends State<NormalWalletView> {
  bool showMore = false;
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
              // if (await LocalAuth().checkBiometrics()) {
              //   context.push(Routes.TRANSFERMONEY);
              // }
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
                    text: 'Subscriptions',
                    style: Styles.headerText(),
                  ),
                  const SubscriptionWidget(
                      icon:
                          'https://img.freepik.com/premium-vector/live-streaming-icon-video-broadcasting-live-streaming-icon_564974-1250.jpg',
                      expireDate: '2024-08-01',
                      isExpired: false,
                      label: 'Live Streaming'),
                  const SubscriptionWidget(
                      icon:
                          'https://img.freepik.com/premium-vector/verified-vector-icon-account-verification-verification-icon_564974-1246.jpg',
                      expireDate: '2024-07-01',
                      isExpired: true,
                      label: 'Verified Account'),
                  if (showMore)
                    const SubscriptionWidget(
                        icon:
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTU2ztXB3ZqG2jcI5p2FRxDiCJ-n6P9latg3g&s',
                        expireDate: '2025-07-01',
                        isExpired: false,
                        label: 'Broadcast'),
                  InkWell(
                    onTap: () {
                      showMore = !showMore;
                      setState(() {});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(showMore
                            ? Icons.arrow_drop_down_rounded
                            : Icons.arrow_drop_up_rounded),
                        Label(
                          text: 'Show More',
                          style: Styles.smallText(),
                        ),
                      ],
                    ),
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
