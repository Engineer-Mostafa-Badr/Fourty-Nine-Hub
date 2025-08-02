import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class PriceColumn extends StatelessWidget {
  final String startAddressTitle;
  final String date;
  final String price;

  const PriceColumn({
    super.key,
    required this.startAddressTitle,
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
            text: startAddressTitle,
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
        Row(
          spacing: 4,
          children: [
            Label(
              text: price,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: context.isDarkMode?Colors.white:AppColors.PRIMARY_COLOR,
              ),
            ),
            Label(
                text: LocaleKeys.egp.tr(),
                style: Styles.mediumText(
                    color: AppColors.SECONDARY_COLOR,
                    fontWeight: FontWeight.w700))
          ],
        ),

      ],
    );
  }
}

class PriceColumnNonSocket extends StatelessWidget {
  final String title;
  final String date;
  final String price;
  final String status;

  const PriceColumnNonSocket({
    super.key,
    required this.title,
    required this.date,
    required this.price,
    required this.status,
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
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                LocaleKeys.egp.tr(),
                style: Styles.mediumText(
                  color: AppColors.SECONDARY_COLOR,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                "- $status",
                style: Styles.mediumText(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),




      ],
    );
  }
}