import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/charge_wallet_cubit/charge_wallet_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/fetch_sub_category_wallet/fetch_sub_category_wallet_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_two_cubit/wallet_two_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/button_wallet_and_bill.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/charge_wallet_button_bloc.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/history_wallet_list_view_item.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/icon_and_hint_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/header_total_account_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/my_subscription_section.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/select_categories_wallet_section.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/with_drawal_button.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

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
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<WalletTwoCubit, WalletTwoState>(
        builder: (context, state) {
          if (state is WalletTwoLoading || state is WalletTwoInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is WalletTwoSuccess) {
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<WalletTwoCubit>().getAllDataWalletScreen(),
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
                                  balance: state.wallet.realAmount.toString(),
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
                                WithDrawalButton(
                                  state: state.wallet.realAmount != null &&
                                      state.wallet.realAmount! >= 500,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                MySubscriptionSection(
                                  subscriptions: state.subscription ?? [],
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                SelectCategoriesWalletSection(
                                  mainCategories: state.mainCategory,
                                ),
                                // SubCategorySubscription(
                                //   subCategories: state,
                                // ),
                                Label(
                                  text: 'History',
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
                        SliverList.builder(
                          itemCount: state.walletHistory?.length ?? 0,
                          itemBuilder: (context, index) =>
                              HistoryWalletListViewItem(
                            history: state.walletHistory?[index],
                          ),
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
                      label: 'Transfer Money',
                      onPressed: () {
                        context.push(Routes.TRANSFERMONEY);
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Label(
                  text: LocaleKeys.somethingWentWrong.localize,
                  style: Styles.headerText(),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ButtonWalletAndBill(
                    icon: const Icon(
                      Icons.refresh_sharp,
                      color: Colors.white,
                    ),
                    label: 'Refresh',
                    onPressed: () {
                      context.read<WalletTwoCubit>().getAllDataWalletScreen();
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
