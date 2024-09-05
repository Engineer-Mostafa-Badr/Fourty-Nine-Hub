import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/core/enums/wallet_types_enums.dart';
import 'package:fourtyninehub/features/subscripe/domain/entities/subscription_amount_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
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
  num groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Insufficient Amount",
          style: Styles.headerText(color: Colors.red, fontSize: 40),
        ),
        const Sizer(),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Select amount to charge",
            style: Styles.mediumText(),
          ),
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
        Row(
          children: [
            Flexible(
              child: AppButton(
                textColor: Colors.white,
                backColor: AppColors.PRIMARY_COLOR,
                color: Colors.white,
                label: 'Charge',
                onPressed: () {},
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
              child: AppButton(
                textColor: Colors.white,
                // backColor: AppColors.PRIMARY_COLOR,
                color: Colors.white,
                label: 'Cancel',
                onPressed: () {
                  context.pop();
                },
              ),
            )
          ],
        )
      ],
    );
  }
}
