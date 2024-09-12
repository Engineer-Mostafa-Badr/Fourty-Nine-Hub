import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/cubit/wallet_cubit.dart';
import 'package:fourtyninehub/features/subscripe/domain/usecases/subscribe_usecase.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
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

  const SubscriptionPlansWidget({
    super.key,
    this.paymentMenthods,
    required this.subscribePlans,
    required this.subCategoryId,
    this.title,
  });

  @override
  State<SubscriptionPlansWidget> createState() =>
      _SubscriptionPlansWidgetState();
}

class _SubscriptionPlansWidgetState extends State<SubscriptionPlansWidget> {
  bool _isPremium = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WalletCubit, WalletState>(
      builder: (BuildContext context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Text(
                widget.title ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.PRIMARY_COLOR_LIGHT,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              // const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _isPremium = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
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
                            color:!_isPremium? AppColors.AUTH_CONTAINER_COLOR : Theme.of(context).primaryColor,

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
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _isPremium
                              ? Colors.red
                              : Colors.transparent,
                          // : Colors.red,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child:  Text(
                          LocaleKeys.premium.localize,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:_isPremium? AppColors.AUTH_CONTAINER_COLOR : Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildList(),
              const SizedBox(height: 20),
               AppInfoText(
                  text: LocaleKeys.premiumPackage.localize,
                      ),
              ElevatedAppButton(
                label: LocaleKeys.confirm.localize,
                textStyle: Styles.mediumText(color: AppColors.AUTH_CONTAINER_COLOR),
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
                    final walletPrice = state.wallet?.realAmount ?? 0;

                    // print(walletPrice);
                    // print(selectedPlanPrice);
                    // print(_groupValue);

                    if (selectedPlanPrice <= walletPrice) {
                      showLoadingDialog(context);
                      await context.read<WalletCubit>().addSubscription(
                            params: AddSubscriptionParams(
                              subCategoryId: widget.subCategoryId,
                              paymentMethod: 'mainWallet',
                              isPremium: _isPremium,
                              period: _groupValue,
                              periodType: 'days',
                            ),
                          );
                      if (context.mounted) {
                        context.pop();
                      }
                      context.pop();
                    } else {
                      await serviceLocator<SubscriptionController>().subscribe(
                        subscribeParams: SubscribeParams(
                          subCategoryId: widget.subCategoryId,
                          isPremium: _isPremium,
                          walletType: WalletTypes.mainWallet,
                          days: _groupValue,
                        ),
                      );
                    }
                  }
                  setState(() {

                  });
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
      return  Text(LocaleKeys.noSubscriptionPlans.localize);
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
          ),),
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
