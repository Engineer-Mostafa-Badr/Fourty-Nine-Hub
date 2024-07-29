import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/divider.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/rate_card.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorDetailsReviewsWidget extends StatelessWidget {
  const DoctorDetailsReviewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Labels.patientsReviews,
              style: Styles.headerText(),
            ),
            BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
              builder: (context, state) {
                switch (state) {
                  case DoctorDetailsLoaded _:
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.rates.length,
                      separatorBuilder: (context, index) =>
                          const DoctorDetailsDivider(),
                      itemBuilder: (context, index) =>
                          UserDoctorRateCard(rate: state.rates[index]),
                    );
                  case DoctorDetailsError _:
                    return Center(child: Text(state.message));

                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
