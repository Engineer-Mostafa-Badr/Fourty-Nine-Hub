import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/cubit/book_doctor_appointment_cubit.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class BookingDoctorProfileWidget extends StatelessWidget {
  const BookingDoctorProfileWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final doctor = context.read<BookDoctorAppointmentCubit>().doctor;
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileImage(
            accountId: 0,
            size: 50,
            imageURL: doctor.image,
          ),
          const Sizer(height: 16),
          Text(
            '${Labels.doctor} ${doctor.fullName}',
            style: Styles.headerText(),
          ),
          const Sizer(height: 8),
          Text(
            doctor.description,
            overflow: TextOverflow.fade,
            maxLines: 2,
            softWrap: false,
            style: Styles.smallText(),
          ),
        ],
      ),
    );
  }
}
