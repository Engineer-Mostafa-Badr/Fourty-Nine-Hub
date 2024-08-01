import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/launch_url.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class HealthBookingCard extends StatelessWidget {
  final BookedAppointmentEntity appointment;
  const HealthBookingCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.VISITADOCTORDETAILS,
          extra: appointment.doctor.id),
      child: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: AppColors.SHADOW,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Label(
                  text:
                      '${appointment.bookingType.translatedName} ${Labels.booking}: ${appointment.day} - ${appointment.time}',
                  style: Styles.mediumText()),
            ),
            const Divider(
              color: AppColors.DARK_GRAY_COLOR,
            ),
            Row(
              children: [
                SquareImage(
                  radius: 10,
                  height: kToolbarHeight,
                  width: kToolbarHeight,
                  url: appointment.doctor.image,
                ),
                const Sizer(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(
                          text: appointment.doctor.fullName,
                          style: Styles.mediumText()),
                      Label(
                          text: appointment.doctor.description,
                          style: Styles.mediumText(
                              color: AppColors.DARK_GRAY_COLOR)),
                    ],
                  ),
                ),
              ],
            ),
            // const Sizer(),
            // Row(
            //   children: [
            //     // Expanded(
            //     //     child: AppButton(
            //     //         icon: Icons.location_on_rounded,
            //     //         label: 'Map',
            //     //         onPressed: () => LaunchURLHelper().openLocation(
            //     //             lat: appointment.doctor.address.coordinates[0],
            //     //             lng: appointment.doctor.address.coordinates[1]))),
            //     // const Sizer(),
            //     Expanded(
            //         child: AppButton(
            //             icon: Icons.clear, label: 'Cancel', onPressed: () {})),
            //     const Sizer(),
            //     Expanded(
            //         child: AppButton(
            //             icon: Icons.support_agent,
            //             label: 'Support',
            //             onPressed: () => LaunchURLHelper()
            //                 .call(phone: appointment.doctor.phone))),
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
