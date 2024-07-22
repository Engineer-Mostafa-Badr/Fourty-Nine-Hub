import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/cubit/create_doctor_cubit.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/presentation/widgets/time_tables/time_table.dart';

class CreateDoctorHomeVisitTimeTable extends StatelessWidget {
  const CreateDoctorHomeVisitTimeTable({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
      builder: (context, state) {
        if (state.hasHomeVisit) {
          return TimeTable(
              title: 'Home Visit',
              onChanged: (check, day) {
                if (check) {
                  context.read<CreateDoctorCubit>().homeVisitWorkDays.add(day);
                } else {
                  context
                      .read<CreateDoctorCubit>()
                      .homeVisitWorkDays
                      .removeWhere((element) => element.day == day.day);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextFormField(
                    currentFocusNode: context
                        .read<CreateDoctorCubit>()
                        .homeVisitPriceFocusNode,
                    currentController: context
                        .read<CreateDoctorCubit>()
                        .homeVisitPriceController,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    hint: 'Home Visit Price',
                  ),
                  const Sizer(),
                  DefaultTextFormField(
                    hint: 'Home Visit Examine Duration (in minutes)',
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    currentFocusNode: context
                        .read<CreateDoctorCubit>()
                        .homeVisitExamineDurationFocusNode,
                    currentController: context
                        .read<CreateDoctorCubit>()
                        .homeVisitExamineDurationController,
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
