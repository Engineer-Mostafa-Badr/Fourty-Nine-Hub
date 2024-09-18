import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Balance_Cubit/balance_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Balance_Cubit/balance_states.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Gift_Cubit/gift_cubit.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/Gift_Cubit/gift_states.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_cubit.dart';

import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../core/enums/wallet_types_enums.dart';
import '../../../core/localization/locale_keys.g.dart';
import '../../../features/account_taps/wallet/presentation/pages/balance_wallet_view.dart';
import '../../../features/account_taps/wallet/presentation/pages/gift_wallet_view.dart';
import '../../../res/style/app_colors.dart';
import '../../../res/style/styles.dart';
import '../../../service_locator/service_locator.dart';
import '../stateless/labels/label.dart';
import 'sizer.dart';

class WalletWidget extends StatelessWidget {
  final double? margin;
  final bool details;
  final Function(BuildContext context)? onBalanceClicked;
  final Function(BuildContext context)? onWalletClicked;
  final Function(BuildContext context)? onGiftClicked;

  const WalletWidget(
      {super.key,
      this.margin,
      this.details = false,
      this.onBalanceClicked,
      this.onGiftClicked,
      this.onWalletClicked});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GiftCubit>(
      create: (BuildContext context) =>serviceLocator(),
      child: BlocBuilder<GiftCubit, GiftState>(
        builder: (BuildContext context, state) {
          return Container(
            height: 90.h,
            margin:
                EdgeInsets.symmetric(vertical: 10.h, horizontal: margin?.w ?? 5.w),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.GRAY_LIGHT_COLOR3,
                    blurRadius: 5,
                    spreadRadius: 5,
                  )
                ]),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 6.w,
                  backgroundColor: AppColors.SECONDARY_COLOR,
                ),
                const Sizer(),
                BlocProvider<BalanceCubit>(
                  create: (BuildContext context) => serviceLocator(),
                  child: BlocBuilder<BalanceCubit, BalanceState>(
                    builder: (BuildContext context, state) {
                      return buildItem(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BalanceWalletView()));
                      }, LocaleKeys.balance.tr(),
                          '${state.balance?.balance ?? ''}');
                    },
                  ),
                ),
                Container(
                  width: 2.w,
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  color: Colors.grey,
                  height: kToolbarHeight * 1.3.h,
                ),
                CircleAvatar(
                  radius: 6.w,
                  backgroundColor: AppColors.SECONDARY_COLOR,
                ),
                const Sizer(),
            buildItem(
                  () {
                //context.push(Routes.WALLET, extra: WalletTypes.giftWallet);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GiftWalletView()));
              },
              LocaleKeys.gift.tr(),
              '${state.gift?.giftWallet.amount ?? ''}',
            ),
                Container(
                  width: 2.h,
                  margin: EdgeInsets.symmetric(horizontal: 5.w),
                  color: Colors.grey,
                  height: kToolbarHeight * 1.3,
                ),
                CircleAvatar(
                  radius: 6.w,
                  backgroundColor: AppColors.SECONDARY_COLOR,
                ),
                const Sizer(),
                BlocProvider<WalletCubit>(
                  create: (BuildContext context) =>serviceLocator(),
                  child: BlocBuilder<WalletCubit,WalletState>(
                    builder: (BuildContext context, state) {
                      return buildItem(() {
                        context.push(Routes.WALLET, extra: WalletTypes.mainWallet);
                      },
                          LocaleKeys.wallet.tr(),
                          '${state.wallet?.realAmount?.floor() ?? ''}');
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildItem(Function function, String title, String amount) => Expanded(
          child: InkWell(
        onTap: () {
          function();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
                text: title,
                style: Styles.mediumText(
                  fontWeight: FontWeight.bold,
                )),
            Expanded(
              child: Label(
                  text: amount,
                  style: Styles.mediumText(
                      fontWeight: FontWeight.bold,)),
            ),
          ],
        ),
      ));
}
