import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/doctor_review_card.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/widgets/stateless/dynamic/rating_stars.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/styles.dart';

import '../../../../../res/style/app_colors.dart';

class AllReviews extends StatelessWidget {
  const AllReviews({super.key, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: Labels.reviews,
        backColor: cardDarkColor(context),
      ),
      body: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
          buildWhen: (previous, current) =>
          current is DoctorDetailsReviewsLoaded ,
        builder: (context,state) {

          if(state is DoctorDetailsStartLoading){
            return const Center(child: CircularProgressIndicator());
          }else if(state is DoctorDetailsReviewsLoaded){
            return ListView.separated(
                itemBuilder: (context, index) => DoctorReviewCard(
                  review: state.rates[index],
                ),
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey,
                ),
                itemCount: state.rates.length);
          }else{
            return Container();
          }
        }
      ),
    );
  }

  Widget _buildOverReviewsWidget({
    required int rate,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
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
