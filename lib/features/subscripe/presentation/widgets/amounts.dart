import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/payment/presentation/pages/payment_view.dart';
import 'package:fourtyninehub/features/subscripe/domain/entities/subscription_amount_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class SubscriptoinAmountsWidget extends StatefulWidget {
  final WalletTypes walletType;
  final List<SubscriptionAmountEntity> amounts;

  const SubscriptoinAmountsWidget(
      {super.key, required this.amounts, required this.walletType});

  @override
  State<SubscriptoinAmountsWidget> createState() =>
      _SubscriptoinAmountsWidgetState();
}

class _SubscriptoinAmountsWidgetState extends State<SubscriptoinAmountsWidget> {
  num? groupValue;

  String newIndex = '';
  num newAmount = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          LocaleKeys.insufficientAmount.localize,
          style: Styles.headerText(color: Colors.red, fontSize: 40),
        ),
        const Sizer(),
        Text(
          LocaleKeys.selectAmountToCharge.localize,
          style: Styles.mediumText(),
        ),
        const Sizer(),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 0,
                childAspectRatio: 1 / 0.4),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: widget.amounts.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Radio(
                    value: widget.amounts[index].amount,
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value!;
                        print(widget.amounts[index].id);
                        newIndex = widget.amounts[index].id;
                        newAmount = widget.amounts[index].amount;
                        print("${widget.amounts[index].amount}");
                      });
                    },
                  ),
                  Expanded(
                      child: BadgedLabel(
                    label: widget.amounts[index].amount.toString(),
                    overFlow: TextOverflow.ellipsis,
                    max: 1,
                    padding: EdgeInsets.all(20.w),
                  ))
                ],
              );
            },
          ),
        ),
        const Sizer(),
        ElevatedAppButton(
          label: LocaleKeys.chargeNow.localize,
          onPressed: () {
            if (groupValue != null) {
              context.push(Routes.PAYMENT,
                  extra: PaymobLink(
                      amountId: newIndex,
                      // providerId: "667331f44fbaddc4357d612b",
                      amount: newAmount));
            }
          },
        ),
      ],
    );
  }
}
