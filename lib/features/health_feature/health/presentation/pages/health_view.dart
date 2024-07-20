import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/booking/bookgins.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/doctor_dashboard_banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/services/services.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/sub_categories/sub_categories.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';

class HealthView extends StatelessWidget {
  const HealthView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
        mainCategoryId: 1,
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          children: const [
            HealthBanner(),
            Sizer(),
            HealthServices(),
            Sizer(),
            HealthSubCategories(),
            Sizer(),
            DoctorDashboardBanner(),
            Sizer(),
            HealthBookings(),
            Sizer(),
          ],
        ));
  }
}
