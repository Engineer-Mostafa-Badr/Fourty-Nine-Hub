import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Gift_Cubit/gift_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Gift_Cubit/gift_states.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../widgets/competition_card.dart';
import '../widgets/wallet_card_widget.dart';

class GiftWalletView extends StatelessWidget {
  const GiftWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: BackAppBar(
            label: LocaleKeys.gift.localize,
          ),
        ),
        body: BlocProvider<GiftCubit>(
          create: (_) => serviceLocator()..loadData(),
          child: BlocConsumer<GiftCubit, GiftState>(
              listener: (BuildContext context, GiftState state) {
            if (state.status == GiftStates.success) {
              showSuccessMessage(
                  context, LocaleKeys.requestWithdrawal.localize);
            }
            if (state.status == GiftStates.errorRequest) {
              showErrorMessage(
                context,
                getFailureMessage(
                  state.failure!,
                  context,
                ),
              );
            }
          }, builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    WalletCardWidget(
                      balance: state.gift?.giftWallet.amount ?? '',
                      type: WalletTypes.giftWallet,
                    ),
                    const Sizer(),
                    SizedBox(
                      height: 60.h,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: AppButton(
                                color: AppColors.AUTH_CONTAINER_COLOR,
                                label: LocaleKeys.billCashback.localize,
                                style: Styles.mediumText(
                                  color: AppColors.AUTH_CONTAINER_COLOR,
                                  fontWeight: FontWeight.bold,
                                ),
                                icon: Icons.star,
                                iconSize: 50.h,
                                onPressed: () {
      ManageVibration.vibrate();
                                  HandleCashback.setCount(
                                      'tenPercentCount', context);
                                  context.push(Routes.TenPercent);
                                }),
                          ),
                          Positioned(
                              bottom: 5,
                              left: 5,
                              child: Icon(
                                Icons.star,
                                size: 20.h,
                                color: AppColors.ACCENT_COLOR,
                              )),
                          Positioned(
                              top: 0,
                              left: 10,
                              child: Icon(
                                Icons.star,
                                size: 20.h,
                                color: AppColors.ACCENT_COLOR,
                              )),
                          Positioned(
                              top: 15,
                              right: 10,
                              child: Icon(
                                Icons.star,
                                size: 20.h,
                                color: AppColors.ACCENT_COLOR,
                              ))
                        ],
                      ),
                    ),
                    const Sizer(),
                    _buildWalletActionItem(
                        label:
                            '${LocaleKeys.gift.localize} / 5 ${LocaleKeys.years.localize}',
                        subTitle:
                            '${state.gift?.giftWallet.fiveYears ?? ''}  ${state.gift?.giftWallet.fiveYearsLeft ?? ''} ${LocaleKeys.yearsLast.localize}',
                        ontap: state.gift?.giftWallet.fiveYearsComplete == true
                            ? () {}
                            : state.gift?.giftWallet.fiveYearsTransfer == true
                                ? () {
                                    // context
                                    //     .read<BalanceCubit>()
                                    //     .transferFiveBalance();
                                  }
                                : () {},
                        color: state.gift?.giftWallet.fiveYearsComplete == true
                            ? Theme.of(context).primaryColor
                            : state.gift?.giftWallet.fiveYearsTransfer == true
                                ? AppColors.SECONDARY_COLOR
                                : AppColors.SECONDARY_COLOR
                                    .withValues(alpha: .5),
                        transfer:
                            state.gift?.giftWallet.fiveYearsComplete == true
                                ? LocaleKeys.complete.localize
                                : LocaleKeys.transfer.localize,
                        textColor:
                            state.gift?.giftWallet.fiveYearsComplete == true
                                ? Theme.of(context).scaffoldBackgroundColor
                                : AppColors.AUTH_CONTAINER_COLOR),
                    _buildWalletActionItem(
                        label:
                            '${LocaleKeys.gift.localize} / 10 ${LocaleKeys.years.localize}',
                        subTitle:
                            '${state.gift?.giftWallet.tenYears ?? ''}  ${state.gift?.giftWallet.tenYearsLeft ?? ''} ${LocaleKeys.yearsLast.localize}',
                        ontap: state.gift?.giftWallet.tenYearsComplete == true
                            ? () {}
                            : state.gift?.giftWallet.tenYearsTransfer == true
                                ? () {
                                    // context
                                    //     .read<BalanceCubit>()
                                    //     .transferTenBalance();
                                  }
                                : () {},
                        color: state.gift?.giftWallet.tenYearsComplete == true
                            ? Theme.of(context).primaryColor
                            : state.gift?.giftWallet.tenYearsTransfer == true
                                ? AppColors.SECONDARY_COLOR
                                : AppColors.SECONDARY_COLOR
                                    .withValues(alpha: .5),
                        transfer:
                            state.gift?.giftWallet.tenYearsComplete == true
                                ? LocaleKeys.complete.localize
                                : LocaleKeys.transfer.localize,
                        textColor:
                            state.gift?.giftWallet.tenYearsComplete == true
                                ? Theme.of(context).scaffoldBackgroundColor
                                : AppColors.AUTH_CONTAINER_COLOR),
                    const Sizer(),
                    Label(
                      text: LocaleKeys.competition.localize,
                      style: Styles.headerText(),
                    ),
                    Container(
                      margin: EdgeInsets.all(5.w),
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(color: Colors.grey, width: .5.w),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Label(
                                text: LocaleKeys.luckyWheel.localize,
                                style: Styles.mediumText(
                                    fontSize: 55.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Label(
                                text: '${state.gift?.wheel.amount ?? 0} ',
                              ),
                              BlocBuilder<MainCategoriesCubit,
                                  MainCategoriesState>(
                                builder: (BuildContext context, state) {
                                  return Label(
                                    text: context.isArabic
                                        ? state.currency?.currencyAr ?? ''
                                        : state.currency?.currencyEn ?? '',
                                    // color: AppColors.SECONDARY_COLOR,
                                  );
                                },
                              ),
                            ],
                          ),
                          const Sizer(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Colors.grey,
                              ),
                              Sizer(
                                width: 10.w,
                              ),
                              Expanded(
                                child: Label(
                                  maxLines: 2,
                                  text: context.isArabic
                                      ? state.gift?.wheel.descriptionAr ?? ''
                                      : state.gift?.wheel.descriptionEn ?? '',
                                  style: Styles.mediumText(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          const Sizer(),
                          AppButton(
                            label: LocaleKeys.requestWithdraw.localize,
                            color: AppColors.AUTH_CONTAINER_COLOR,
                            backColor:
                                (state.gift?.wheel.amount ?? 0) >= 10000 &&
                                        state.gift?.wheelWinner == true
                                    ? Colors.red
                                    : Colors.red.withValues(alpha: .5),
                            onPressed:
                                (state.gift?.wheel.amount ?? 0) >= 10000 &&
                                        state.gift?.wheelWinner == true
                                    ? () {
                                        context
                                            .read<GiftCubit>()
                                            .requestWithdrawWheel();
                                      }
                                    : () {},
                          ),
                        ],
                      ),
                    ),
                    const Sizer(),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.gift?.competitionsWallet.length ?? 0,
                      itemBuilder: (context, index) {
                        return CompetitionCard(
                          competitionsWalletEntity:
                              state.gift!.competitionsWallet[index],
                          onTap: () {
      ManageVibration.vibrate();
                            context.read<GiftCubit>().requestWithdraw(
                                state.gift!.competitionsWallet[index].id);
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Sizer(),
                    )
                  ],
                ),
              ),
            );
          }),
        ));
  }

  Widget _buildWalletActionItem({
    required String label,
    required String subTitle,
    required Function() ontap,
    required Color color,
    Color? textColor,
    required String transfer,
  }) {
    return ListTile(
      title: Label(text: label),
      subtitle: Label(text: subTitle),
      trailing: MaterialButton(
        onPressed: () {
      ManageVibration.vibrate();
          ontap();
        },
        color: color,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Label(
            text: transfer,
            style: Styles.mediumText(color: textColor ?? Colors.white)),
      ),
    );
  }
}
