import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/features/subscripe/domain/entities/subscription_amount_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';

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
  num groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "You don't have in money in ${widget.walletType.translatedName}",
          style: Styles.headerText(),
        ),
        const Sizer(),
        Text(
          "select amount to charge",
          style: Styles.mediumText(),
        ),
        const Sizer(),
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
        const Sizer(),
        ElevatedAppButton(
          label: 'Charge Now',
          onPressed: () {},
        ),
      ],
    );
  }
}
