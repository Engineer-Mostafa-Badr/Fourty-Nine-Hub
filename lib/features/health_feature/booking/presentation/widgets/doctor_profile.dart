import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class BookingDoctorProfileWidget extends StatelessWidget {
  final DoctorEntity doctor;

  const BookingDoctorProfileWidget({
    super.key,
    required this.doctor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfileImage(
              accountId: 0,
              size: 50,
              imageURL: doctor.photo,
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
      ),
    );
  }
}
