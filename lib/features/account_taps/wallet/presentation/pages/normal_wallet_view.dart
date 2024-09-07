import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/utils/custom_show_dialog.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/subscription_widget.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../cubit/wallet_cubit.dart';
import '../widgets/drop_down_subscription.dart';
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
            color: AppColors.SECONDARY_COLOR,
            textColor: AppColors.AUTH_CONTAINER_COLOR,
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
        body: BlocProvider<WalletCubit>(
          create: (BuildContext context) => serviceLocator()..loadData(),
          child:
              BlocBuilder<WalletCubit, WalletState>(builder: (context, state) {
            final visibleSubscriptions = state.subscription?.isNotEmpty == true
                ? (showMore
                    ? state.subscription
                    : state.subscription!.take(2).toList())
                : []; // Return an empty list if null
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WalletCardWidget(
                      balance: '${state.wallet?.realAmount ?? ''}',
                      type: WalletTypes.mainWallet,
                      // target: 1002,
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
                          child: Row(
                            children: [
                              Label(
                                text: 'Minimum ',
                                style: Styles.mediumText(color: Colors.grey),
                              ),
                              Label(
                                text: '500 ',
                                style: Styles.mediumText(color: Colors.grey),
                              ),
                              Label(
                                text: 'for personal transaction',
                                style: Styles.mediumText(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Sizer(),
                  state.wallet?.realAmount != null && state.wallet!.realAmount! >= 500
                      ? AppButton(
                    label: 'Withdraw',
                    color: AppColors.AUTH_CONTAINER_COLOR,
                    backColor: AppColors.SECONDARY_COLOR,
                    onPressed: () => context.push(Routes.PAYMENT),
                  )
                      : AppButton(
                    label: 'Withdraw',
                    backColor: AppColors.SECONDARY_COLOR.withOpacity(.5),
                    onPressed: (){}, // Disable button if less than 500
                  ),
                    const Sizer(),
                    Label(
                      text: 'Subscriptions',
                      style: Styles.headerText(),
                    ),
                    Column(
                      children: visibleSubscriptions!.map((subscription) {
                        return SubscriptionWidget(subscription: subscription);
                      }).toList(),
                    ),
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
                            text: showMore ? 'Show More' : 'Show Less',
                            style: Styles.smallText(
                                color: Theme.of(context).primaryColor),
                          ),
                        ],
                      ),
                    ),
                    const Sizer(),
                    DropDownSubscription(),
                    const Sizer(),
                    Label(
                      text: 'History',
                      style: Styles.headerText(),
                    ),
                    ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = state.history![index];
                          final DateTime createdAt =
                              DateTime.parse(item.createdAt);
                          final DateTime egyptTime =
                              createdAt.toUtc().add(const Duration(hours: 3));
                          final String formattedDateTime =
                              DateFormat('dd/MM/yyyy, h:mm a')
                                  .format(egyptTime);
                          return WalletHistoryCard(
                              title: '${item.transactionAmount ?? ''}',
                              subTitle: formattedDateTime,
                              onTap: () {},
                              amount: item.received == true,
                              icon: FontAwesomeIcons.check);
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox();
                        },
                        itemCount: state.history?.length ?? 0)
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
