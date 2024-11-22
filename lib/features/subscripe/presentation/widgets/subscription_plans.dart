import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
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
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../res/style/styles.dart';
import '../../../account_taps/wallet/domain/usecases/add_subscribe_use_case.dart';
import '../../domain/entities/subscription_plans_entity.dart';

class SubscriptionPlansWidget extends StatefulWidget {
  final SubscriptionPlansEntity subscribePlans;
  final List<WalletTypes>? paymentMenthods;
  final String subCategoryId;
  final String? title;
  final bool? showRegular;

  const SubscriptionPlansWidget({
    super.key,
    this.paymentMenthods,
    required this.subscribePlans,
    required this.subCategoryId,
    this.title,
    this.showRegular,
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCategoriesCubit, MainCategoriesState>(
      builder: (BuildContext context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              SizedBox(height: 20.h),
              Text(
                widget.title ?? "",

                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 55.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),
              DropdownButtonHideUnderline(
                child: DropdownMenu<WalletTypes>(
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                    hintText: "Select Wallet",
                    expandedInsets: const EdgeInsets.only(),
                    dropdownMenuEntries: widget.paymentMenthods!
                        .map((e) => DropdownMenuEntry<WalletTypes>(
                            value: e, label: e.translatedName))
                        .toList(),
                    textStyle: Styles.mediumText(fontWeight: FontWeight.w600),
                    initialSelection: selectedWallet,
                    // inputDecorationTheme: ,
                    onSelected: (value) {
                      selectedWallet = value;
                      print(selectedWallet);
                      setState(() {});
                      // context.read<WalletCubit>().onSelectWallet(value!);
                    }),
              ),

              SizedBox(height: 20.h),
              // SizedBox(height: 20.h),
              Row(
                children: [
                  if (widget.showRegular!)
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isPremium = false),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            color: !_isPremium
                                ? AppColors.PRIMARY_COLOR
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text(
                            LocaleKeys.regular.localize,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: !_isPremium
                                  ? AppColors.AUTH_CONTAINER_COLOR
                                  : Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isPremium = true),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: _isPremium ? Colors.red : Colors.transparent,
                          // : Colors.red,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          LocaleKeys.premium.localize,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: _isPremium
                                ? AppColors.AUTH_CONTAINER_COLOR
                                : Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              _buildList(),
              SizedBox(height: 20.h),
              AppInfoText(
                text: LocaleKeys.premiumPackage.localize,
              ),
              ElevatedAppButton(
                label: LocaleKeys.confirm.localize,
                textStyle:
                    Styles.mediumText(color: AppColors.AUTH_CONTAINER_COLOR),
                onPressed: () async {
                  List<num> list = _isPremium
                      ? widget.subscribePlans.premiumPlans
                      : widget.subscribePlans.regularPlans;

                  // Days corresponding to plans (must match the premium/regular plans)
                  final List<int> days = [1, 7, 30, 365];

                  // Find the index of the selected day value (_groupValue)
                  final selectedIndex = days.indexOf(_groupValue);

                  if (selectedIndex != -1 && selectedIndex < list.length) {
                    final selectedPlanPrice = list[selectedIndex];
                    print('selectedWallet$selectedWallet');
                    final walletPrice = selectedWallet?.name == 'mainWallet'
                        ? state.wallet?.realAmount ?? 0
                        : selectedWallet?.name == 'balance'
                            ? state.wallet?.balance ?? 0
                            : state.wallet?.giftWallet ?? 0;
                    print(walletPrice);
                    print("state.wallet?.giftWallet${state.wallet?.giftWallet}");
                    print(state.wallet?.realAmount);
                    print(state.wallet?.balance);
                    // print(walletPrice);
                    // print(selectedPlanPrice);
                    // print(_groupValue);

                    if (selectedPlanPrice < walletPrice) {
                      print('selectedWallet${selectedWallet!.name}');
                      showLoadingDialog(context);
                      await context.read<WalletCubit>().addSubscription(
                            params: AddSubscriptionParams(
                              subCategoryId: widget.subCategoryId,
                              paymentMethod: selectedWallet!.name,
                              isPremium: _isPremium,
                              period: _groupValue,
                              periodType: 'days',
                            ),
                          );
                      if (context.mounted) {
                        context.push(Routes.HOME);
                        // context.pushReplacement(Routes.HOME);
                        context.read<MainCategoriesCubit>().loadData();
                        // Phoenix.rebirth(context);
                      }
                      // context.pop();
                    } else {
                      await serviceLocator<SubscriptionController>().subscribe(
                        subscribeParams: SubscribeParams(
                          subCategoryId: widget.subCategoryId,
                          isPremium: _isPremium,
                          walletType: selectedWallet!,
                          days: _groupValue,
                        ),
                      );
                    }
                  }
                  setState(() {});
                },
              ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Radio<int>(
            value: value,
            groupValue: _groupValue,
            onChanged: (v) {
              setState(() => _groupValue = v!);
            },
          ),
          Expanded(
            child: ElevatedAppButton(
              label: period,
              onPressed: () {},
              backColor: _isPremium ? Colors.red : AppColors.PRIMARY_COLOR,
              textStyle: Styles.mediumText(
                color: _isPremium
                    ? AppColors.AUTH_CONTAINER_COLOR
                    : AppColors.AUTH_CONTAINER_COLOR,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedAppButton(
              label: '$price',
              onPressed: () {},
              backColor: _isPremium ? Colors.red : AppColors.PRIMARY_COLOR,
              textStyle: Styles.mediumText(
                color: _isPremium
                    ? AppColors.AUTH_CONTAINER_COLOR
                    : AppColors.AUTH_CONTAINER_COLOR,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
