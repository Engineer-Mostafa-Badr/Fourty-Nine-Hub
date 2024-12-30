import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/date_time.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_state.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/subscription_widget.dart';
import 'package:fourtyninehub/features/payment/presentation/cubit/payment_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../payment/presentation/pages/payment_cash_out.dart';
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

  late ScrollController _scrollController;
  late WalletCubit _cubit;
  @override
  void initState() {
    super.initState();
    _cubit = context.read<WalletCubit>();
    _scrollController = ScrollController()..addListener(_onScroll);
    _cubit.loadData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit.fetchWalletHistory();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.wallet.localize,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(10),
        child: MaterialButton(
          onPressed: () async {
            context.push(Routes.TRANSFERMONEY);
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
                text: LocaleKeys.transferMoney.localize,
                style: Styles.mediumText(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<WalletCubit, WalletState>(
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
                  balance: state.wallet?.realAmount?.toStringAsFixed(2) ?? '',
                  type: WalletTypes.mainWallet,
                ),
                const Sizer(),
                Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.grey,
                      ),
                      const Sizer(),
                      Expanded(
                        child: Label(
                          text:
                          '${LocaleKeys.minimum.localize}500 ${LocaleKeys.transaction.localize}',
                          style: Styles.mediumText(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                const Sizer(),
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
                          create: (BuildContext context) => serviceLocator(),
                          child: const PaymentCashOut(),
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
                const Sizer(),
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
                const DropDownSubscription(),
                const Sizer(),
                Label(
                  text: LocaleKeys.history.localize,
                  style: Styles.headerText(),
                ),
                state.status == WalletStates.loading
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                  height: 400,
                  child: ListView.separated(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index == _cubit.history.length) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      final item = state.history![index];
                      return WalletHistoryCard(
                        title: '${item.transactionAmount}',
                        subTitle: formatDateTime(item.createdAt, context),
                        amount: item.received == true,
                        icon: FontAwesomeIcons.check,
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(
                      color: AppColors.GREY_NORMAL_COLOR,
                    ),
                    itemCount: state.history?.length ?? 0,
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

}
