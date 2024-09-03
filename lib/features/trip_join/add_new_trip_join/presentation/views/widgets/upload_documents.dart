import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/button.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/upload_image_button_sheet.dart';
import 'package:fourtyninehub/features/trip_join/add_new_trip_join/presentation/views/widgets/upload_image_info.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class UploadDocuments extends StatelessWidget {
  const UploadDocuments({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Sizer(),
        Text(
          'Upload documents',
          style: Styles.headerText(color: AppColors.SECONDARY_COLOR),
        ),
        Text(
          'You have to upload four photo for the car and one for the car number plate',
          style: Styles.mediumText(),
        ),
        const UploadImageInfo(number: 2, isCarImage: true),
        const UploadImageInfo(),
        const UploadImageInfo(isCarImage: true, isSuccess: true, number: 2),
        const UploadImageInfo(isCarImage: false, isSuccess: true),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: CustomButton(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (builder) {
                    return const UploadImageButtonSheet();
                  });
            },
            title: 'Upload',
            height: 30,
          ),
        ),
        const Sizer(),
      ],
    );
  }
}
