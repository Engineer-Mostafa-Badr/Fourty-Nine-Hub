import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/delete_account.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_id.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_personal.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_practicing.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_profile_photo_card.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_time_table.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class EditDoctorProfileView extends StatelessWidget {
  const EditDoctorProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: AppBar(
        title: const Text(Labels.editProfile),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: const [
          UpdateProfilePhotoCard(),
          Sizer(),
          UpdateDoctorIdCard(),
          Sizer(),
          UpdateDoctorPracticingCirtificateCard(),
          Sizer(),
          UpdateDoctorTimetableCard(),
          Sizer(),
          UpdateDoctorPersonalInfo(),
          Sizer(),
          DeleteDoctorAccountCard(),
        ],
      ),
    );
  }
}
