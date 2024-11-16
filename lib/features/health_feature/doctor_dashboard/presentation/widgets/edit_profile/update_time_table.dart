import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_card.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class UpdateDoctorTimetableCard extends StatelessWidget {
  const UpdateDoctorTimetableCard({super.key});

  @override
  Widget build(BuildContext context) {
    return EditDoctorProfileCard(
      title: Labels.timetable,
      onTap: (){
        context.push(Routes.EDITDOCTORTIMETABLE);
      },
    );
  }
}