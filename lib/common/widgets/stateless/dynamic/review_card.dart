import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/driver_review_entity.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/const.dart';
import '../../../../res/style/styles.dart';
import '../../dynamic/sizer.dart';
import '../images/profile_image.dart';
import '../labels/read_more_label.dart';
import '../labels/label.dart';
import 'rating_stars.dart';

class ReviewCard extends StatelessWidget {
  final ReviewEntity review;
  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ProfileImage(
              userId: '',
              
              accountId: 0,
              imageURL: review.image ?? UIConst.profilePlaceHolder,
            ),
            Sizer(),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(text: review.name, style: Styles.mediumText()),
                RatingStars(
                  rating: review.rate,
                  color: AppColors.ACCENT_COLOR,
                ),
              ],
            )),
          ],
        ),
        ReadMoreLabel(text: review.comment),
        Label(
            text: review.createdAt,
            style: Styles.mediumText(fontWeight: FontWeight.w400)),
      ],
    );
  }
}
