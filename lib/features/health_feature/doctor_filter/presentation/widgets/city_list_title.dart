import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/pages/doctors_list.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class CityListTitle extends StatelessWidget {
  final CityEntity city;
  const CityListTitle({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(city.nameEn),
      onTap: () {
        serviceLocator<HealthSharedData>().doctorSearchParams.city = city;

        context.push(Routes.VISITADOCTORLIST,
            extra: DoctorsListParams(fromHome: false, subCategoryId: ''));
      },
    );
  }
}
