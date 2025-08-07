import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_profile/edit_doctor_profile_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class DeleteDoctorAccountCard extends StatelessWidget {
  const DeleteDoctorAccountCard({super.key});

  @override
  Widget build(BuildContext context) {
    return EditDoctorProfileCard(
      title: LocaleKeys.deleteAccount.localize,
      textStyle: Styles.headerText(color: AppColors.SECONDARY_COLOR),
      icon: Icons.delete,
      iconColor: AppColors.SECONDARY_COLOR,
      onTap: () {
      ManageVibration.vibrate();
        context.read<EditDoctorProfileCubit>().deleteAccount();
      },
    );
  }
}