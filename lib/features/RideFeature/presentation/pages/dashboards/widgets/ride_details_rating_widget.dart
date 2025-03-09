import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../res/style/app_colors.dart';

class RideDetailsRatingWidget extends StatelessWidget {
  final bool isRate;
  final double rate;
  final String title;
  const RideDetailsRatingWidget(
      {super.key,
      required this.isRate,
      required this.rate,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Label(
            text: title, //LocaleKeys.noRating.localize,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        const Spacer(),
        if (isRate) ...[
           Text(LocaleKeys.good.tr(),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
          const SizedBox(width: 5),
          RatingBar(
            initialRating: rate,
            ignoreGestures: true,
            itemPadding: const EdgeInsets.symmetric(horizontal: 3),
            ratingWidget: RatingWidget(
              full: SvgPicture.asset(Assets.star1),
              half: SvgPicture.asset(Assets.star1),
              empty: SvgPicture.asset(Assets.starEmpty),
            ),
            itemSize: 13,
            onRatingUpdate: (double value) {},
          ),
        ] else
          noRateWidget(),
      ],
    );
  }

  Widget noRateWidget() => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.cF3F3F3,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Label(
          text: LocaleKeys.noRating.localize,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}
