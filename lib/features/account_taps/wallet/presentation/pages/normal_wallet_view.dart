import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/stateful/dynamic/pagination_view.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/subscription_widget.dart';
import 'package:fourtyninehub/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:fourtyninehub/features/payment/presentation/pages/payment_view.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../common/models/public/pagination_params.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../domain/entities/wallet/wallet_history_entity.dart';
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
      appBar: BackAppBar(
        label: LocaleKeys.wallet.localize,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        child: MaterialButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider<PaymentCubit>(
                  create: (BuildContext context) => serviceLocator(),
                  child: PaymentView(
                    amountId: '',
                    amount: 500,
                  ),
                ),
              ),
            );
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
              Sizer(),
              Label(
                text: LocaleKeys.transferMoney.localize,
                style: Styles.mediumText(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: BlocProvider<WalletCubit>(
        create: (BuildContext context) => serviceLocator()..loadData(),
        child: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, state) {
            final visibleSubscriptions = state.subscription?.isNotEmpty == true
                ? (showMore
                ? state.subscription
                : state.subscription!.take(2).toList())
                : [];

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<WalletCubit>().loadData();
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                children: [
                  WalletCardWidget(
                    balance: '${state.wallet?.realAmount ?? ''}',
                    type: WalletTypes.mainWallet,
                  ),
                  Sizer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.grey,
                      ),
                      Sizer(),
                      Expanded(
                        child: Row(
                          children: [
                            Label(
                              text: LocaleKeys.minimum.localize,
                              style: Styles.mediumText(color: Colors.grey),
                            ),
                            Label(
                              text: '500 ',
                              style: Styles.mediumText(color: Colors.grey),
                            ),
                            Label(
                              text: LocaleKeys.transaction.localize,
                              style: Styles.mediumText(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Sizer(),
                  state.wallet?.realAmount != null &&
                      state.wallet!.realAmount! >= 500
                      ? AppButton(
                    label: LocaleKeys.withdraw.localize,
                    color: AppColors.AUTH_CONTAINER_COLOR,
                    backColor: AppColors.SECONDARY_COLOR,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider<PaymentCubit>(
                            create: (BuildContext context) =>
                                serviceLocator(),
                            child: PaymentView(
                              amountId: '',
                              amount: 500,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                      : AppButton(
                    label: LocaleKeys.withdraw.localize,
                    backColor: AppColors.SECONDARY_COLOR.withOpacity(.5),
                    onPressed: () {},
                  ),
                  Sizer(),
                  Label(
                    text: LocaleKeys.subscriptions.localize,
                    style: Styles.headerText(),
                  ),
                  Column(
                    children: visibleSubscriptions!.map((subscription) {
                      return SubscriptionWidget(subscription: subscription);
                    }).toList(),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        showMore = !showMore;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(showMore
                            ? Icons.arrow_drop_down_rounded
                            : Icons.arrow_drop_up_rounded),
                        Label(
                          text: showMore
                              ? LocaleKeys.showLess.localize
                              : LocaleKeys.showMore.localize,
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
                    text: LocaleKeys.history.localize,
                    style: Styles.headerText(),
                  ),
                  PaginationView<WalletHistoryEntity>(
                    loadingWidget: const SizedBox.shrink(),
                    build: (scrollController, List<WalletHistoryEntity>data) {
                      return data.isNotEmpty
                          ? ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final item = data[index];
                          final DateTime createdAt =
                          DateTime.parse(item.createdAt);
                          final DateTime egyptTime =
                          createdAt.toUtc().add(const Duration(hours: 3));
                          final String formattedDateTime =
                          DateFormat('dd/MM/yyyy, h:mm a')
                              .format(egyptTime);
                          return WalletHistoryCard(
                            title: '${item.transactionAmount}',
                            subTitle: formattedDateTime,
                            amount: item.received == true,
                            icon: FontAwesomeIcons.check,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return const SizedBox();
                        },
                        itemCount: data.length,
                      )
                          :  Center(
                        child: Label(text: LocaleKeys.noHistoryAvailable.localize),
                      );
                    },
                    fetchData: (PaginationParams paginationParams) {
                      return context
                          .read<WalletCubit>()
                          .fetchWalletHistory(paginationParams: paginationParams);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
