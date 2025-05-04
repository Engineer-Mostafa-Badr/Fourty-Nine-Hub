import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/features/subscripe/domain/usecases/subscribe_usecase.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/style/styles.dart';
import '../../../account_taps/wallet/domain/usecases/add_subscribe_use_case.dart';
import '../../domain/entities/subscription_plans_entity.dart';

class SubscriptionPlansWidget extends StatefulWidget {
  final SubscriptionPlansEntity subscribePlans;
  final List<WalletTypes>? paymentMenthods;
  final String subCategoryId;
  final String? title;
  final bool? showRegular;
  final Function? onSubscribe;

  const SubscriptionPlansWidget({
    super.key,
    this.paymentMenthods,
    required this.subscribePlans,
    required this.subCategoryId,
    this.title,
    this.showRegular,
    this.onSubscribe,
  });

  @override
  State<SubscriptionPlansWidget> createState() =>
      _SubscriptionPlansWidgetState();
}

class _SubscriptionPlansWidgetState extends State<SubscriptionPlansWidget> {
  bool _isPremium = true;

  WalletTypes? selectedWallet;

  @override
  void initState() {
    selectedWallet = widget.paymentMenthods?[0];
    print("widget.paymentMenthods ${widget.paymentMenthods?.length}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCategoriesCubit, MainCategoriesState>(
      builder: (BuildContext context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              context.isArabic
                  ? Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(children: [
                        TextSpan(
                          text: LocaleKeys.subscription.localize,
                          style: Styles.headerText(
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                          ),
                        ),
                        const TextSpan(
                          text: "  ",
                        ),
                        TextSpan(
                          text: widget.title ?? '',
                          style: Styles.headerText(
                            fontWeight: FontWeight.w800,
                            fontSize: 40,
                          ),
                        ),
                      ]),
                    )
                  : Text.rich(
                      textAlign: TextAlign.center,
                      TextSpan(children: [
                        TextSpan(
                          text: widget.title ?? '',
                          style: Styles.headerText(
                            fontWeight: FontWeight.w800,
                            fontSize: 40,
                          ),
                        ),
                        const TextSpan(
                          text: "  ",
                        ),
                        TextSpan(
                          text: LocaleKeys.subscription.localize,
                          style: Styles.headerText(
                            fontWeight: FontWeight.w500,
                            fontSize: 30,
                          ),
                        ),
                      ]),
                    ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //
              //     Expanded(
              //       flex: 2,
              //       child: Label(
              //         text: widget.title ?? '',
              //         textAlign: TextAlign.center,
              //         style: Styles.headerText(
              //           fontWeight: FontWeight.w800,
              //           fontSize: 40,
              //         ),
              //         maxLines: 3,
              //       ),
              //     ),
              //     const SizedBox(
              //       width: 8,
              //     ),
              //     Expanded(
              //       child: Label(
              //         text: LocaleKeys.subscription.localize,
              //         style: Styles.headerText(
              //           fontWeight: FontWeight.w500,
              //           fontSize: 30,
              //         ),
              //       ),
              //     ),
              //
              //   ],
              // ),
              const SizedBox(height: 8),
              // DropdownButtonHideUnderline(
              //   child: DropdownMenu<WalletTypes>(
              //       inputDecorationTheme: InputDecorationTheme(
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(15),
              //         ),
              //         focusedErrorBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(15),
              //         ),
              //         errorBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(15),
              //         ),
              //         disabledBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(15),
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(15),
              //         ),
              //         enabledBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(15),
              //         ),
              //       ),
              //       hintText: "Select Wallet",
              //       expandedInsets: const EdgeInsets.only(),
              //       dropdownMenuEntries: widget.paymentMenthods!
              //           .map((e) => DropdownMenuEntry<WalletTypes>(
              //               value: e, label: e.translatedName))
              //           .toList(),
              //       textStyle: Styles.mediumText(fontWeight: FontWeight.w600),
              //       initialSelection: selectedWallet,
              //       // inputDecorationTheme: ,
              //       onSelected: (value) {
              //         selectedWallet = value;
              //         print(selectedWallet);
              //         setState(() {});
              //         // context.read<WalletCubit>().onSelectWallet(value!);
              //       }),
              // ),
              Row(
                children: widget.paymentMenthods!
                    .map((e) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: CardWalletTypeWidget(
                              title: e.translatedName,
                              isSelected: e == selectedWallet,
                              onTap: () {
                                selectedWallet = e;
                                setState(() {});
                              },
                            ),
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  if (widget.showRegular!)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isPremium = false),
                        child: Container(
                          height: 32,
                          // padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: !_isPremium
                                ? (context.isDarkMode
                                    ? const Color(0xffCACFF4)
                                    : AppColors.PRIMARY_COLOR)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey, width: 1),
                          ),
                          child: Center(
                            child: Label(
                              text: LocaleKeys.regular.localize,
                              textAlign: TextAlign.center,
                              style: Styles.headerText(
                                fontSize: 28,
                                color: !_isPremium
                                    ? (context.isDarkMode
                                        ? const Color(0xff0D0D0D)
                                        : AppColors.AUTH_CONTAINER_COLOR)
                                    : Theme.of(context).primaryColor,
                              ),
                              // TextStyle(
                              //   color: !_isPremium
                              //       ? AppColors.AUTH_CONTAINER_COLOR
                              //       : Theme.of(context).primaryColor,
                              //   fontWeight: FontWeight.bold,
                              // ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isPremium = true),
                      child: Container(
                        height: 32,
                        // padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: _isPremium
                              ? (context.isDarkMode
                                  ? const Color(0xffF45560)
                                  : AppColors.SECONDARY_COLOR_DARK2)
                              : Colors.transparent,
                          // : Colors.red,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Center(
                          child: Label(
                            text: LocaleKeys.premium.localize,
                            textAlign: TextAlign.center,
                            style: Styles.headerText(
                              fontSize: 28,
                              color: _isPremium
                                  ? (context.isDarkMode
                                      ? const Color(0xff0D0D0D)
                                      : AppColors.AUTH_CONTAINER_COLOR)
                                  : Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildList(),
              const SizedBox(height: 10),
              AppInfoText(
                text: LocaleKeys.premiumPackage.localize,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ElevatedAppButton(
                      label: LocaleKeys.confirm.localize,
                      radius: 15,
                      backColor: context.isDarkMode
                          ? const Color(0xFFCACFF4)
                          : const Color(0xff0B1035),
                      textStyle: Styles.mediumText(
                        fontWeight: FontWeight.w500,
                        fontSize: 36,
                        color: context.isDarkMode
                            ? const Color(0xFF0D0D0D)
                            : Colors.white,
                      ),
                      onPressed: () async {
                        List<num> list = _isPremium
                            ? widget.subscribePlans.premiumPlans
                            : widget.subscribePlans.regularPlans;

                        // Days corresponding to plans (must match the premium/regular plans)
                        final List<int> days = [1, 7, 30, 365];

                        // Find the index of the selected day value (_groupValue)
                        final selectedIndex = days.indexOf(_groupValue);

                        if (selectedIndex != -1 &&
                            selectedIndex < list.length) {
                          final selectedPlanPrice = list[selectedIndex];
                          print('selectedWallet $selectedWallet');
                          final walletPrice =
                              selectedWallet?.name == 'mainWallet'
                                  ? state.wallet?.realAmount ?? 0
                                  : selectedWallet?.name == 'balance'
                                      ? state.wallet?.balance ?? 0
                                      : state.wallet?.giftWallet ?? 0;
                          // final walletPrice = state.wallet?.realAmount ?? 0;
                          print(walletPrice);
                          print(
                              "state.wallet?.giftWallet${state.wallet?.giftWallet}");
                          print(state.wallet?.realAmount);
                          print(state.wallet?.balance);
                          print(walletPrice);
                          print(selectedPlanPrice);
                          print(_groupValue);

                          if (selectedPlanPrice < walletPrice) {
                            // print('selectedWallet${selectedWallet!.name}');
                            print('selectedWallet mainWallet');
                            showLoadingDialog(context);
                            await context.read<WalletCubit>().addSubscription(
                                  params: AddSubscriptionParams(
                                    subCategoryId: widget.subCategoryId,
                                    paymentMethod: selectedWallet!.name,
                                    // paymentMethod: 'mainWallet',
                                    isPremium: _isPremium,
                                    period: _groupValue,
                                    periodType: 'days',
                                  ),
                                );
                            if (context.mounted) {
                              widget.onSubscribe != null
                                  ? widget.onSubscribe!()
                                  : context.push(Routes.HOME);

                              // context.pushReplacement(Routes.HOME);
                              context
                                  .read<MainCategoriesCubit>()
                                  .loadDataCategory();
                              // context.read<MainCategoriesCubit>().getMainCategoryCustomPage();
                              // Phoenix.rebirth(context);
                            }
                            // context.pop();
                          } else {
                            await serviceLocator<SubscriptionController>()
                                .subscribe(
                              subscribeParams: SubscribeParams(
                                subCategoryId: widget.subCategoryId,
                                isPremium: _isPremium,
                                // walletType: selectedWallet!,
                                walletType: WalletTypes.mainWallet,
                                days: _groupValue,
                              ),
                            );
                          }
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ElevatedAppButton(
                      label: LocaleKeys.cancel.localize,
                      backColor: context.isDarkMode
                          ? const Color(0xff333333)
                          : const Color(0xffD9D9D9),
                      radius: 15,
                      textStyle: Styles.mediumText(
                        fontWeight: FontWeight.w500,
                        fontSize: 36,
                      ),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                ],
              ),

              // ElevatedAppButton(
              //   label: LocaleKeys.confirm.localize,
              //   textStyle:
              //       Styles.mediumText(color: AppColors.AUTH_CONTAINER_COLOR),
              //   onPressed: () async {
              //     List<num> list = _isPremium
              //         ? widget.subscribePlans.premiumPlans
              //         : widget.subscribePlans.regularPlans;

              //     // Days corresponding to plans (must match the premium/regular plans)
              //     final List<int> days = [1, 7, 30, 365];

              //     // Find the index of the selected day value (_groupValue)
              //     final selectedIndex = days.indexOf(_groupValue);

              //     if (selectedIndex != -1 && selectedIndex < list.length) {
              //       final selectedPlanPrice = list[selectedIndex];
              //       // print('selectedWallet $selectedWallet');
              //       // final walletPrice = selectedWallet?.name == 'mainWallet'
              //       //     ? state.wallet?.realAmount ?? 0
              //       //     : selectedWallet?.name == 'balance'
              //       //         ? state.wallet?.balance ?? 0
              //       //         : state.wallet?.giftWallet ?? 0;
              //       final walletPrice = state.wallet?.realAmount ?? 0;
              //       print(walletPrice);
              //       print(
              //           "state.wallet?.giftWallet${state.wallet?.giftWallet}");
              //       print(state.wallet?.realAmount);
              //       print(state.wallet?.balance);
              //       // print(walletPrice);
              //       // print(selectedPlanPrice);
              //       // print(_groupValue);

              //       if (selectedPlanPrice < walletPrice) {
              //         // print('selectedWallet${selectedWallet!.name}');
              //         print('selectedWallet mainWallet');
              //         showLoadingDialog(context);
              //         await context.read<WalletCubit>().addSubscription(
              //               params: AddSubscriptionParams(
              //                 subCategoryId: widget.subCategoryId,
              //                 // paymentMethod: selectedWallet!.name,
              //                 paymentMethod: 'mainWallet',
              //                 isPremium: _isPremium,
              //                 period: _groupValue,
              //                 periodType: 'days',
              //               ),
              //             );
              //         if (context.mounted) {
              //           context.push(Routes.HOME);
              //           // context.pushReplacement(Routes.HOME);
              //           context.read<MainCategoriesCubit>().loadDataCategory();
              //           // context.read<MainCategoriesCubit>().getMainCategoryCustomPage();
              //           // Phoenix.rebirth(context);
              //         }
              //         // context.pop();
              //       } else {
              //         await serviceLocator<SubscriptionController>().subscribe(
              //           subscribeParams: SubscribeParams(
              //             subCategoryId: widget.subCategoryId,
              //             isPremium: _isPremium,
              //             // walletType: selectedWallet!,
              //             walletType: WalletTypes.mainWallet,
              //             days: _groupValue,
              //           ),
              //         );
              //       }
              //     }
              //     setState(() {});
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

  num getSelectedPlanPrice(List<num> list, int groupValue) {
    int index = groupValue - 1;
    if (index >= 0 && index < list.length) {
      return list[index];
    }
    return 0;
  }

  int _groupValue = 1;

  Widget _buildList() {
    List<num> list = _isPremium
        ? widget.subscribePlans.premiumPlans
        : widget.subscribePlans.regularPlans;

    if (list.isEmpty) {
      return Text(LocaleKeys.noSubscriptionPlans.localize);
    }

    final List<int> days = [1, 7, 30, 365];

    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 4,
      children: [
        for (int i = 0; i < days.length; i++)
          _pricingItem(
              period: getPeriodLabel(days[i]), price: list[i], value: days[i]),
      ],
    );
  }

  String getPeriodLabel(int days) {
    switch (days) {
      case 1:
        return LocaleKeys.daily.localize;
      case 7:
        return LocaleKeys.weekly.localize;
      case 30:
        return LocaleKeys.monthly.localize;
      case 365:
        return LocaleKeys.yearly.localize;
      default:
        return 'Unknown';
    }
  }

  Widget _pricingItem({
    required String period,
    required num price,
    required int value,
  }) {
    return SizedBox(
      height: 32,
      // padding: EdgeInsets.zero,
      child: Row(
        children: [
          Radio<int>(
            value: value,
            groupValue: _groupValue,
            activeColor: context.isDarkMode
                ? const Color(0xffD6DADE)
                : const Color(0xff212529),
            onChanged: (v) {
              setState(() => _groupValue = v!);
            },
          ),
          Expanded(
            child: ElevatedAppButton(
              label: period,
              onPressed: () {},
              backColor: _isPremium
                  ? (context.isDarkMode
                      ? const Color(0xffF45560)
                      : AppColors.SECONDARY_COLOR_DARK2)
                  : (context.isDarkMode
                      ? const Color(0xffCACFF4)
                      : AppColors.PRIMARY_COLOR),
              textStyle: Styles.mediumText(
                color: context.isDarkMode
                    ? const Color(0xff0D0D0D)
                    : AppColors.AUTH_CONTAINER_COLOR,
                // color: _isPremium
                //     ? AppColors.AUTH_CONTAINER_COLOR
                //     : AppColors.AUTH_CONTAINER_COLOR,
              ),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            child: ElevatedAppButton(
              label: '$price',
              onPressed: () {},
              backColor: _isPremium
                  ? (context.isDarkMode
                      ? const Color(0xffF45560)
                      : AppColors.SECONDARY_COLOR_DARK2)
                  : (context.isDarkMode
                      ? const Color(0xffCACFF4)
                      : AppColors.PRIMARY_COLOR),
              textStyle: Styles.mediumText(
                color: context.isDarkMode
                    ? const Color(0xff0D0D0D)
                    : AppColors.AUTH_CONTAINER_COLOR,
                // color: _isPremium
                //     ? AppColors.AUTH_CONTAINER_COLOR
                //     : AppColors.AUTH_CONTAINER_COLOR,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardWalletTypeWidget extends StatelessWidget {
  const CardWalletTypeWidget({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final bool isSelected;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7,
        ),
        decoration: ShapeDecoration(
          color: isSelected
              ? (context.isDarkMode
                  ? const Color(0xFF323232)
                  : const Color(0xffD9D9D9))
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        child: Center(
          child: Label(
            text: title,
            style: Styles.headerText(
              fontSize: 32,
            ),
          ),
        ),
      ),
    );
  }
}
