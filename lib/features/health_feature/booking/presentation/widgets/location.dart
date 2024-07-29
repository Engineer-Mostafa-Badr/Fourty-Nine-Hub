import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/cubit/book_doctor_appointment_cubit.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/widgets/info.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class BookDoctorAppointmentLocationInfoCard extends StatelessWidget {
  const BookDoctorAppointmentLocationInfoCard({super.key});

  @override
  Widget build(BuildContext context) {

    return BookDoctorAppointmentCardInfo(
        widget: Label(
            text: context.read<BookDoctorAppointmentCubit>().doctor.address.address,
            style: Styles.mediumText()),
        icon: Icons.location_on,
        height: kToolbarHeight);
  }
}
