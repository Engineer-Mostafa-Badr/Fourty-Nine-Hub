import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import 'upload_button_and_info.dart';
import 'upload_image_popup.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../helpers/manage_vibration.dart';

class UploadImageButtonSheet extends StatelessWidget {
  const UploadImageButtonSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380.h,
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10.h),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        child: Column(
          children: [
            const Sizer(),
            Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
      ManageVibration.vibrate();
                  context.pop();
                },
              ),
            ),
            const Sizer(),
            UploadButtonAndInfo(
              isCarImage: true,
              number: 1,
              isSuccess: true,
              onTap: () {
      ManageVibration.vibrate();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UploadImagePopup(
                      cameraCallback: () {},
                      galleryCallback: () {},
                    );
                  },
                );
              },
            ),
            UploadButtonAndInfo(
              isCarImage: true,
              number: 2,
              isSuccess: true,
              onTap: () {
      ManageVibration.vibrate();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UploadImagePopup(
                      cameraCallback: () {},
                      galleryCallback: () {},
                    );
                  },
                );
              },
            ),
            UploadButtonAndInfo(
              isCarImage: true,
              number: 3,
              onTap: () {
      ManageVibration.vibrate();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UploadImagePopup(
                      cameraCallback: () {},
                      galleryCallback: () {},
                    );
                  },
                );
              },
            ),
            UploadButtonAndInfo(
              isCarImage: true,
              number: 4,
              onTap: () {
      ManageVibration.vibrate();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UploadImagePopup(
                      cameraCallback: () {},
                      galleryCallback: () {},
                    );
                  },
                );
              },
            ),
            UploadButtonAndInfo(
              onTap: () {
      ManageVibration.vibrate();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UploadImagePopup(
                      cameraCallback: () {},
                      galleryCallback: () {},
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}