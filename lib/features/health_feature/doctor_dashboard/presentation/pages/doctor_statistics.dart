import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/earned_mony_entity.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/controllers/doctor_statistics/doctor_statistics_cubit.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/history/doctor_history_card.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorStatisticsView extends StatelessWidget {
  const DoctorStatisticsView({super.key, required this.totalEarnedMoney});
  final List<EarnedMoneyEntity> totalEarnedMoney;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: BlocBuilder<DoctorStatisticsCubit, DoctorStatisticsState>(
        builder: (context, state) {
          return totalEarnedMoney.isEmpty ? Center(child: Text(context.isArabic?'لا يوجد نتائج':'No Result',style: Styles.headerText(),),) : ListView(
            padding: const EdgeInsets.all(20),
            children: [
              InkWell(
                onTap: () {
                  // context.push(Routes.ALLDOCTORRESERVATIONS);
                },
                child: DoctorHistoryCard(
                  title: 'Total Appointments',
                  totalValue: totalEarnedMoney[0].count,
                  clinicValue: totalEarnedMoney[0].count,
                  callValue: totalEarnedMoney[0].count,
                  homeVisitValue: totalEarnedMoney[0].count, totalEarnedMoney: totalEarnedMoney,
                ),
              ),
              Sizer(
                height: 20.h,
              ),
              DoctorHistoryCard(
                title: 'Total Earned',
                totalValue: totalEarnedMoney[0].count,
                clinicValue: totalEarnedMoney[0].count,
                callValue: totalEarnedMoney[0].count,
                homeVisitValue: totalEarnedMoney[0].count, totalEarnedMoney: totalEarnedMoney,
              ),
            ],
          );
        },
      ),
    );
  }
}
