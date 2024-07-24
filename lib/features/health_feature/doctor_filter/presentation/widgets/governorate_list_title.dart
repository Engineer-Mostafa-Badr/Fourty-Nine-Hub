import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class GovernorateListTitle extends StatelessWidget {
  final GovernorateEntity governorate;
  const GovernorateListTitle({
    super.key,
    required this.governorate,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(governorate.nameEn),
      onTap: () {
        context.push(Routes.FILTERDOCTORCITY, extra: governorate);
      },
    );
  }
}
