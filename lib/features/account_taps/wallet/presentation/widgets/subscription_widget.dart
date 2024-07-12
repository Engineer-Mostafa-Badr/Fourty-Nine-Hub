import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../res/style/styles.dart';

class SubscriptionWidget extends StatelessWidget {
  final String icon;
  final String label;
  final String expireDate;
  final bool isExpired;

  const SubscriptionWidget({
    super.key,
    required this.icon,
    required this.expireDate,
    required this.isExpired,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(height: 30, width: 30, child: Image.network(icon)),
        const Sizer(),
        Expanded(child: Label(text: label)),
        Label(
          text: expireDate,
          style:
              Styles.mediumText(color: isExpired ? Colors.red : Colors.green),
        )
      ],
    );
  }
}
