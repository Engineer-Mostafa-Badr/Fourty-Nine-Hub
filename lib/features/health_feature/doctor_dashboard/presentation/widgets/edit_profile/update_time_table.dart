import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_card.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

class UpdateDoctorTimetableCard extends StatelessWidget {
  const UpdateDoctorTimetableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const EditDoctorProfileCard(
      title: Labels.timetable,
    );
  }
}
