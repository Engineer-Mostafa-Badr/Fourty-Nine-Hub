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
      title: Label(text:context.isArabic ? governorate.nameAr : governorate.nameEn,

        style: Styles.headerText(fontWeight: FontWeight.w600),

      ),
      onTap: () {
      ManageVibration.vibrate();
        serviceLocator<HealthSharedData>().doctorSearchParams.governorate =
            governorate;

        context.push(Routes.FILTERDOCTORCITY, extra: type);
      },
    );
  }
}