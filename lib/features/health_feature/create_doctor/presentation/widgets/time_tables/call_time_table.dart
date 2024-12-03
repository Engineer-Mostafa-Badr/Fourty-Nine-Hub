import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/time_tables/time_table.dart';

class CreateDoctorCallTimeTable extends StatelessWidget {
  const CreateDoctorCallTimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorLoginCubit = context.read<CreateDoctorCubit>();
    return BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
      buildWhen: (previous, current) => current is CreateDoctorShowCall,
      builder: (context, state) {
        if (state is CreateDoctorShowCall && state.check) {
          return Timetable(
            title: context.isArabic?'مكالمة':'Call',
            timetale: doctorLoginCubit.callTimetable,
            child: Column(
              children: [
                DefaultTextFormField(
                    hint: context.isArabic?'سعر المكالمة':'Call Price',
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    currentFocusNode: doctorLoginCubit.callPriceFocusNode,
                    nextFocusNode:
                        doctorLoginCubit.callExamineDurationFocusNode,
                    currentController: doctorLoginCubit.callPriceController),
                const Sizer(),
                DefaultTextFormField(
                    hint: context.isArabic?'مدة الفحص عبر المكالمة (بالدقائق)':'Call Examine Duration (in minutes)',
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
