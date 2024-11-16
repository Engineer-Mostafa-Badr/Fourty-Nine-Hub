import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/time_tables/time_table.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_timetable/edit_doctor_timetable_cubit.dart';

class EditDoctorCallTimeTable extends StatelessWidget {
  const EditDoctorCallTimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorLoginCubit = context.read<EditDoctorTimetableCubit>();
    return BlocBuilder<EditDoctorTimetableCubit, EditDoctorTimetableState>(
      builder: (context, state) {
          return Timetable(
            title: 'Call',
            timetale: state.callTimetable??[],
            child: Column(
              children: [
                DefaultTextFormField(
                    hint: 'Call Price',
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    currentFocusNode: FocusNode(),
                    nextFocusNode:
                        FocusNode(),
                    currentController: TextEditingController()),
                const Sizer(),
                DefaultTextFormField(
                    hint: 'Call Examine Duration (in minutes)',
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    currentFocusNode:
                        FocusNode(),
                    currentController:
                        TextEditingController()),
              ],
            ),
          );
      },
    );
  }
}
