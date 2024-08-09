import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/personal_info/edit_doctor_address.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/personal_info/edit_doctor_name_field.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/personal_info/edit_doctor_phone_field.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/personal_info/edit_doctor_speciality_filed.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

class EditDoctorPersonalInfoView extends StatelessWidget {
  const EditDoctorPersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Labels.edit),
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const EditDoctorSpecialityField(),
          const Sizer(
            height: 20,
          ),
          const EditDoctorNameField(),
          const Sizer(
            height: 20,
          ),
          const EditDoctorPhoneField(),
          const Sizer(
            height: 20,
          ),
          const EditDoctorAddressField(),
           Sizer(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          AppButton(
            label: Labels.update,
            height: 50,
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
