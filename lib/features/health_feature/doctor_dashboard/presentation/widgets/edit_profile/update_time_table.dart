import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_profile/edit_doctor_profile_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_card.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_time_table/time_table_options_checkbox.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class UpdateDoctorTimetableCard extends StatelessWidget {
  const UpdateDoctorTimetableCard({super.key, required this.params});
  final CheckBoxParams params;
  @override
  Widget build(BuildContext context) {
    return EditDoctorProfileCard(
      title: LocaleKeys.timeTable.localize,
      onTap: () async {
      ManageVibration.vibrate();
        var result =
            await context.push(Routes.EDITDOCTORTIMETABLE, extra: params);
        if (result == true) {
          context.read<EditDoctorProfileCubit>().loadData();
        }
      },
    );
  }
}