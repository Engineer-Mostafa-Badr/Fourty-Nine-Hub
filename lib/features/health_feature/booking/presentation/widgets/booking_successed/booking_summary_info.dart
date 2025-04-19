import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../doctor_details/domain/entities/doctor_entity.dart';
import '../../cubit/book_doctor_appointment_cubit.dart';
import '../booking_confirmation/custom_booking_info_row.dart';

class BookingSummaryInfo extends StatelessWidget {
  final DoctorEntity doctor;

  const BookingSummaryInfo({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final doctor = context.read<BookDoctorAppointmentCubit>().doctor;
    final bookingController = context.read<BookDoctorAppointmentCubit>();
    return Column(
      children: [
        /// Time Row
        CustomBookingInfoRow(
          context: context,
          icon: Icons.calendar_today_outlined,
          title:
              "${bookingController.appointment.startTime} : ${bookingController.appointment.endTime}",
          bgColor: AppColors.whiteColor,
          isBordered: true,
        ),

        const Sizer(height: 12),

        /// Location
        CustomBookingInfoRow(
          context: context,
          icon: Icons.location_pin,
          title: "${bookingController.doctor.address.address} ",
          bgColor: AppColors.whiteColor,
          isBordered: true,
        ),

        const Sizer(height: 12),

        /// Payment Row
        CustomBookingInfoRow(
          context: context,
          icon: Icons.attach_money,
          title:
              "${bookingController.doctor.priceToShow} ${LocaleKeys.egp.localize}   ${bookingController.appointment.appointmentType}",
          bgColor: AppColors.whiteColor,
          isBordered: true,
          fees: "${doctor.clinicPrice}",
        ),
      ],
    );
  }
}
