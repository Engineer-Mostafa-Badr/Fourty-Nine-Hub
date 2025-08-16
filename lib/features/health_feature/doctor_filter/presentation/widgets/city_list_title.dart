import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/doctor_filter/presentation/pages/doctors_list.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../res/style/styles.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class CityListTitle extends StatelessWidget {
  final CityEntity city;

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
        serviceLocator<HealthSharedData>().doctorSearchParams.city = city;

        context.pushNamed(Routes.VISITADOCTORLIST,
            extra: DoctorsListParams(
                fromHome: false, subCategoryId: '', type: type));
      },
    );
  }
}
