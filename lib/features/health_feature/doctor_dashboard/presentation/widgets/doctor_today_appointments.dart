import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_dashboard/doctor_dashboard_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class DoctorTodayAppointmentsWidget extends StatelessWidget {
  const DoctorTodayAppointmentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: Labels.todayAppointments,
          style: Styles.headerText(),
        ),
        const Sizer(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme.of(context).primaryColor,
          ),
          child: BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
            buildWhen: (previous, current) =>
                current is DoctorDashboardInitial ||
                current is DoctorDashboardTodayAppointments,
            builder: (context, state) {
              if (state is DoctorDashboardTodayAppointments &&
                  state.appointments.isNotEmpty) {
                return Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.appointments.length,
                      itemBuilder: (context, index) => DoctorAppointmentCard(
                        appointment: state.appointments[index],
                      ),
                      separatorBuilder: (BuildContext context, int index) =>
                          const Divider(),
                    ),
                    AppButton(
                        label: Labels.viewMore,
                        onPressed: () {
                          context.push(Routes.DOCTORTODAYAPPOINTMENTS);
                        })
                  ],
                );
              } else {
                return Center(
                    child: Text(
                  'No Appointments',
                  style: Styles.headerText(
                      color: Theme.of(context).scaffoldBackgroundColor),
                ));
              }
            },
          ),
        ),
      ],
    );
  }
}

class DoctorAppointmentCard extends StatelessWidget {
  final DoctorAppointmentEntity appointment;
  const DoctorAppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        appointment.type.translatedName,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
      subtitle: Text(appointment.time),
    );
  }
}
