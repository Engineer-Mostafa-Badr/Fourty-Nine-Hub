import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/usecases/update_doctor_id_usecase.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_profile/edit_doctor_profile_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/pages/edit_doctor_docs.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_card.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

class UpdateDoctorPracticingCirtificateCard extends StatelessWidget {
  const UpdateDoctorPracticingCirtificateCard({super.key});

  @override
  Widget build(BuildContext context) {
    return EditDoctorProfileCard(
      title: Labels.practiceCertification,
      onTap: () {
        bottomSheet(
          context: context,
          widget: EditDoctorDocsView(
            onSubmit: (DoctorDocsParams doctorDocsParams) {
              context.read<EditDoctorProfileCubit>().updatePracticingCirtificate(doctorDocsParams);
            },
          ),
        );
      },
    );
  }
}
