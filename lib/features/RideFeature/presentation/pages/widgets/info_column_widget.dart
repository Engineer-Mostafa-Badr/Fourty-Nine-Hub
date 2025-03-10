import 'package:flutter/material.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';

class PriceColumn extends StatelessWidget {
  final String title;
  final String date;
  final String price;

  const PriceColumn({
    super.key,
    required this.title,
    required this.date,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints:  BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.4),
          child: Label(
            text: title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Label(
          text: date,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Label(
          text: price,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.PRIMARY_COLOR,
          ),
        ),
      ],
    );
  }
}
