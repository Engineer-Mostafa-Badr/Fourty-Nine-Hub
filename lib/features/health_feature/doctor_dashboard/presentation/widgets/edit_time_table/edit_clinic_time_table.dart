import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/time_tables/time_table.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_timetable/edit_doctor_timetable_cubit.dart';

class EditDoctorClinicTimeTable extends StatelessWidget {
  const EditDoctorClinicTimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorLoginCubit = context.read<EditDoctorTimetableCubit>();
    return BlocBuilder<EditDoctorTimetableCubit, EditDoctorTimetableState>(
      builder: (context, state) {
          return Timetable(
              title: LocaleKeys.clinicVisit.localize,
              timetale: state.clinicTimetable??[],
              child: Column(
                children: [
                  DefaultTextFormField(
                    currentFocusNode: FocusNode(),
                    currentController: doctorLoginCubit.clinicPriceController,
                    nextFocusNode: FocusNode(),
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    hint: 'Clinic Price',
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                    hint: 'Clinic Examine Duration (in minutes)',
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    nextFocusNode: FocusNode(),
                    currentFocusNode:
                    FocusNode(),
                    currentController:
                    doctorLoginCubit.clinicDurationController,
                  ),
                  const Sizer(),
                ],
              ));
      },
    );
  }
}
