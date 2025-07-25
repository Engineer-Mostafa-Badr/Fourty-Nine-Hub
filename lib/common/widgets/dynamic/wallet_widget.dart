import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/ads/interstitial_ad_model.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../core/localization/locale_keys.g.dart';
import '../../../features/payment/presentation/cache_out_cubit/payment_cubit.dart';
import '../../../res/style/app_colors.dart';
import '../../../res/style/styles.dart';
import '../stateless/labels/label.dart';
import 'sizer.dart';

class WalletWidget extends StatefulWidget {
  const WalletWidget({
    super.key,
    this.margin,
    this.details = false,
    this.onBalanceClicked,
    this.onGiftClicked,
    this.onWalletClicked,
  });

  final double? margin;
  final bool details;
  final Function(BuildContext context)? onBalanceClicked;
  final Function(BuildContext context)? onWalletClicked;
  final Function(BuildContext context)? onGiftClicked;

  @override
  State<WalletWidget> createState() => _WalletWidgetState();
}

class _WalletWidgetState extends State<WalletWidget> {
  bool isOpen = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          serviceLocator<PaymentCacheOutCubit>()..getWallet(),
      child: BlocBuilder<PaymentCacheOutCubit, PaymentCacheOutState>(
        builder: (BuildContext context, state) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: context.isDarkMode
                      ? Colors.grey.shade600
                      : AppColors.GRAY_LIGHT_COLOR3,
                  blurRadius: 5,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                ClickableWidget(
                  onTap: () {
                    ManageVibration.vibrate();
                    setState(() {
                      isOpen = !isOpen;
                    });
                  },
                  child: Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                  ),
                  // color: AppColors.PRIMARY_COLOR,
                ),
                if (isOpen)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 6.w,
                        backgroundColor: AppColors.SECONDARY_COLOR,
                      ),
                      const Sizer(),
                      buildItem(() {
                        ManageVibration.vibrate();
                        AdInterstitialTop.loadIntersitialAd();
                        AdInterstitialTop.showInterstitialAd();
                        // context.push(Routes.BALANCE);
                        context.push(Routes.CASHBACK);
                      },
                          LocaleKeys.balance.tr(),
                          '${FormatNumbers().formatNumber(
                            state.wallet?.balance ?? 0,
                            useArabicNumerals: context.isArabic,
                            roundDown: true,
                          )} ',
                          context.isArabic
                              ? state.wallet?.currencyAr ?? ''
                              : state.wallet?.currencyEn ?? ''),
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
                      buildItem(() {
                        ManageVibration.vibrate();
                        AdInterstitialTop.loadIntersitialAd();
                        AdInterstitialTop.showInterstitialAd();
                        context.push(Routes.GIFT);
                      },
                          LocaleKeys.gift.tr(),
                          '${FormatNumbers().formatNumber(
                            state.wallet?.giftWallet ?? 0,
                            useArabicNumerals: context.isArabic,
                            roundDown: true,
                          )} ',
                          context.isArabic
                              ? state.wallet?.currencyAr ?? ''
                              : state.wallet?.currencyEn ?? ''),
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
                      buildItem(() {
                        ManageVibration.vibrate();
                        AdInterstitialTop.loadIntersitialAd();
                        AdInterstitialTop.showInterstitialAd();
                        context.push(Routes.WALLET);
                        //showing
                      },
                          LocaleKeys.wallet.tr(),
                          '${FormatNumbers().formatNumber(
                            state.wallet?.realAmount ?? 0,
                            useArabicNumerals: context.isArabic,
                            roundDown: true,
                          )} ',
                          context.isArabic
                              ? state.wallet?.currencyAr ?? ''
                              : state.wallet?.currencyEn ?? ''),
                    ],
                  ),
              ],
            ),
          );
        },
      ),
    );

    /*return BlocProvider<MainCategoriesCubit>(
      create: (BuildContext context) => serviceLocator()..getWallet(),
      child: BlocBuilder<MainCategoriesCubit, MainCategoriesState>(
        builder: (BuildContext context, state) {
          return Container(
            // height: 200.h,
            margin: EdgeInsets.symmetric(
                vertical: 10.h, horizontal: widget.margin?.w ?? 5.w),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.GRAY_LIGHT_COLOR3,
                  blurRadius: 5,
                  spreadRadius: 5,
                )
              ],
            ),
            child: Column(
              children: [
                IconButton(
                  onPressed: () {

                    setState(() {
                      isOpen = !isOpen;
                    });
                  },
                  icon: Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                  ),
                  color: AppColors.PRIMARY_COLOR,
                ),
                if (isOpen)
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              AdInterstitialTop.loadIntersitialAd();
                              AdInterstitialTop.showInterstitialAd();
                              context.push(Routes.BALANCE);
                            },
                            child: SizedBox(
                              height: 200.h,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                        onTap: () {
                                          AdInterstitialTop.loadIntersitialAd();
                                          AdInterstitialTop
                                              .showInterstitialAd();
                                          context.push(Routes.BALANCE);
                                        },
                                        child: LiquidCircularProgressIndicator(
                                          value: state.wallet?.balanceRatio
                                                  .toDouble() ??
                                              0,
                                          // Defaults to 0.5.
                                          valueColor:
                                              const AlwaysStoppedAnimation(
                                                  AppColors.SECONDARY_COLOR),
                                          // Defaults to the current Theme's accentColor.
                                          backgroundColor: Colors.white,
                                          // Defaults to the current Theme's backgroundColor.
                                          borderColor: AppColors.PRIMARY_COLOR,
                                          borderWidth: 2,
                                          direction: Axis.vertical,
                                          // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                                          center: Container(
                                            decoration:
                                                const BoxDecoration(boxShadow: [
                                              // BoxShadow(
                                              //     color: Colors.grey,
                                              //     spreadRadius: 0.01,
                                              //     offset: Offset(-1, 1),
                                              //     blurRadius: 20)
                                            ]),
                                            child: Label(
                                              text: (FormatNumbers()
                                                  .formatNumber(
                                                      state.wallet?.balance ??
                                                          0)),
                                              style: Styles.mediumText(
                                                  color:
                                                      AppColors.PRIMARY_COLOR,
                                                  fontSize: 35,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        )),
                                  ),
                                  const Sizer(),
                                  Label(
                                      text: LocaleKeys.balance.tr(),
                                      style: Styles.mediumText(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )),
                      ),
                      const Sizer(
                        width: 50,
                      ),
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              print("objectUser}");
                              AdInterstitialTop.loadIntersitialAd();
                              AdInterstitialTop.showInterstitialAd();
                              context.push(Routes.GIFT);
                            },
                            child: SizedBox(
                              height: 200.h,
                              child: Column(
                                children: [
                                  Expanded(
                                      child: InkWell(
                                    onTap: () {
                                      print("objectUser}");
                                      AdInterstitialTop.loadIntersitialAd();
                                      AdInterstitialTop.showInterstitialAd();
                                      context.push(Routes.GIFT);
                                    },
                                    child: LiquidCircularProgressIndicator(
                                        value: state.wallet?.giftWalletRatio
                                                .toDouble() ??
                                            0,
                                        // Defaults to 0.5.
                                        valueColor:
                                            const AlwaysStoppedAnimation(
                                                AppColors.SECONDARY_COLOR),
                                        // Defaults to the current Theme's accentColor.
                                        backgroundColor: Colors.white,
                                        // Defaults to the current Theme's backgroundColor.
                                        borderColor: AppColors.PRIMARY_COLOR,
                                        borderWidth: 2,
                                        direction: Axis.vertical,
                                        // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                                        center: Container(
                                          decoration:
                                              const BoxDecoration(boxShadow: [
                                            // BoxShadow(
                                            //     color: Colors.grey,
                                            //     spreadRadius: 0.01,
                                            //     offset: Offset(-1, 1),
                                            //     blurRadius: 20)
                                          ]),
                                          child: Label(
                                            text: (FormatNumbers().formatNumber(
                                                state.wallet?.giftWallet ?? 0)),
                                            style: Styles.mediumText(
                                                color: AppColors.PRIMARY_COLOR,
                                                fontSize: 35,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                        // Text(
                                        //     LocaleKeys.gift.tr()),
                                        ),
                                  )),
                                  const Sizer(),
                                  Label(
                                      text: LocaleKeys.gift.tr(),
                                      style: Styles.mediumText(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )),
                      ),
                      const Sizer(
                        width: 50,
                      ),
                      Expanded(
                        child: GestureDetector(
                            onTap: () {
                              AdInterstitialTop.loadIntersitialAd();
                              AdInterstitialTop.showInterstitialAd();
                              context.push(Routes.WALLET);
                            },
                            child: SizedBox(
                              height: 200.h,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                        onTap: () {
                                          AdInterstitialTop.loadIntersitialAd();
                                          AdInterstitialTop
                                              .showInterstitialAd();
                                          context.push(Routes.WALLET);
                                        },
                                        child: LiquidCircularProgressIndicator(
                                          value: state.wallet?.realAmountRatio
                                                  .toDouble() ??
                                              0,
                                          // Defaults to 0.5.
                                          valueColor:
                                              const AlwaysStoppedAnimation(
                                                  AppColors.SECONDARY_COLOR),
                                          // Defaults to the current Theme's accentColor.
                                          backgroundColor: Colors.white,
                                          // Defaults to the current Theme's backgroundColor.
                                          borderColor: AppColors.PRIMARY_COLOR,
                                          borderWidth: 2,
                                          direction: Axis.vertical,
                                          // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.vertical.
                                          center: Container(
                                            decoration:
                                                BoxDecoration(boxShadow: [
                                              // BoxShadow(
                                              //     color: Colors.grey,
                                              //     spreadRadius: 0.01,
                                              //     offset: Offset(-1, 1),
                                              //     blurRadius: 20)
                                            ]),
                                            child: Label(
                                              text: (FormatNumbers()
                                                  .formatNumber(state
                                                          .wallet?.realAmount ??
                                                      0)),
                                              style: Styles.mediumText(
                                                  color:
                                                      AppColors.PRIMARY_COLOR,
                                                  fontSize: 35,
                                                  fontWeight: FontWeight.bold),
                                            ),

                                            // Text(LocaleKeys.wallet.tr() ,
                                          ),
                                        )),
                                  ),
                                  const Sizer(),
                                  Label(
                                      text: LocaleKeys.wallet.tr(),
                                      style: Styles.mediumText(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
              ],
            ),
            // child: Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     CircleAvatar(
            //       radius: 6.w,
            //       backgroundColor: AppColors.SECONDARY_COLOR,
            //     ),
            //     const Sizer(),
            //     buildItem(() {
            //       AdInterstitialTop.loadIntersitialAd();
            //       AdInterstitialTop.showInterstitialAd();
            //       context.push(Routes.BALANCE);
            //     },
            //         LocaleKeys.balance.tr(),
            //         '${FormatNumbers().formatNumber(state.wallet?.balance ?? 0)} ',
            //         state.wallet?.currency ?? ''
            //     ),
            //     Container(
            //       width: 2.w,
            //       margin: EdgeInsets.symmetric(horizontal: 5.w),
            //       color: Colors.grey,
            //       height: double.infinity,
            //     ),
            //     CircleAvatar(
            //       radius: 6.w,
            //       backgroundColor: AppColors.SECONDARY_COLOR,
            //     ),
            //     const Sizer(),
            //     buildItem(() {
            //       AdInterstitialTop.loadIntersitialAd();
            //       AdInterstitialTop.showInterstitialAd();
            //       context.push(Routes.GIFT);
            //     },
            //         LocaleKeys.gift.tr(),
            //         '${FormatNumbers().formatNumber(state.wallet?.giftWallet ?? 0)} ',
            //         state.wallet?.currency ?? ''),
            //     Container(
            //       width: 2.h,
            //       margin: EdgeInsets.symmetric(horizontal: 5.w),
            //       color: Colors.grey,
            //       height: double.infinity,
            //     ),
            //     CircleAvatar(
            //       radius: 6.w,
            //       backgroundColor: AppColors.SECONDARY_COLOR,
            //     ),
            //     const Sizer(),
            //     buildItem(() {
            //       AdInterstitialTop.loadIntersitialAd();
            //       AdInterstitialTop.showInterstitialAd();
            //       context.push(Routes.WALLET);
            //       //showing
            //     },
            //         LocaleKeys.wallet.tr(),
            //         '${FormatNumbers().formatNumber(state.wallet?.realAmount ?? 0)} ',
            //         state.wallet?.currency ?? ''),
            //   ],
            // ),
          );
        },
      ),
    );*/
  }

  Widget buildItem(Function function, String title, String amount, currency) =>
      Expanded(
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
                  color: context.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Label(
                      text: amount.toString(),
                      style: Styles.mediumText(
                        fontWeight: FontWeight.bold,
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Label(
                      text: currency,
                      style: Styles.mediumText(
                        fontWeight: FontWeight.bold,
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.SECONDARY_COLOR,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
