import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_statistics/doctor_statistics_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/history/doctor_history_card.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class DoctorStatisticsView extends StatelessWidget {
  const DoctorStatisticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: AppBar(),
      body: BlocBuilder<DoctorStatisticsCubit, DoctorStatisticsState>(
        builder: (context, state) {
          if (state is DoctorStatisticsLoaded) {
            final statistics = state.statistics;
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                InkWell(
                  onTap: () {
                    context.push(Routes.ALLDOCTORRESERVATIONS);
                  },
                  child: DoctorHistoryCard(
                    title: 'Total Appointments',
                    totalValue: statistics.appointmentsCount,
                    clinicValue: statistics.clinic.appointmentsCount,
                    callValue: statistics.call.appointmentsCount,
                    homeVisitValue: statistics.homeVisit.appointmentsCount,
                  ),
                ),
                const Sizer(
                  height: 20,
                ),
                DoctorHistoryCard(
                  title: 'Total Earned',
                  totalValue: statistics.totalEarned,
                  clinicValue: statistics.clinic.totalEarned,
                  callValue: statistics.call.totalEarned,
                  homeVisitValue: statistics.homeVisit.totalEarned,
                ),
              ],
            );
          } else if (state is DoctorStatisticsError) {
            return Center(
              child: Text(
                state.message,
                style: Styles.headerText(),
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
