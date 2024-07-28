import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
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
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/dynamic/rating_stars.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';

class DoctorCard extends StatelessWidget {
  final DoctorEntity doctor;
  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
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
                imageURL: doctor.photo,
              ),
              const Sizer(),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: doctor.fullName,
                            style:
                                Styles.mediumText(fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: doctor.description,
                            style: Styles.mediumText(color: Colors.grey)),
                      ])),
                      RatingStars(
                        rating: doctor.rating.toDouble(),
                      ),
                      
                    ],
                  ),
                ],
              )),
              Row(
                children: [
                  IconAppButton(
                    onPressed: () {},
                    isCircle: true,
                    backColor: AppColors.PRIMARY_COLOR,
                    color: Colors.white,
                    icon: Icons.call,
                  ),
                  const Sizer(),
                  IconAppButton(
                    onPressed: () {},
                    isCircle: true,
                    backColor: AppColors.PRIMARY_COLOR,
                    color: Colors.white,
                    icon: Icons.video_camera_front_outlined,
                  ),
                ],
              )
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
                  text:
                      '${Labels.price}: ${doctor.priceToShow} ${Labels.currency}',
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
                flex: 2,
                child: AppButton(
                  backColor: doctor.isActive
                      ? Colors.green
                      : AppColors.LIGHT_GRAY_COLOR,
                  textColor: doctor.isActive ? Colors.white : Colors.black,
                  label: Labels.availableTimes,
                  onPressed: () {},
                ),
              ),
              const Sizer(),
              Expanded(
                child: AppButton(
                  label: Labels.bookNow,
                  onPressed: () {
                    context.push(Routes.VISITADOCTORDETAILS, extra: doctor);
                  },
                ),
              ),
            ],
          )
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
