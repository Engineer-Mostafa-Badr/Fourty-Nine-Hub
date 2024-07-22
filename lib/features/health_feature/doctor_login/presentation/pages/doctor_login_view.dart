import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/fields/location_field.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/info.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/submit_button.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/time_tables/call_time_table.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/time_tables/clinic_time_table.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/time_tables/home_visit_time_table.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/pickers/date/id_expiry_date_picker.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/pickers/photo/id_photo_picker.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/pickers/date/license_expiry_date_picker.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/pickers/photo/license_photo_picker.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/fields/name_filed.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/options_checkbox.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/pickers/photo/doctor_photo_picker.dart';
import 'package:fourtyninehub/features/health_feature/doctor_login/presentation/widgets/fields/specialty_filed.dart';

class DoctorLoginView extends StatelessWidget {
  const DoctorLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HomeAppbar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DoctorLoginOptionsCheckbox(),
            Sizer(height: 20),
            DoctorLoginNameField(),
            Sizer(height: 20),
            DoctorLoginPhotoPicker(),
            Sizer(height: 20),
            DoctorLoginIDPhotoPicker(),
            Sizer(height: 20),
            DoctorLoginIDExpiryDatePicker(),
            Sizer(height: 20),
            DoctorLoginLicensePhotoPicker(),
            Sizer(height: 20),
            DoctorLoginLicenseExpiryDatePicker(),
            Sizer(height: 20),
            DoctorLoginSpecialtyField(),
            Sizer(height: 20),
            DoctorLoginLocationField(),
            Sizer(height: 20),
            DoctorLoginClinicTimeTable(),
            Sizer(height: 20),
            DoctorLoginCallTimeTable(),
            Sizer(height: 20),
            DoctorLoginHomeVisitTimeTable(),
            Sizer(height: 20),
            DoctorLoginInfoText(
                text:
                    "The application does not deduct any percentage from the service provider."),
            Sizer(height: 20),
            DoctorLoginInfoText(
                text: 'You will get EGP 3,650 per year if you subscribe daily.'),
            Sizer(height: 20),
            DoctorLoginSubmitButton(),
          ],
        ),
      ),
    );
  }
}
