import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/rating_stars.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/divider.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorDetailsAccountHeader extends StatelessWidget {
  const DoctorDetailsAccountHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorDetailsCubit = context.read<DoctorDetailsCubit>();
    final doctor = doctorDetailsCubit.doctor;
    return Column(
      children: [
        Row(
          children: [
            SquareImage(
              source: NetworkImage(
                doctor.image,
              ),
              radius: 10,
              height: kToolbarHeight * 1.5,
              width: kToolbarHeight * 1.5,
            ),
            const Sizer(),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                    text: '${doctor.firstName} ${doctor.lastName}',
                    style: Styles.mediumText(fontWeight: FontWeight.w500)),
                RatingStars(
                  rating: doctor.rating,
                  color: AppColors.ACCENT_COLOR,
                  iconSize: 18,
                ),
                // TextAppButton(
                //     label: ' ${doctor.numberOfReviews}',
                //     style: Styles.mediumText(color: AppColors.SECONDARY_COLOR),
                //     onPressed: () {
                //       bottomSheet(
                //           context: context,
                //           isScrollControlled: true,
                //           widget: AllReviews(
                //             reviews: doctor.reviews ?? [],
                //           ));
                //     }),
                Label(
                    text: doctor.description,
                    maxLines: 1,
                    style: Styles.mediumText()),
              ],
            ))
          ],
        ),
        const DoctorDetailsDivider(),
      ],
    );
  }
}
