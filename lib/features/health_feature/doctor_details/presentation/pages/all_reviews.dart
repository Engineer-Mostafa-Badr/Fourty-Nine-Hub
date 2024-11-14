import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/widgets/stateless/dynamic/rating_stars.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../res/style/styles.dart';

import '../../../../../common/widgets/stateless/dynamic/review_card.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../ride/RideRequest/domain/entity/driver_review_entity.dart';

class AllReviews extends StatelessWidget {
  const AllReviews({super.key, });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: Labels.reviews,
      ),
      body: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
          buildWhen: (previous, current) =>
          current is DoctorDetailsReviewsLoaded ,
        builder: (context,state) {

          if(state is DoctorDetailsStartLoading){
            return const Center(child: CircularProgressIndicator());
          }else if(state is DoctorDetailsReviewsLoaded){
            return ListView.separated(
                itemBuilder: (context, index) => ReviewCard(
                  review: ReviewEntity(id: '',comment: state.rates[index].comment,rate: state.rates[index].rate,createdAt: '',name: state.rates[index].userName),
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
