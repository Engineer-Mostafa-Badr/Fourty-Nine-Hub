import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class DoctorDashboardPopupMenuButton extends StatelessWidget {
  const DoctorDashboardPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: Routes.EDITDOCTORPROFILE,
            child: Text(Labels.editProfile),
          ),
          const PopupMenuItem(
            value: Routes.DOCTORHISTORY,
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
