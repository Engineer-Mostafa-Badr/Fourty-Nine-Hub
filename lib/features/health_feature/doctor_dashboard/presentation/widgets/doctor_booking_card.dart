import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/are_you_sure.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/badged_label.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/res/style/const.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class DoctorBookingCard extends StatelessWidget {
  final AppointmentBookingEntity appointment;
  final Function(int) onAccept;
  final Function(int) onCancel;
  const DoctorBookingCard(
      {super.key,
      required this.appointment,
      required this.onAccept,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    'Clinic Booking: ${appointment.appointment.date} - ${appointment.appointment.fromTime} to ${appointment.appointment.toTime}',
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
                source: NetworkImage(
                    appointment.user?.image ?? UIConst.profilePlaceHolder),
              ),
              const Sizer(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                        text: appointment.user?.name ?? '',
                        style: Styles.mediumText()),
                    Label(
                        text: appointment.user?.phone ?? '',
                        style: Styles.mediumText(color: Colors.grey)),
                    const Sizer(),
                    BadgedLabel(label: appointment.bookingType.title)
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
                      icon: Icons.check,
                      label: 'Approve',
                      backColor: const Color.fromRGBO(76, 175, 80, 1),
                      onPressed: () => showAreYouSure(
                          title: 'Approve',
                          subTitle: 'Do you want to approve this request?',
                          action: () => onAccept(appointment.id),
                          context: context))),
              const Sizer(),
              Expanded(
                  child: AppButton(
                      icon: Icons.clear,
                      label: 'Cancel',
                      onPressed: () => showAreYouSure(
                          title: 'Cancel',
                          subTitle: 'Do you want to cancel this request?',
                          action: () => onCancel(appointment.id),
                          context: context))),
            ],
          )
        ],
      ),
    );
  }
}
