import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/cubit/book_doctor_appointment_cubit.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/widgets/info.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class BookDoctorAppointmentPriceCard extends StatelessWidget {
  const BookDoctorAppointmentPriceCard({super.key});

  @override
  Widget build(BuildContext context) {
    final doctor = context.read<BookDoctorAppointmentCubit>().doctor;
    return BookDoctorAppointmentCardInfo(
        widget: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Label(text: Labels.price, style: Styles.mediumText()),
            Label(
                text: '${doctor.priceToShow} ${Labels.currency}',
                style: Styles.mediumText()),
          ],
        ),
        icon: Icons.attach_money,
        height: kToolbarHeight);
  }
}
