import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/earned_mony_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class DoctorDashboardPopupMenuButton extends StatelessWidget {
  const DoctorDashboardPopupMenuButton({super.key, required this.earnedMoney});
  final List<EarnedMoneyEntity> earnedMoney;
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: Routes.EDITDOCTORPROFILE,
            child: Text(Labels.editProfile),
          ),
          PopupMenuItem(
            onTap: (){
              context.push(Routes.DOCTORREVIEWS);
            },
            child: Text(Labels.reviews),
          ),
          PopupMenuItem(
            onTap: (){
              context.push(Routes.DOCTORSTATISTICS,extra: earnedMoney);
            },
            child: Text(Labels.history),
          ),
        ];
      },
      onSelected: (value) {
        context.push(value);
      },
    );
  }
}
