import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/rating_stars.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/cubit/doctor_details_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/presentation/widgets/divider.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                  text:
                      '${toBeginningOfSentenceCase(doctor.firstName)} ${toBeginningOfSentenceCase(doctor.lastName)}',
                  style: Styles.mediumText(fontWeight: FontWeight.w500),
                ),
                RatingStars(
                  rating: doctor.rating,
                  color: AppColors.ACCENT_COLOR,
                  iconSize: 18,
                ),
                Label(
                    text: doctor.description,
                    maxLines: 1,
                    style: Styles.mediumText()),
                Sizer(
                  height: 30.h,
                ),
                BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
                  buildWhen: (previous, current) =>
                      current is DoctorDetailsCheckCallAndMessage ||
                      current is DoctorDetailsInitial,
                  builder: (context, state) {
                    if (state is DoctorDetailsCheckCallAndMessage &&
                        state.enabled) {
                      return Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              label: Labels.call,
                              icon: Icons.call,
                              backColor: AppColors.PRIMARY_COLOR,
                              onPressed: () {},
                            ),
                          ),
                          const Sizer(),
                          Expanded(
                            child: AppButton(
                              label: Labels.message,
                              icon: Icons.message,
                              backColor: AppColors.PRIMARY_COLOR,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              label: Labels.call,
                              icon: Icons.call,
                              backColor: AppColors.DARK_GRAY_COLOR,
                              onPressed: () {},
                            ),
                          ),
                          const Sizer(),
                          Expanded(
                            child: AppButton(
                              label: Labels.message,
                              icon: Icons.message,
                              backColor: AppColors.DARK_GRAY_COLOR,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
                Sizer(
                  height: 15.h,
                ),
                Row(
                  children: [
                    serviceLocator<HealthSharedData>()
                                .doctorSearchParams
                                .bookingType ==
                            BookingTypes.call
                        ? Expanded(
                            flex: 4,
                            child: AppButton(
                              label: Labels.onlineSession,
                              onPressed: () {




                              },
                            ),
                          )
                        : const Spacer(flex: 4),
                    const Sizer(),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          bottomSheet(
                              context: context,
                              widget: ReportView(
                                id: doctor.id,
                                categoryId: serviceLocator<HealthSharedData>()
                                    .doctorSearchParams
                                    .subCategory
                                    .id,
                              ));
                        },
                        child: const Icon(
                          Icons.report_gmailerrorred_rounded,
                          color: AppColors.SECONDARY_COLOR,
                          size: 30,
                        ),
                      ),
                    ),
                  ],
                ),
                const Sizer(),
              ],
            ))
          ],
        ),
        const DoctorDetailsDivider(),
      ],
    );
  }
}
