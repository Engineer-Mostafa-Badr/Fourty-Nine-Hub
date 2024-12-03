import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_profile/update_card.dart';
import 'package:fourtyninehub/features/health_feature/doctor_details/domain/entities/doctor_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class UpdateDoctorPersonalInfo extends StatelessWidget {
  const UpdateDoctorPersonalInfo({super.key, required this.doctor});
  final DoctorEntity doctor;
  @override
  Widget build(BuildContext context) {
    return EditDoctorProfileCard(
      title: LocaleKeys.personalInformation.localize,
      onTap: () {
        context.push(Routes.EDITDOCTORPERSONALINFO,extra: doctor);
      },
    );
  }
}
