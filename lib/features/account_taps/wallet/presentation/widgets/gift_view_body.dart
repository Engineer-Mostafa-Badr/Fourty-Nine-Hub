import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/gift_two_cubit/gift_two_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/competition_section.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_button_wallet_and_gift_and_cashback.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/header_total_account_widget.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/investment_section.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widget/custom_failure_widget.dart';

class GiftViewBody extends StatelessWidget {
  const GiftViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: BlocBuilder<GiftTwoCubit, GiftTwoState>(
        builder: (context, state) {
          if (state.status.isLoading || state.status.isInitial) {
            return const CustomLoading();
          } else if (state.status.isSuccess) {
            final gift = state.giftAndCompetitionEntity!;
            return GlowingOverscrollIndicator(
              color: AppColors.SECONDARY_COLOR,
              // color: AppColors.SECONDARY_COLOR,
              axisDirection: AxisDirection.down,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    HeaderTotalAccountWidget(
                      balance: gift.giftWallet.amount
                          .toString(), //wheelWalletEntity.amount.toString(),
                      holdingAmount:0,
                      currency: context.isArabic
                          ? gift.giftWallet.currencyAr
                          : gift.giftWallet.currencyEn,
                      // state.wallet?.realAmount?.toStringAsFixed(2) ?? '',
                      type: WalletTypes.giftWallet,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CustomButtonWalletAndGiftAndCashback(
                      title: LocaleKeys.billGift.localize,
                      onPressed: () {
                        ManageVibration.vibrate();
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
                      yearsToDate: gift.yearsToDate,
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
                      currency: context.isArabic
                          ? gift.giftWallet.currencyAr
                          : gift.giftWallet.currencyEn,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return SizedBox(
              width: double.infinity,
              child: CustomFailureWidget(
                title:
                    state.errMessage ?? LocaleKeys.somethingWentWrong.localize,
                onPressed: () {
                  ManageVibration.vibrate();
                  context.read<GiftTwoCubit>().getAllData(context);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
