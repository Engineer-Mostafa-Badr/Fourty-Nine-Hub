import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
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
          "You don't have in money in ${widget.walletType.translatedName}",
          style: Styles.headerText(),
        ),
        Sizer(),
        Text(
          "select amount to charge",
          style: Styles.mediumText(),
        ),
        Sizer(),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
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
                        print("${widget.amounts[index].id}");
                        newIndex = widget.amounts[index].id;
                        newAmount = widget.amounts[index].amount;
                        print("${widget.amounts[index].amount}");
                      });
                    },
                  ),
                  ElevatedAppButton(
                      label: '${widget.amounts[index].amount}',
                      onPressed: () {}),
                ],
              );
            },
          ),
        ),
        Sizer(),
        ElevatedAppButton(
          label: 'Charge Now',
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
