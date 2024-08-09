import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_uploader_widget.dart';
import 'package:fourtyninehub/res/strings/labels.dart';

class UpdateProfilePhotoCard extends StatelessWidget {
  const UpdateProfilePhotoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Column(
        children: [
          ImageUploaderWidget(subCategoryId: '',),
          const Sizer(
            height: 20,
          ),
          AppButton(
            label: Labels.update,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
