import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/booking/bookgins.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/doctor_dashboard_banner.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/medical_services/medical_services.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/booking_types/booking_types.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/widgets/sub_categories/sub_categories.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';

class HealthView extends StatelessWidget {
  const HealthView({super.key});

  @override
  Widget build(BuildContext context) {
    return SharedScaffold(
        mainCategoryId: 1,
        body: ListView(
          padding:  EdgeInsets.all(16.0.zW),
          children: const [
            HealthBanner(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("You can serve your clients as a doctor by clicking on the register button above!",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            Sizer(),
            DoctorDashboardBanner(),
            Sizer(),
            HealthBookingTypesWidgt(),
            Sizer(),
            HealthSubCategories(),
            Sizer(),
            HealthMedicalServices(),
            Sizer(),
            HealthBookings(),
            Sizer(),
          ],
        ));
  }
}
