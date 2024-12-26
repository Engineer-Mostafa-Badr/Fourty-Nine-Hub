import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/health_cubit/health_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/widgets/common/dashboard_banner.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/routes/routes.dart';

class DoctorDashboardBanner extends StatelessWidget {
  const DoctorDashboardBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HealthCubit, HealthState>(
      builder: (context, state) {
        if (state.isDoctor == true) {
          return DashboardBanner(
            title: context.isArabic ? 'لوحة التحكم' : 'Doctor Dashboard',
            subTitle: Labels.doctorDashboardBannerDiscription,
            route: Routes.DOCTORDASHBOARD,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
