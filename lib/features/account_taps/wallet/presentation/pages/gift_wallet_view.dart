import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Gift_Cubit/gift_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Gift_Cubit/gift_states.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';

import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/enums/wallet_types_enums.dart';
import '../../../../../core/localization/locale_keys.g.dart';
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
          child: BlocBuilder<GiftCubit, GiftState>(builder: (context, state) {
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
                          Label(
                            text: LocaleKeys.luckyWheel.localize,
                            style: Styles.mediumText(fontWeight: FontWeight.bold),
                          ),
                           Label(
                            text: '${state.gift?.amount ??0}',
                          ),
                          const Sizer(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Colors.grey,
                              ),
                               Sizer(width: 10.w,),
                              Expanded(
                                  child: Label(
                                    maxLines: 2,
                                    text:
                                    '${LocaleKeys.minimum.localize} 10000 ${LocaleKeys.requestTransaction.localize}',
                                    style: Styles.mediumText(color: Colors.grey),
                                  )),
                            ],
                          ),
                          const Sizer(),
                          AppButton(
                            label: LocaleKeys.requestWithdraw.localize,
                            color: AppColors.AUTH_CONTAINER_COLOR,
                            backColor: (state.gift?.amount ?? 0) >= 10000 && state.gift?.wheelWinner == true
                                ? Colors.red
                                : Colors.red.withOpacity(.5),

                            onPressed: () {},
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
                            onTap: (context) {},
                            // onTap: (context) =>
                            //     controller.showGiftsHistory(context: context),
                          );
                        }, separatorBuilder: (BuildContext context, int index)=>const Sizer(),)
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
