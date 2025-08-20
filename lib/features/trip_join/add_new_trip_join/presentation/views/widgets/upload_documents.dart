import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import 'button.dart';
import 'upload_image_button_sheet.dart';
import 'upload_image_info.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../helpers/manage_vibration.dart';

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
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5.h),
          child: CustomButton(
            onTap: () {
      ManageVibration.vibrate();
              showModalBottomSheet(
                  context: context,
                  builder: (builder) {
                    return const UploadImageButtonSheet();
                  });
            },
            title: 'Upload',
            height: 30.h,
          ),
        ),
        const Sizer(),
      ],
    );
  }
}