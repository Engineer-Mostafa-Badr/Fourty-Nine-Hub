import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/format_numbers.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class LikedByWidget extends StatelessWidget {
  const LikedByWidget({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.others,
  });

  final String imageUrl;
  final String name;
  final int others;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 16,
        ),
        ImageFromInternet(
          image: imageUrl,
          height: 20,
          width: 20,
          isCircle: true,
        ),
        const SizedBox(
          width: 6,
        ),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${LocaleKeys.likedBy.localize} ',
                style: Styles.mediumText(
                  height: 1.29,
                ),
              ),
              TextSpan(
                text: name,
                style: Styles.mediumText(
                  fontWeight: FontWeight.w700,
                  height: 1.29,
                ),
              ),
              TextSpan(
                text:
                " ${LocaleKeys.and.localize} ${FormatNumbers().formatNumberByComma(context, others.toString())} ${LocaleKeys.others.localize}",
                style: Styles.mediumText(
                  height: 1.29,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}