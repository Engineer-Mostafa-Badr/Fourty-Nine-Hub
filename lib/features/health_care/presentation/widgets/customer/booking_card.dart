import 'package:flutter/material.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';

class VisitaBookingCard extends StatelessWidget {
  const VisitaBookingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.VISITADOCTORDETAILS),
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
                  text: 'Clinic Booking: 10 May 2024 , 06:30 PM',
                  style: Styles.mediumText()),
            ),
            const Divider(
              color: Colors.grey,
            ),
            Row(
              children: [
                const ProfileImage(
                  accountId: 0,
                  size: 24,
                ),
                const Sizer(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(
                          text: 'Dr. Karim Khalil', style: Styles.mediumText()),
                      Label(
                          text: 'Dentist',
                          style: Styles.mediumText(color: Colors.grey)),
                      Label(
                          text:
                              'Address Address , St. Street address address St. Street address',
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
                        onPressed: () {})),
                const Sizer(),
                Expanded(
                    child: AppButton(
                        icon: Icons.edit, label: 'Edit', onPressed: () {})),
                const Sizer(),
                Expanded(
                    child: AppButton(
                        icon: Icons.support_agent,
                        label: 'Support',
                        onPressed: () {})),
              ],
            )
          ],
        ),
      ),
    );
  }
}
