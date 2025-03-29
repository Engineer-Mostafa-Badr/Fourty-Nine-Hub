import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/custom_text_field_health.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/time_tables/time_table.dart';

class CreateDoctorHomeVisitTimeTable extends StatelessWidget {
  const CreateDoctorHomeVisitTimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    final createDoctorCubit = context.read<CreateDoctorCubit>();
    return BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
      buildWhen: (previous, current) => current is CreateDoctorShowHomeVisit,
      builder: (context, state) {
        if (state is CreateDoctorShowHomeVisit && state.check) {
          return Timetable(
              title: LocaleKeys.homeVisit.localize,
              timetale: createDoctorCubit.homeVisitTimetable,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFieldHealth(
                    hintText: LocaleKeys.homeVisitPrice.localize,
                    controller: createDoctorCubit.homeVisitPriceController,
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
                  //   currentFocusNode: createDoctorCubit.homeVisitPriceFocusNode,
                  //   currentController:
                  //       createDoctorCubit.homeVisitPriceController,
                  //   nextFocusNode:
                  //       createDoctorCubit.homeVisitExamineDurationFocusNode,
                  //   keyboardType: TextInputType.number,
                  //   isRequired: true,
                  //   hint: context.isArabic
                  //       ? 'سعر الزيارة المنزلية'
                  //       : 'Home Visit Price',
                  // ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomTextFieldHealth(
                    hintText: LocaleKeys.homeVisitExamineDuration.localize,
                    controller:
                        createDoctorCubit.homeVisitExamineDurationController,
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
                  //       ? 'مدة الفحص في الزيارة المنزلية (بالدقائق)'
                  //       : 'Home Visit Examine Duration (in minutes)',
                  //   keyboardType: TextInputType.number,
                  //   isRequired: true,
                  //   nextFocusNode: createDoctorCubit.waitingTimeFocusNode,
                  //   currentFocusNode:
                  //       createDoctorCubit.homeVisitExamineDurationFocusNode,
                  //   currentController:
                  //       createDoctorCubit.homeVisitExamineDurationController,
                  // ),
                ],
              ));
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
