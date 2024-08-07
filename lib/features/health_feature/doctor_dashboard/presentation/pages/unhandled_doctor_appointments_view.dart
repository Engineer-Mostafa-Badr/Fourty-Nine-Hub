import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_unhandled_appotinments/doctor_unhandled_appotinments_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/doctor_Unhandled_appointments.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class DoctorUnhandledAppointmentsView extends StatelessWidget {
  const DoctorUnhandledAppointmentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Labels.requests),
      ),
      body: BlocBuilder<DoctorUnhandledAppointmentsCubit,
          DoctorUnhandledAppointmentsState>(
        builder: (context, state) {
          if (state is DoctorUnhandledAppointmentsLoaded) {
            if (state.appointments.isNotEmpty) {
              return ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                controller: context
                    .read<DoctorUnhandledAppointmentsCubit>()
                    .scrollController,
                itemCount: state.appointments.length,
                itemBuilder: (context, index) => DoctorUnhandledAppointmentCard(
                  appointment: state.appointments[index],
                ),
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(height: 60,),
              );
            } else {
              return Center(
                child: Label(
                  text: Labels.noAppointments,
                  style: Styles.headerText(),
                ),
              );
            }
          } else if (state is DoctorUnhandledAppointmentsError) {
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
