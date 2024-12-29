import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
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
              title: context.isArabic ? 'العيادة' : 'Clinic',
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
                    hint: context.isArabic
                        ? 'سعر الكشف في العيادة'
                        : 'Clinic Price',
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                    hint: context.isArabic
                        ? 'مدة الفحص في العيادة (بالدقائق)'
                        : 'Clinic Examine Duration (in minutes)',
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    nextFocusNode: createDoctorCubit.waitingTimeFocusNode,
                    currentFocusNode:
                        createDoctorCubit.clinicExamineDurationFocusNode,
                    currentController:
                        createDoctorCubit.clinicExamineDurationController,
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
