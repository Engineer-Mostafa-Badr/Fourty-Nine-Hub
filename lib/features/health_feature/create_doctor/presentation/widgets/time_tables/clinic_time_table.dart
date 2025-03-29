import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/custom_text_field_health.dart';
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
              title: LocaleKeys.clinicVisit.localize,
              timetale: createDoctorCubit.clinicTimetable,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 8),
                child: Column(
                  children: [
                    CustomTextFieldHealth(
                      hintText: LocaleKeys.clinicPrice.localize,
                      controller: createDoctorCubit.clinicPriceController,
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
                    //   currentFocusNode: createDoctorCubit.clinicPriceFocusNode,
                    //   currentController: createDoctorCubit.clinicPriceController,
                    //   nextFocusNode:
                    //       createDoctorCubit.clinicExamineDurationFocusNode,
                    //   keyboardType: TextInputType.number,
                    //   isRequired: true,
                    //   hint: LocaleKeys.clinicPrice.localize,
                    // ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextFieldHealth(
                      hintText: LocaleKeys.clinicExamineDuration.localize,
                      controller:
                          createDoctorCubit.clinicExamineDurationController,
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
                    //   hint: context.isArabic
                    //       ? 'مدة الفحص في العيادة (بالدقائق)'
                    //       : 'Clinic Examine Duration (in minutes)',
                    //   keyboardType: TextInputType.number,
                    //   isRequired: true,
                    //   nextFocusNode: createDoctorCubit.waitingTimeFocusNode,
                    //   currentFocusNode:
                    //       createDoctorCubit.clinicExamineDurationFocusNode,
                    //   currentController:
                    //       createDoctorCubit.clinicExamineDurationController,
                    // ),
                  ],
                ),
              ));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
