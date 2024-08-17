import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_today_appointments/doctor_today_appointments_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/doctor_today_appointments.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorTodayAppointmentsView extends StatelessWidget {
  const DoctorTodayAppointmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: Labels.todayAppointments,
      ),
      body: BlocBuilder<DoctorTodayAppointmentsCubit,
          DoctorTodayAppointmentsState>(
        builder: (context, state) {
          if (state is DoctorTodayAppointmentsLoaded) {
            if (state.appointments.isNotEmpty) {
              return ListView.separated(
                shrinkWrap: true,
                controller: context
                    .read<DoctorTodayAppointmentsCubit>()
                    .scrollController,
                itemCount: state.appointments.length,
                itemBuilder: (context, index) => DoctorAppointmentCard(
                  appointment: state.appointments[index],
                ),
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              );
            } else {
              return Center(
                child: Label(
                  text: 'No Appointments',
                  style: Styles.headerText(),
                ),
              );
            }
          } else if (state is DoctorTodayAppointmentsError) {
            return Center(
                child: Label(
              text: state.message,
              style: Styles.headerText(),
            ));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
