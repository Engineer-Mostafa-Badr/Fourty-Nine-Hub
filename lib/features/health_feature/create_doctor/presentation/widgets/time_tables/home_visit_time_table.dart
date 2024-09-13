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
    final createDoctorCubit = context.read<CreateDoctorCubit>();
    return BlocBuilder<CreateDoctorCubit, CreateDoctorState>(
      buildWhen: (previous, current) => current is CreateDoctorShowHomeVisit,
      builder: (context, state) {
        if (state is CreateDoctorShowHomeVisit && state.check) {
          return Timetable(
              title: 'Home Visit',
              timetale: createDoctorCubit.homeVisitTimetable,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DefaultTextFormField(
                    currentFocusNode: createDoctorCubit.homeVisitPriceFocusNode,
                    currentController:
                        createDoctorCubit.homeVisitPriceController,
                    nextFocusNode:
                        createDoctorCubit.homeVisitExamineDurationFocusNode,
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    hint: 'Home Visit Price',
                  ),
                  Sizer(),
                  DefaultTextFormField(
                    hint: 'Home Visit Examine Duration (in minutes)',
                    keyboardType: TextInputType.number,
                    isRequired: true,
                    currentFocusNode:
                        createDoctorCubit.homeVisitExamineDurationFocusNode,
                    currentController:
                        createDoctorCubit.homeVisitExamineDurationController,
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
