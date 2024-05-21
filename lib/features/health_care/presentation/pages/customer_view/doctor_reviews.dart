import 'package:flutter/material.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/back_appbar.dart';
import '../../../../../common/widgets/stateless/dynamic/rating_stars.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';

import '../../../../../common/widgets/stateless/dynamic/review_card.dart';
import '../../../../../res/style/app_colors.dart';

class DoctorReviews extends StatelessWidget {
  const DoctorReviews({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: 'Visitors Reviews',
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child:
                      _buildOverReviewsWidget(rate: 4, label: 'Doctor Rating')),
              const Sizer(),
              Expanded(
                  child: _buildOverReviewsWidget(
                      rate: 3, label: 'Overall Rating')),
            ],
          ),
          const Sizer(),
          Expanded(
            child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => const ReviewCard(),
                separatorBuilder: (context, index) => const Divider(
                      color: Colors.grey,
                    ),
                itemCount: 3),
          ),
        ],
      ),
    );
  }

  Widget _buildOverReviewsWidget({
    required int rate,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          RatingStars(
            rating: rate,
            iconSize: 20,
            color: AppColors.ACCENT_COLOR,
          ),
          const Sizer(),
          Label(
              text: label,
              style: Styles.mediumText(fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
