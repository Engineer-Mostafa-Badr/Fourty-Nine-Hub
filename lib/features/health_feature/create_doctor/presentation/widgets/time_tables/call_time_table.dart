import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/custom_text_field_health.dart';
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
            title: LocaleKeys.call.localize,
            timetale: doctorLoginCubit.callTimetable,
            child: Column(
              children: [
                CustomTextFieldHealth(
                  hintText: LocaleKeys.callPrice.localize,
                  controller: doctorLoginCubit.callPriceController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.priceIsRequired.localize;
                    }
                    return null;
                  },
                ),
                // DefaultTextFormField(
                //     hint: context.isArabic ? 'سعر المكالمة' : 'Call Price',
                //     keyboardType: TextInputType.number,
                //     isRequired: true,
                //     currentFocusNode: doctorLoginCubit.callPriceFocusNode,
                //     nextFocusNode:
                //         doctorLoginCubit.callExamineDurationFocusNode,
                //     currentController: doctorLoginCubit.callPriceController),
                const SizedBox(
                  height: 8,
                ),
                CustomTextFieldHealth(
                  hintText: LocaleKeys.callExamineDuration.localize,
                  controller: doctorLoginCubit.callExamineDurationController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return LocaleKeys.examineDurationIsRequired.localize;
                    }
                    return null;
                  },
                ),
                // DefaultTextFormField(
                //     hint: context.isArabic
                //         ? 'مدة الفحص عبر المكالمة (بالدقائق)'
                //         : 'Call Examine Duration (in minutes)',
                //     keyboardType: TextInputType.number,
                //     isRequired: true,
                //     currentFocusNode:
                //         doctorLoginCubit.callExamineDurationFocusNode,
                //     currentController:
                //         doctorLoginCubit.callExamineDurationController),
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
