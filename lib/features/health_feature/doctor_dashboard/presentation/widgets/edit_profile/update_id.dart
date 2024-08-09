import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_card.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class UpdateDoctorIdCard extends StatelessWidget {
  const UpdateDoctorIdCard({super.key});

  @override
  Widget build(BuildContext context) {
    return EditDoctorProfileCard(
      title: Labels.id,
      onTap: () {
        context.push(Routes.EDITDOCTORDOCS);
      },
    );
  }
}
