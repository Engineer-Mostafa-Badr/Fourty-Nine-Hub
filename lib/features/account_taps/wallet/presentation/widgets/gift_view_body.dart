import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
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

import '../../../../../core/widget/custom_failure_widget.dart';

class GiftViewBody extends StatelessWidget {
  const GiftViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: BlocBuilder<GiftTwoCubit, GiftTwoState>(
        builder: (context, state) {
          if (state.status.isLoading || state.status.isInitial) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status.isSuccess) {
            final gift = state.giftAndCompetitionEntity!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  HeaderTotalAccountWidget(
                    balance: gift.giftWallet.amount
                        .toString(), //wheelWalletEntity.amount.toString(),
                    // state.wallet?.realAmount?.toStringAsFixed(2) ?? '',
                    type: WalletTypes.giftWallet,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomButtonWalletAndGiftAndCashback(
                    title: LocaleKeys.billGift.localize,
                    onPressed: () {
                      HandleCashback.setCount('tenPercentCount', context);
                      context.push(Routes.TenPercent);
                    },
                    status: true,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  InvestmentSection(
                   giftWalletEntity: gift.giftWallet,
                  ),
                  // المسافة بين العنصرين هنا تم تحويلها إلى داخل الـ
                  // InvestmentSection
                  // لضبط الانميشن
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  CompetitionsSection(
                    competitions: gift.competitionsWallet,
                    luckyWheel: gift.wheelWallet,
                    currency: context.isArabic? gift.giftWallet.currencyAr : gift.giftWallet.currencyEn,

                  ),
                ],
              ),
            );
          } else {
            return CustomFailureWidget(
              title: state.errMessage ?? LocaleKeys.somethingWentWrong.localize,
              onPressed: () {
                context.read<GiftTwoCubit>().getAllData(context);
              },
            );
          }
        },
      ),
    );
  }
}
