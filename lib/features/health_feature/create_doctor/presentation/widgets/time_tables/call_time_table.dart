import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/time_tables/time_table.dart';

class CreateDoctorCallTimeTable extends StatelessWidget {
  const CreateDoctorCallTimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorLoginCubit = context.read<CreateDoctorCubit>();
    return BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
      builder: (context, state) {
        if (state.hasCall) {
          return TimeTable(
            title: 'Call',
            onChanged: (check, day) {
              if (check) {
                context.read<CreateDoctorCubit>().callWorkDays.add(day);
              } else {
                context
                    .read<CreateDoctorCubit>()
                    .callWorkDays
                    .removeWhere((element) => element.day == day.day);
              }
            },
            child: Column(
              children: [
                DefaultTextFormField(
                    hint: 'Call Price',
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    currentFocusNode: doctorLoginCubit.callPriceFocusNode,
                    currentController: doctorLoginCubit.callPriceController),
                const Sizer(),
                DefaultTextFormField(
                    hint: 'Call Examine Duration (in minutes)',
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    currentFocusNode:
                        doctorLoginCubit.callExamineDurationFocusNode,
                    currentController:
                        doctorLoginCubit.callExamineDurationController),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
