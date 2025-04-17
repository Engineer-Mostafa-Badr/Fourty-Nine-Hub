import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/doctor_unhandled_appointments.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_unhandled_appotinments/doctor_unhandled_appotinments_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class DoctorUnhandledAppointmentsView extends StatefulWidget {
  const DoctorUnhandledAppointmentsView({super.key});

  @override
  State<DoctorUnhandledAppointmentsView> createState() =>
      _DoctorUnhandledAppointmentsViewState();
}

class _DoctorUnhandledAppointmentsViewState
    extends State<DoctorUnhandledAppointmentsView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<DoctorUnhandledAppointmentsCubit>().loadData();
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<DoctorUnhandledAppointmentsCubit>().getAppointments();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoctorUnhandledAppointmentsCubit,
        DoctorUnhandledAppointmentsState>(
      listener: (context, state) {},
      child: CustomScaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: BackAppBar(
            label: LocaleKeys.unhandledAppointments.localize,
          ),
        ),
        body: BlocBuilder<DoctorUnhandledAppointmentsCubit,
            DoctorUnhandledAppointmentsState>(
          builder: (context, state) {
            var cubit = context.read<DoctorUnhandledAppointmentsCubit>();
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (cubit.appointments.isNotEmpty) {
                return ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20.h),
                  controller: _scrollController,
                  itemCount: cubit.appointments.length,
                  itemBuilder: (context, index) {
                    final appointment = cubit.appointments[index];
                    return DoctorUnhandledAppointmentCard(
                      appointment: appointment,
                      onAccept: () => context
                          .read<DoctorUnhandledAppointmentsCubit>()
                          .acceptAppointment(appointment.id),
                      onReject: () => context
                          .read<DoctorUnhandledAppointmentsCubit>()
                          .rejectAppointment(appointment.id),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    height: 60.h,
                  ),
                );
              } else {
                return Center(
                  child: Label(
                    text: 'No Appointments',
                    style: Styles.headerText(),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
