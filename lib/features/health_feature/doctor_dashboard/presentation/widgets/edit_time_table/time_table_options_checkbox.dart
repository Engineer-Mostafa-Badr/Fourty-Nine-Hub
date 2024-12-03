import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_timetable/edit_doctor_timetable_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class CheckBoxParams{
  final bool showCall;
  final bool showHomeVisit;
  final bool showClinic;
  CheckBoxParams({required this.showCall,required this.showHomeVisit,required this.showClinic});
}
// ignore: must_be_immutable
class EditTimeTableOptionsCheckbox extends StatelessWidget {
  EditTimeTableOptionsCheckbox({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditDoctorTimetableCubit, EditDoctorTimetableState>(
      builder: (context,state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: state.showClinic,
                  onChanged: (value) {
                    // state.showClinic = value!;
                    context.read<EditDoctorTimetableCubit>().toggleClinic(value??false);
                  },
                ),
                Text(
                  LocaleKeys.clinicVisit.localize,
                  style: Styles.mediumText(),
                ),
              ],
            ),
            // const Sizer(),
            Row(
              children: [
                Checkbox(
                  value: state.showCall,
                  onChanged: (value) {
                    // state.showClinic = value!;
                    context.read<EditDoctorTimetableCubit>().toggleCall(value??false);
                  },
                ),
                Text(
                  LocaleKeys.call.localize,
                  style: Styles.mediumText(),
                ),
              ],
            ),
            // const Sizer(),
            Row(
              children: [
                Checkbox(
                  value: state.showHomeVisit,
                  onChanged: (value) {
                    // state.showClinic = value!;
                    context.read<EditDoctorTimetableCubit>().toggleHomeVisit(value??false);
                  },
                ),
                Text(
                  LocaleKeys.homeVisit.localize,
                  style: Styles.mediumText(),
                ),
              ],
            ),
          ],
        );
      }
    );
  }
}
