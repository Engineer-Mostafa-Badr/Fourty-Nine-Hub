import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/cubit/all_appointments_cubit/all_appointments_cubit.dart';
import 'package:fourtyninehub/features/health_feature/booking/presentation/widgets/all_appointments_card.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class AllAppointmentsView extends StatefulWidget {
  const AllAppointmentsView({super.key});

  @override
  State<AllAppointmentsView> createState() => _AllAppointmentsViewState();
}

class _AllAppointmentsViewState extends State<AllAppointmentsView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<AllAppointmentsCubit>().loadInitialData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<AllAppointmentsCubit>().getAllAppointments();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(
        label: LocaleKeys.allAppointments.localize,
      ),
      body: BlocBuilder<AllAppointmentsCubit, AllAppointmentsState>(
        builder: (context, state) {
          var cubit = context.read<AllAppointmentsCubit>();
          return state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : cubit.appointments.isNotEmpty
                  ? ListView.separated(
                      controller: _scrollController,
                      padding: EdgeInsets.all(15.w),
                      itemCount: cubit.appointments.length,
                      separatorBuilder: (context, i) => const Sizer(),
                      itemBuilder: (context, i) => AllAppointmentsCard(
                        appointment: cubit.appointments[i],
                      ),
                    )
                  : Center(
                      child: Text(
                        LocaleKeys.noAppointments.localize,
                        style: Styles.headerText(),
                      ),
                    );
        },
      ),
    );
  }
}
