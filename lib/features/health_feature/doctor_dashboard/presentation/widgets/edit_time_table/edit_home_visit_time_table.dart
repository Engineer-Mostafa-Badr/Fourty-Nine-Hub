import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/time_tables/time_table.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_timetable/edit_doctor_timetable_cubit.dart';

class EditDoctorHomeVisitTimeTable extends StatelessWidget {
  const EditDoctorHomeVisitTimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditDoctorTimetableCubit>();
    return BlocBuilder<EditDoctorTimetableCubit, EditDoctorTimetableState>(
      builder: (context, state) {
          return Timetable(
              title: LocaleKeys.homeVisit.localize,
              timetale: state.homeVisitTimetable??[],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextFormField(
                    currentFocusNode: FocusNode(),
                    currentController:
                    cubit.homeVisitPriceController,
                    nextFocusNode:
                        FocusNode(),
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    hint: 'Home Visit Price',
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                    hint: 'Home Visit Examine Duration (in minutes)',
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    currentFocusNode:
                    FocusNode(),
                    currentController:
                    cubit.homeVisitDurationController,
                  ),
                ],
              ));

      },
    );
  }
}
