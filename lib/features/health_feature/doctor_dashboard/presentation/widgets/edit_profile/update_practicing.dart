import 'package:flutter/cupertino.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_card.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class UpdateDoctorPracticingCirtificateCard extends StatelessWidget {
  const UpdateDoctorPracticingCirtificateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return EditDoctorProfileCard(
      title: Labels.practiceCertification,
      onTap: () {
        context.push(Routes.EDITDOCTORDOCS);
      },
    );
  }
}
