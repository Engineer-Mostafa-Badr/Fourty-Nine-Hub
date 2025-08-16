import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/earned_mony_entity.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class DoctorDashboardPopupMenuButton extends StatelessWidget {
  const DoctorDashboardPopupMenuButton(
      {super.key, required this.earnedMoney, required this.subCategoryId});
  final List<EarnedMoneyEntity> earnedMoney;
  final String subCategoryId;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: Routes.EDITDOCTORPROFILE,
            child: Text(LocaleKeys.editProfile.localize),
          ),
          PopupMenuItem(
            onTap: () {
              ManageVibration.vibrate();
              context.pushNamed(Routes.DOCTORREVIEWS, extra: '');
            },
            child: Text(LocaleKeys.reviews.localize),
          ),
          PopupMenuItem(
            onTap: () {
              ManageVibration.vibrate();
              context.pushNamed(Routes.DOCTORSTATISTICS, extra: earnedMoney);
            },
            child: Text(LocaleKeys.history.localize),
          ),
          PopupMenuItem(
            onTap: () {
              ManageVibration.vibrate();
              context.pushNamed(Routes.EMERGENCYREQUESTS, extra: subCategoryId);
            },
            child: Text(LocaleKeys.emergencyRequests.localize),
          ),
          PopupMenuItem(
            onTap: () {
              ManageVibration.vibrate();
              context.pushNamed(Routes.ALLAPPOINTMENTS);
            },
            child: Text(LocaleKeys.allAppointments.localize),
          ),
        ];
      },
      onSelected: (value) {
        context.pushNamed(value);
      },
    );
  }
}
