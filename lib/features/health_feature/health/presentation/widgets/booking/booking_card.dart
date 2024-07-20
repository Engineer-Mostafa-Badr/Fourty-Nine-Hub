import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/launch_url.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

class HealthBookingCard extends StatelessWidget {
  final AppointmentBookingEntity appointment;
  const HealthBookingCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.VISITADOCTORDETAILS,
          extra: appointment.doctor.id),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Label(
                  text:
                      'Clinic Booking: ${appointment.appointment.date} - ${appointment.appointment.fromTime}:${appointment.appointment.toTime}',
                  style: Styles.mediumText()),
            ),
            const Divider(
              color: Colors.grey,
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
                          text: appointment.doctor.name,
                          style: Styles.mediumText()),
                      Label(
                          text: appointment.doctor.bio,
                          style: Styles.mediumText(color: Colors.grey)),
                      Label(
                          text: appointment.doctor.address.address,
                          style: Styles.mediumText(color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
            const Sizer(),
            Row(
              children: [
                Expanded(
                    child: AppButton(
                        icon: Icons.location_on_rounded,
                        label: 'Map',
                        onPressed: () => LaunchURLHelper().openLocation(
                            lat: appointment.doctor.address.coordinates[0],
                            lng: appointment.doctor.address.coordinates[1]))),
                const Sizer(),
                Expanded(
                    child: AppButton(
                        icon: Icons.clear, label: 'Cancel', onPressed: () {})),
                const Sizer(),
                Expanded(
                    child: AppButton(
                        icon: Icons.support_agent,
                        label: 'Support',
                        onPressed: () => LaunchURLHelper()
                            .call(phone: appointment.doctor.phone))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
