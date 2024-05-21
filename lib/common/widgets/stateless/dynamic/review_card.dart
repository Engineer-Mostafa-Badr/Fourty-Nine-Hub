import 'package:flutter/material.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/const.dart';
import '../../../../res/style/styles.dart';
import '../../dynamic/sizer.dart';
import '../images/profile_image.dart';
import '../labels/ReadMoreLabel.dart';
import '../labels/label.dart';
import 'rating_stars.dart';

class ReviewCard extends StatelessWidget {
  const ReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const ProfileImage(accountId: 0),
            const Sizer(),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(text: 'Farouk Shahin', style: Styles.mediumText()),
                const RatingStars(
                  rating: 5,
                  color: AppColors.ACCENT_COLOR,
                ),
              ],
            )),
          ],
        ),
        const ReadMoreLabel(text: UIConst.placeholderText),
        Label(
            text: '02 March 2024, 3:15 pm',
            style: Styles.mediumText(fontWeight: FontWeight.w400)),
      ],
    );
  }
}
