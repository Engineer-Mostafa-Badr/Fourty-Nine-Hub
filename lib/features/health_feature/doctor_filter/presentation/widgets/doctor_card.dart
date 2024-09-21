import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/read_more_label.dart';
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
    return InkWell(
      onTap: () {
        context.push(Routes.VISITADOCTORDETAILS, extra: doctor.id);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: AppColors.LIGHT_COLOR,
            border: Border.all(color: AppColors.LIGHT_GRAY_COLOR),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ProfileImage(
                        userId: '',
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
                              Text(
                                  toBeginningOfSentenceCase(doctor.fullName) ??
                                      '',
                                  style: Styles.mediumText()),
                              RatingStars(
                                rating: doctor.rating.toDouble(),
                              ),
                            ],
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 6.0),
                  decoration: BoxDecoration(
                    color: doctor.isPremium ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: doctor.isPremium ? Colors.amber : Colors.grey,
                      width: 2.0,
                    ),
                    boxShadow: doctor.isPremium
                        ? [
                            BoxShadow(
                              color: Colors.amber.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(
                                  0, 3), // changes position of shadow
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    doctor.isPremium ? "Premium" : "Regular",
                    style: TextStyle(
                      color: doctor.isPremium ? Colors.amber : Colors.grey,
                      fontWeight: doctor.isPremium
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 16.0,
                    ),
                  ),
                ),
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
          ],
        ),
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
