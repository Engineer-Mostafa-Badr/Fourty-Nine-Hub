import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/features/health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

class GovernorateListTitle extends StatelessWidget {
  final GovernorateEntity governorate;
  final String type;
  const GovernorateListTitle({
    super.key,
    required this.governorate, required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(context.isArabic?governorate.nameAr:governorate.nameEn),
      onTap: () {
        serviceLocator<HealthSharedData>().doctorSearchParams.governorate =
            governorate;

        context.push(Routes.FILTERDOCTORCITY,extra: type);
      },
    );
  }
}
