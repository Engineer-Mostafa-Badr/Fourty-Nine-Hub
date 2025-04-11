import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/default_text_form_field.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_timetable/edit_doctor_timetable_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_time_table/edit_call_time_table.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_time_table/edit_clinic_time_table.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_time_table/edit_home_visit_time_table.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_time_table/time_table_options_checkbox.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class EditDoctorTimetableView extends StatefulWidget {
  const EditDoctorTimetableView({super.key, required this.params});
  final CheckBoxParams params;
  @override
  State<EditDoctorTimetableView> createState() =>
      _EditDoctorTimetableViewState();
}

class _EditDoctorTimetableViewState extends State<EditDoctorTimetableView> {
  @override
  void initState() {
    context.read<EditDoctorTimetableCubit>().init(widget.params);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: LocaleKeys.timeTable.localize,
          backColor: cardDarkColor(context),
        ),
      ),
      body: BlocBuilder<EditDoctorTimetableCubit, EditDoctorTimetableState>(
          builder: (context, state) => state.status ==
                  EditDoctorTimetableStateStatus.initial
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: EdgeInsets.all(10.w),
                  shrinkWrap: true,
                  children: [
                    const EditTimeTableOptionsCheckbox(),
                    if (state.showClinic == true ||
                        state.showCall == true ||
                        state.showHomeVisit == true) ...[
                      DefaultTextFormField(
                        hint: 'Waiting time (in minutes)',
                        keyboardType: TextInputType.number,
                        isRequired: true,
                        currentFocusNode: FocusNode(),
                        currentController: context
                            .read<EditDoctorTimetableCubit>()
                            .waitingTimeController,
                      ),
                      const Sizer()
                    ],
                    if (state.showClinic == true) ...[
                      const EditDoctorClinicTimeTable(),
                      const Sizer()
                    ],
                    if (state.showCall == true) ...[
                      const EditDoctorCallTimeTable(),
                      const Sizer()
                    ],
                    if (state.showHomeVisit == true) ...[
                      const EditDoctorHomeVisitTimeTable(),
                      const Sizer()
                    ],
                    state.status == EditDoctorTimetableStateStatus.editLoading
                        ? const Center(child: CircularProgressIndicator())
                        : AppButton(
                            label: LocaleKeys.update.localize,
                            onPressed: () {
                              context
                                  .read<EditDoctorTimetableCubit>()
                                  .updateTimeTable(context);
                            },
                          )
                  ],
                )),
    );
  }
}
