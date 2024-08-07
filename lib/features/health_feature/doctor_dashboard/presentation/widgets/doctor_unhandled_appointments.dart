import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/domain/entities/doctor_appointment_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_dashboard/doctor_dashboard_cubit.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/appointment_booking_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class DoctorUnhandledAppointmentsWidget extends StatelessWidget {
  const DoctorUnhandledAppointmentsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          text: Labels.unhandledAppointments,
          style: Styles.headerText(),
        ),
        const Sizer(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: BlocBuilder<DoctorDashboardCubit, DoctorDashboardState>(
            builder: (context, state) {
              if (state is DoctorDashboardUnhandledAppointments &&
                  state.appointments.isNotEmpty) {
                return Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.appointments.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) =>
                          DoctorUnhandledAppointmentCard(
                        appointment: state.appointments[index],
                      ),
                    ),
                    const Sizer(),
                    AppButton(
                        label: Labels.viewMore,
                        onPressed: () {
                          context.push(Routes.DOCTORUNHANDLEDAPPOINTMENTS);
                        })
                  ],
                );
              } else {
                return const Center(child: Text(Labels.noAppointments));
              }
            },
          ),
        ),
      ],
    );
  }
}

class DoctorUnhandledAppointmentCard extends StatelessWidget {
  final DoctorAppointmentEntity appointment;
  const DoctorUnhandledAppointmentCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: SquareImage(
              url: appointment.image ?? UIConst.profilePlaceHolder,
            )),
        const Sizer(),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Label(
                text: appointment.fullName,
                style: Styles.headerText(),
              ),
              Label(
                text:
                    '${appointment.type.translatedName} - ${appointment.day.name}\n${appointment.time}',
                style: Styles.mediumText(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              AppButton(
                label: Labels.accept,
                onPressed: () {},
                backColor: AppColors.PRIMARY_COLOR,
              ),
              const Sizer(),
              AppButton(
                label: Labels.reject,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
