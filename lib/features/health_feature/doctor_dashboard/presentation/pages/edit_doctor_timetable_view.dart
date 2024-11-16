import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/edit_doctor_timetable/edit_doctor_timetable_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_time_table/edit_call_time_table.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_time_table/edit_clinic_time_table.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_time_table/edit_home_visit_time_table.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_time_table/time_table_options_checkbox.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

class EditDoctorTimetableView extends StatefulWidget {
  const EditDoctorTimetableView({super.key});

  @override
  State<EditDoctorTimetableView> createState() => _EditDoctorTimetableViewState();
}

class _EditDoctorTimetableViewState extends State<EditDoctorTimetableView> {

  @override
  void initState() {
    context.read<EditDoctorTimetableCubit>().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: Labels.timetable,
      ),
      body: BlocBuilder<EditDoctorTimetableCubit, EditDoctorTimetableState>(
          builder: (context,state)=>state.status==EditDoctorTimetableStateStatus.initial?const Center(child: CircularProgressIndicator()):ListView(
            shrinkWrap: true,
            children: [
              EditTimeTableOptionsCheckbox(),
              if(state.showClinic==true)const EditDoctorClinicTimeTable(),
              if(state.showCall==true)const EditDoctorCallTimeTable(),
              if(state.showHomeVisit==true)const EditDoctorHomeVisitTimeTable(),
            ],
          )
      ),
    );
  }
}
