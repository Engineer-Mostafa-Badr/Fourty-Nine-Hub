import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_docs/docs_expire_date_filed.dart';
import 'package:fourtyninehub/features/health_feature/doctor_dashboard/presentation/widgets/edit_docs/upload_photos.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

class EditDoctorDocsView extends StatelessWidget {
  const EditDoctorDocsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          const UploadDoctorDocsPhotos(),
          const Sizer(
            height: 20,
          ),
          const DoctorDocsExpireDateField(),
          Sizer(
            height: MediaQuery.of(context).size.height * 0.45,
          ),
          AppButton(
            height: 50,
            label: Labels.update,
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
