import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/time_tables/time_table.dart';

class CreateDoctorClinicTimeTable extends StatelessWidget {
  const CreateDoctorClinicTimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    final createDoctorCubit = context.read<CreateDoctorCubit>();
    return BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
      buildWhen: (previous, current) => current is CreateDoctorShowClinic,
      builder: (context, state) {
        if (state is CreateDoctorShowClinic && state.check) {
          return Timetable(
              title: 'Clinic',
              timetale: createDoctorCubit.clinicTimetable,
              child: Column(
                children: [
                  DefaultTextFormField(
                    currentFocusNode: createDoctorCubit.clinicPriceFocusNode,
                    currentController: createDoctorCubit.clinicPriceController,
                    nextFocusNode:
                        createDoctorCubit.clinicExamineDurationFocusNode,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    hint: 'Clinic Price',
                  ),
                  Sizer(),
                  DefaultTextFormField(
                    hint: 'Clinic Examine Duration (in minutes)',
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    nextFocusNode: createDoctorCubit.waitingTimeFocusNode,
                    currentFocusNode:
                        createDoctorCubit.clinicExamineDurationFocusNode,
                    currentController:
                        createDoctorCubit.clinicExamineDurationController,
                  ),
                  Sizer(),
                  DefaultTextFormField(
                    hint: 'Clinic Waiting time (in minutes)',
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    currentFocusNode: createDoctorCubit.waitingTimeFocusNode,
                    currentController: createDoctorCubit.waitingTimeController,
                  ),
                ],
              ));
        } else {
          return SizedBox.shrink();
        }
      },
    );
  }
}
