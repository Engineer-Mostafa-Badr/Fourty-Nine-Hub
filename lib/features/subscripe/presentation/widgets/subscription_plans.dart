import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/wallet_widget.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/info_text.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/subscripe/domain/usecases/subscribe_usecase.dart';
import 'package:fourtyninehub/features/subscripe/presentation/controllers/subscription_controller.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

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
    required this.subCategoryId, this.title,
  });

  @override
  State<SubscriptionPlansWidget> createState() =>
      _SubscriptionPlansWidgetState();
}

class _SubscriptionPlansWidgetState extends State<SubscriptionPlansWidget> {
  bool _isPremium = true;
  int _groupValue = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16, right: 16),
      child: ListView(
        children: [
          // const SizedBox(height: 20),
          Align(
              child: Text(
            "Pckup Subscription",
            style: Styles.headerText(color: Colors.red, fontSize: 40),
          )),
          const SizedBox(height: 10),
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
                      Labels.regular,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: !_isPremium
                            ? Colors.white
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
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _isPremium
                          ? Colors.red
                          : Theme.of(context).primaryColor,
                          // : Colors.red,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      Labels.premium,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).scaffoldBackgroundColor,
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
          const AppInfoText(
              text:
                  'The Premium Package gives you the opportunity to be seen more and get more cashback.'),
          ElevatedAppButton(
            label: Labels.confirm,
            onPressed: () async {
              if (widget.paymentMenthods == null ||
                  widget.paymentMenthods!.isEmpty) {
                showLoadingDialog(context);
                await serviceLocator<SubscriptionController>().subscribe(
                  subscribeParams: SubscribeParams(
                    subCategoryId: widget.subCategoryId,
                    isPremium: _isPremium,
                    walletType: WalletTypes.mainWallet,
                    days: _groupValue,
                  ),
                );
                if (context.mounted) {
                  context.pop();
                }
              } else {
                bottomSheet(context: context, widget: const WalletWidget());
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    List<num> list = [];
    if (_isPremium) {
      list = widget.subscribePlans.premiumPlans;
    } else {
      list = widget.subscribePlans.regularPlans;
    }
    return Column(
      children: [
        _pricingItem(period: Labels.daily, price: list[0], value: 1),
        _pricingItem(period: Labels.weekly, price: list[1], value: 7),
        _pricingItem(period: Labels.monthly, price: list[2], value: 30),
        _pricingItem(period: Labels.yearly, price: list[3], value: 365),
      ],
    );
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
          Expanded(child: ElevatedAppButton(label: period, onPressed: () {},backColor: _isPremium ? Colors.red : AppColors.PRIMARY_COLOR,)),
          const SizedBox(width: 10),
          Expanded(child: ElevatedAppButton(label: '$price', onPressed: () {},backColor: _isPremium ? Colors.red : AppColors.PRIMARY_COLOR,)),
        ],
      ),
    );
  }
}
