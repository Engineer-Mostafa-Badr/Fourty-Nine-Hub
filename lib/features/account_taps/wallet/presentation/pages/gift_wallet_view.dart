import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locales.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Gift_Cubit/gift_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Gift_Cubit/gift_states.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/messages/messages.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../widgets/competition_card.dart';
import '../widgets/wallet_card_widget.dart';

class GiftWalletView extends StatelessWidget {
  const GiftWalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackAppBar(
          label: LocaleKeys.gift.localize,
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
                      balance: '${state.gift?.giftWallet.amount ?? ''}',
                      type: WalletTypes.giftWallet,
                    ),
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
                                    text: context.locale == Locales.english
                                        ? state.currency?.currencyEn ?? ''
                                        : state.currency?.currencyAr ?? '',
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
                                text: context.locale == Locales.english
                                    ? state.gift?.wheel.descriptionEn ?? ''
                                    : state.gift?.wheel.descriptionAr ?? '',
                                style: Styles.mediumText(color: Colors.grey),
                              )),
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
                                    : Colors.red.withOpacity(.5),
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
}
