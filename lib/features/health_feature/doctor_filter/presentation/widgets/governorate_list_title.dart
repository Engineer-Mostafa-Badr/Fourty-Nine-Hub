import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/style/styles.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class GovernorateListTitle extends StatelessWidget {
  final GovernorateEntity governorate;
  final String type;
  const GovernorateListTitle({
    super.key,
    required this.governorate,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Label(
        text: context.isArabic ? governorate.nameAr : governorate.nameEn,
        style: Styles.headerText(fontWeight: FontWeight.w600),
      ),
      onTap: () {
        ManageVibration.vibrate();
        final healthSharedData = serviceLocator<HealthSharedData>();
        healthSharedData.doctorSearchParams.governorate = governorate;

        // Debug print for governorate selection
        print('🟢 [DEBUG] Governorate Selected:');
        print('   - Governorate ID: ${governorate.id}');
        print('   - Governorate Name (AR): ${governorate.nameAr}');
        print('   - Governorate Name (EN): ${governorate.nameEn}');
        print(
            '   - Specialty ID: ${healthSharedData.doctorSearchParams.subCategory.id}');
        print(
            '   - Specialty Name: ${healthSharedData.doctorSearchParams.subCategory.nameAr ?? healthSharedData.doctorSearchParams.subCategory.nameEn}');
        print(
            '   - Booking Type: ${healthSharedData.doctorSearchParams.bookingType?.name ?? "null"}');
        print('   → Navigating to City Selection');

        context.push(Routes.FILTERDOCTORCITY, extra: type);
      },
    );
  }
}
