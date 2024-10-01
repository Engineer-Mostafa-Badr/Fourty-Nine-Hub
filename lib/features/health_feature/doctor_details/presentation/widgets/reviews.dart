import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/divider.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/rate_card.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorDetailsReviewsWidget extends StatelessWidget {
  const DoctorDetailsReviewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500.h,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Labels.patientsReviews,
              style: Styles.headerText(),
            ),
            const Sizer(),
            BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
              buildWhen: (previous, current) =>
                  current is DoctorDetailsReviewsLoaded ||
                  current is DoctorDetailsInitial,
              builder: (context, state) {
                switch (state) {
                  case DoctorDetailsReviewsLoaded _:
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.rates.length,
                      separatorBuilder: (context, index) =>
                          const DoctorDetailsDivider(),
                      itemBuilder: (context, index) =>
                          UserDoctorRateCard(rate: state.rates[index]),
                    );

                  default:
                    return const Center(child: Text(Labels.noReviews));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
