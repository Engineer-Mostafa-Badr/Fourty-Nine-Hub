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
    return BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
      builder: (context, state) {
        if (state.hasClinic) {
          return TimeTable(
              title: 'Clinic',
              onChanged: (check, day) {
                if (check) {
                  context.read<CreateDoctorCubit>().clinicWorkDays.add(day);
                } else {
                  context
                      .read<CreateDoctorCubit>()
                      .clinicWorkDays
                      .removeWhere((element) => element.day == day.day);
                }
              },
              child: Column(
                children: [
                  DefaultTextFormField(
                    currentFocusNode:
                        context.read<CreateDoctorCubit>().clinicPriceFocusNode,
                    currentController:
                        context.read<CreateDoctorCubit>().clinicPriceController,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    hint: 'Clinic Price',
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                    hint: 'Clinic Examine Duration (in minutes)',
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    currentFocusNode: context
                        .read<CreateDoctorCubit>()
                        .clinicExamineDurationFocusNode,
                    currentController: context
                        .read<CreateDoctorCubit>()
                        .clinicExamineDurationController,
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                    hint: 'Clinic Waiting time (in minutes)',
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    currentFocusNode:
                        context.read<CreateDoctorCubit>().waitingTimeFocusNode,
                    currentController:
                        context.read<CreateDoctorCubit>().waitingTimeController,
                  ),
                ],
              ));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
