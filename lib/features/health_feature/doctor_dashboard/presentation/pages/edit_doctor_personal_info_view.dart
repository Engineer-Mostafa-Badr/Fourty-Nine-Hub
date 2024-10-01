import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/personal_info/edit_doctor_address.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/personal_info/edit_doctor_name_field.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/personal_info/edit_doctor_phone_field.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/personal_info/edit_doctor_speciality_filed.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditDoctorPersonalInfoView extends StatelessWidget {
  const EditDoctorPersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        label: Labels.edit,
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const EditDoctorSpecialityField(),
          Sizer(
            height: 20.h,
          ),
          const EditDoctorNameField(),
          Sizer(
            height: 20.h,
          ),
          const EditDoctorPhoneField(),
          Sizer(
            height: 20.h,
          ),
          const EditDoctorAddressField(),
          Sizer(
            height: MediaQuery.of(context).size.height * 0.15,
          ),
          AppButton(
            label: Labels.update,
            height: 50.h,
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
