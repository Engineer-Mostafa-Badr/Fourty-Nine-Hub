import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/charge_wallet_cubit/charge_wallet_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/fetch_sub_category_wallet/fetch_sub_category_wallet_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_two_cubit/wallet_two_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/button_wallet_and_bill.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/charge_wallet_button_bloc.dart';
import 'package:fourtyninehub/core/widget/icon_and_hint_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/header_total_account_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/my_subscription_section.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/select_categories_wallet_section.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/request_wallet_button.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widget/custom_failure_widget.dart';
import '../cubit/subscription_wallet_cubit/subscription_wallet_cubit.dart';
import 'history_wallet_sliver_list.dart';

class WalletViewBody extends StatelessWidget {
  const WalletViewBody({super.key});

// Future<void> showActiveSubscriptionAmounts(
//       {required WalletTypes walletType}) async {
//     final response =
//     await _getActiveSubscriptionAmountsUseCase(const NoParams());
//     response.fold(
//           (l) => showErrorMessage(
//         context,
//         Labels.errorHappened,
//       ),
//           (data) => bottomSheet(
//         context: context,
//         widget: SubscriptoinAmountsWidget(
//           amounts: data,
//           walletType: walletType,
//         ),
//       ),
//     );
//   }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: BlocConsumer<WalletTwoCubit, WalletTwoState>(
        listener: (context, state) {
          if (state.buttonRequestSuccess == false) {
            showErrorMessage(
              context,
              state.buttonRequestErrMessage ??
                  LocaleKeys.somethingWentWrong.localize,
            );
          }
          if (state.buttonRequestSuccess == true) {
            showSuccessMessage(context, LocaleKeys.requestSentSuccess.localize);
          }
        },
        builder: (context, state) {
          if (state.status.isLoading || state.status.isInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status.isSuccess) {
            return RefreshIndicator(
              onRefresh: () => context
                  .read<WalletTwoCubit>()
                  .getAllDataWalletScreen(context),
              child: Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) => serviceLocator<
                                    FetchSubCategoryWalletCubit>(),
                              ),
                              BlocProvider(
                                create: (context) =>
                                    serviceLocator<ChargeWalletCubit>(),
                              ),
                            ],
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                HeaderTotalAccountWidget(
                                  balance:
                                      state.wallet?.realAmount.toString() ?? '',
                                  currency: context.isArabic
                                      ? state.wallet!.currencyAr
                                      : state.wallet!.currencyEn,
                                  // state.wallet?.realAmount?.toStringAsFixed(2) ?? '',
                                  type: WalletTypes.mainWallet,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                IconAndHintWidget(
                                  text:
                                      '${LocaleKeys.minimum.localize}500 ${LocaleKeys.transaction.localize}',
                                ),
                                const SizedBox(
                                  height: 16,
                                ),

                                const ChargeWalletButtonBloc(),
                                const SizedBox(
                                  height: 8,
                                ),
                                // state.wallet?.realAmount != null &&
                                //         state.wallet!.realAmount! >= 500
                                RequestWalletButton(
                                    amount: state.wallet?.realAmount ?? 0,
                                    target: 500,
                                    // TODO: Edit this
                                    isWaitingApproval: false
                                    // state.wallet?.isWaitingApproval ?? false,
                                    ),
                                const SizedBox(
                                  height: 16,
                                ),
                                BlocConsumer<SubscriptionWalletCubit,
                                    SubscriptionWalletState>(
                                  listener: (context, subscriptionState) {
                                    if (subscriptionState
                                        is SubscriptionWalletSuccess) {
                                      context
                                          .read<WalletTwoCubit>()
                                          .getAllDataWalletScreen(context);
                                    }
                                  },
                                  builder: (context, subscriptionState) {
                                    if (subscriptionState
                                        is SubscriptionWalletLoading) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return MySubscriptionSection(
                                        subscriptions: state.subscription ?? [],
                                      );
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SelectCategoriesWalletSection(
                                  mainCategories: state.mainCategory!,
                                ),
                                // SubCategorySubscription(
                                //   subCategories: state,
                                // ),
                                Label(
                                  text: LocaleKeys.history.localize,
                                  style: Styles.headerText(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                        HistoryWalletSliverList(
                          walletHistories: state.walletHistory!,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ButtonWalletAndBill(
                      icon: SvgPicture.asset(
                        Assets.transferMoneyByMobileIcon,
                      ),
                      label: LocaleKeys.transferMoney.localize,
                      onPressed: () {
                        context.push(Routes.TRANSFERMONEY);
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return CustomFailureWidget(
              title: state.failureMessage ??
                  LocaleKeys.somethingWentWrong.localize,
              onPressed: () {
                context.read<WalletTwoCubit>().getAllDataWalletScreen(context);
              },
            );
          }
        },
      ),
    );
  }
}
