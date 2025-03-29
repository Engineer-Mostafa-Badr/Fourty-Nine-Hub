import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/all_doctor_reservations/all_doctor_reservations_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/doctor_today_appointments.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../core/widget/custom_scaffold.dart';

class AllDoctorReservationsView extends StatelessWidget {
  const AllDoctorReservationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const BackAppBar(
        label: Labels.todayAppointments,
      ),
      body: BlocBuilder<AllDoctorReservationsCubit, AllDoctorReservationsState>(
        builder: (context, state) {
          if (state is AllDoctorReservationsLoaded) {
            if (state.reservations.isNotEmpty) {
              return ListView.separated(
                shrinkWrap: true,
                controller:
                    context.read<AllDoctorReservationsCubit>().scrollController,
                itemCount: state.reservations.length,
                itemBuilder: (context, index) => DoctorAppointmentCard(
                  appointment: state.reservations[index],
                  cancelAppointment: (String id) {},
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
          } else if (state is AllDoctorReservationsError) {
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
