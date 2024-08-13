import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_profile/edit_doctor_profile_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_card.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DeleteDoctorAccountCard extends StatelessWidget {
  const DeleteDoctorAccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return EditDoctorProfileCard(
      title: Labels.deleteAccount,
      textStyle: Styles.headerText(color: AppColors.SECONDARY_COLOR),
      icon: Icons.delete,
      iconColor: AppColors.SECONDARY_COLOR,
      onTap: () {
        context.read<EditDoctorProfileCubit>().deleteAccount();
      },
    );
  }
}
