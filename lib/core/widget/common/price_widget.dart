import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class PriceWidget extends StatelessWidget {
  const PriceWidget({super.key, required this.price, required this.currency});
  final num price;
  final String currency;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Label(
          text:
          '${FormatNumbers().formatNumberByComma(price.toString(), isArabic: context.isArabic)} ',
          style: Styles.headerText(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: context.isDarkMode
                  ? AppColors.whiteColor
                  : AppColors.PRIMARY_COLOR),
          maxLines: 1,
        ),
        Label(
          text:
          currency,
          style: Styles.headerText(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: context.isDarkMode
                  ? AppColors.whiteColor
                  : AppColors.SECONDARY_COLOR),
          maxLines: 1,
        ),
      ],
    );
  }
}
