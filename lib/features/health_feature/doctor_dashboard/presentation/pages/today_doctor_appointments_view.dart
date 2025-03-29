import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_today_appointments/doctor_today_appointments_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/doctor_today_appointments.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../core/widget/custom_scaffold.dart';

class DoctorTodayAppointmentsView extends StatefulWidget {
  const DoctorTodayAppointmentsView({super.key});

  @override
  State<DoctorTodayAppointmentsView> createState() =>
      _DoctorTodayAppointmentsViewState();
}

class _DoctorTodayAppointmentsViewState
    extends State<DoctorTodayAppointmentsView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<DoctorTodayAppointmentsCubit>().loadData();
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<DoctorTodayAppointmentsCubit>().getAppointmentsByDay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const BackAppBar(
        label: Labels.todayAppointments,
      ),
      body: BlocBuilder<DoctorTodayAppointmentsCubit,
          DoctorTodayAppointmentsState>(
        builder: (context, state) {
          var cubit = context.read<DoctorTodayAppointmentsCubit>();
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (cubit.appointments.isNotEmpty) {
              return ListView.separated(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: cubit.appointments.length,
                itemBuilder: (context, index) => DoctorAppointmentCard(
                  appointment: cubit.appointments[index],
                  cancelAppointment: (String id) {
                    context
                        .read<DoctorTodayAppointmentsCubit>()
                        .cancelAppointment(id, context);
                  },
                ),
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              );
            } else {
              return Center(
                child: Label(
                  text: LocaleKeys.noAppointments.localize,
                  style: Styles.headerText(),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
