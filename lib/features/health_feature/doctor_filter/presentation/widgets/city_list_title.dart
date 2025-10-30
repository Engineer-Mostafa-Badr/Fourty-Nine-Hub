import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/city_entity.dart' as shared_city;
import 'package:fourtyninehub/features/health_feature/shared/domain/entities/city_entity.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/pages/doctors_list.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/style/styles.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class CityListTitle extends StatelessWidget {
  final shared_city.CityEntity city;

  const CityListTitle({super.key, required this.city, required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Label(
        text: context.isArabic ? city.nameAr : city.nameEn,
        style: Styles.headerText(fontWeight: FontWeight.w600),
      ),
      onTap: () {
        ManageVibration.vibrate();
        final healthSharedData = serviceLocator<HealthSharedData>();
        // Convert from create_doctor CityEntity to shared CityEntity
        healthSharedData.doctorSearchParams.city = CityEntity(
          id: city.id,
          nameAr: city.nameAr,
          nameEn: city.nameEn,
        );

        // Get booking type from shared data
        final bookingType = healthSharedData.doctorSearchParams.bookingType;

        // Debug print for city selection
        print('🟡 [DEBUG] City Selected:');
        print('   - City ID: ${city.id}');
        print('   - City Name (AR): ${city.nameAr}');
        print('   - City Name (EN): ${city.nameEn}');
        print(
            '   - Governorate ID: ${healthSharedData.doctorSearchParams.governorate.id}');
        print(
            '   - Governorate Name: ${healthSharedData.doctorSearchParams.governorate.nameAr ?? healthSharedData.doctorSearchParams.governorate.nameEn}');
        print(
            '   - Specialty ID: ${healthSharedData.doctorSearchParams.subCategory.id}');
        print(
            '   - Specialty ID isEmpty: ${healthSharedData.doctorSearchParams.subCategory.id.isEmpty}');
        print(
            '   - Specialty Name: ${healthSharedData.doctorSearchParams.subCategory.nameAr ?? healthSharedData.doctorSearchParams.subCategory.nameEn}');
        print('   - Booking Type: ${bookingType?.name ?? "null"}');
        print('   → Navigating to Doctors List with all filters');

        final specialtyId = healthSharedData.doctorSearchParams.subCategory.id;
        if (specialtyId.isEmpty) {
          print('❌ [ERROR] Specialty ID is empty! Cannot proceed.');
          return;
        }

        context.push(Routes.VISITADOCTORLIST,
            extra: DoctorsListParams(
                fromHome: false,
                subCategoryId: specialtyId,
                type: type,
                bookingType: bookingType));
      },
    );
  }
}
