import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/controllers/doctors_list_cubit/doctors_list_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/ReadMoreLabel.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/stateless/dynamic/rating_stars.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class DoctorCard extends StatelessWidget {
  final DoctorEntity doctor;
  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final hasSubscription = context.read<DoctorsListCubit>().hasSubscription;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.LIGHT_COLOR,
          border: Border.all(color: AppColors.LIGHT_GRAY_COLOR),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileImage(
                accountId: 0,
                size: 25,
                imageURL: doctor.image,
              ),
              const Sizer(),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doctor.fullName, style: Styles.mediumText()),
                      RatingStars(
                        rating: doctor.rating.toDouble(),
                      ),
                    ],
                  ),
                ],
              )),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                FontAwesomeIcons.userDoctor,
              ),
              const Sizer(),
              Expanded(
                  child: ReadMoreLabel(
                text: doctor.description,
                trimLines: 1,
              ))
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.attach_money_sharp,
              ),
              const Sizer(),
              Expanded(
                child: Label(
                  text: '${Labels.fees}: ${doctor.priceToShow}',
                  style: Styles.mediumText(),
                ),
              )
            ],
          ),
          _buildWaitingTime,
          const Sizer(),
          Row(
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
              const Sizer(),
              Expanded(
                child: AppButton(
                  label: Labels.report,
                  icon: Icons.report,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const Sizer(),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: '${Labels.premium} ${Labels.book}',
                  backColor: AppColors.ACCENT_COLOR,
                  onPressed: () {
                    if (hasSubscription) {
                      context.push(Routes.VISITADOCTORDETAILS, extra: doctor);
                    }
                  },
                ),
              ),
              const Sizer(),
              Expanded(
                child: AppButton(
                  label: Labels.book,
                  backColor: AppColors.PRIMARY_COLOR,
                  onPressed: () {
                    context.push(Routes.VISITADOCTORDETAILS, extra: doctor);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget get _buildWaitingTime {
    if (serviceLocator<HealthSharedData>().doctorSearchParams.bookingType ==
        BookingTypes.clinic) {
      return Row(
        children: [
          const Icon(
            Icons.timer,
          ),
          const Sizer(),
          Expanded(
            child: Label(
              text:
                  '${Labels.waitingTime}: ${doctor.waitingTime} ${Labels.minutes}',
              style: Styles.mediumText(),
            ),
          )
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
