import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/cubit/book_doctor_appointment_cubit.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/widgets/info.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class BookDoctorAppointmentTimeCard extends StatelessWidget {
  const BookDoctorAppointmentTimeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appointment = context.read<BookDoctorAppointmentCubit>().appointment;
    return BookDoctorAppointmentCardInfo(
      icon: Icons.watch_later,
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appointment.day.localize,
            style: Styles.headerText(),
          ),
          Text(
            appointment.startTime,
            style: Styles.mediumText(),
          ),
        ],
      ),
      height: kToolbarHeight,
    );
  }
}
