import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/gift_two_cubit/gift_two_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/competition_section.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_button_wallet_and_gift_and_cashback.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/header_total_account_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/investment_section.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class GiftViewBody extends StatelessWidget {
  const GiftViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<GiftTwoCubit, GiftTwoState>(
        builder: (context, state) {
          if (state is GiftTwoFailure) {
            return Center(
              child: Text(state.message),
            );
          }
          if (state is GiftTwoLoading || state is GiftTwoInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GiftTwoSuccess) {
            // final giftEntity = state.giftEntity;
            final wheelWalletEntity = state.wheelWalletEntity;
            return SingleChildScrollView(
              child: Column(
                children: [
                  HeaderTotalAccountWidget(
                    balance: wheelWalletEntity.amount.toString(),
                    // state.wallet?.realAmount?.toStringAsFixed(2) ?? '',
                    type: WalletTypes.giftWallet,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomButtonWalletAndGiftAndCashback(
                    title: LocaleKeys.billGift.localize,
                    onpressed: () {
                      HandleCashback.setCount('tenPercentCount', context);
                      context.push(Routes.TenPercent);
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const InvestmentSection(),
                  // المسافة بين العنصرين هنا تم تحويلها إلى داخل الـ
                  // InvestmentSection
                  // لضبط الانميشن
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  CompetitionsSection(),
                ],
              ),
            );
          }
          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }
}
