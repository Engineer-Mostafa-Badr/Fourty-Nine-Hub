import 'package:flutter/material.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/utils/format_numbers.dart';
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../../res/style/styles.dart';

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
                text: others == 0
                    ? ''
                    : " ${LocaleKeys.and.localize} ${FormatNumbers().formatNumberByComma(others.toString(), isArabic: context.isArabic)} ${LocaleKeys.others.localize}",
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
