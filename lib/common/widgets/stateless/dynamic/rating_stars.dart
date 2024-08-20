import 'package:flutter/material.dart';

import '../../../../res/style/app_colors.dart';

class RatingStars extends StatelessWidget {
  final num rating;
  final int maxRating;
  final double iconSize;
  final Color? color;

  const RatingStars(
      {super.key,
      required this.rating,
      this.maxRating = 5,
      this.color,
      this.iconSize = 14});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kToolbarHeight * .4,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) => Icon(
          Icons.star,
          size: iconSize,
          color: rating > (index)
              ? color ?? AppColors.PRIMARY_COLOR
              : AppColors.GREY_DARK_COLOR,
        ),
        itemCount: maxRating,
      ),
    );
  }
}
