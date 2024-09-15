import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UploadImagePopup extends StatelessWidget {
  const UploadImagePopup({
    super.key,
    this.galleryCallback,
    this.cameraCallback,
  });
  final void Function()? galleryCallback;
  final void Function()? cameraCallback;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 180,
        height: 150.h,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  context.pop();
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: galleryCallback,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 5.h),
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 2, color: AppColors.PRIMARY_COLOR),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('From Gallery'),
                        Sizer(),
                        const Icon(Icons.perm_media,
                            color: AppColors.PRIMARY_COLOR),
                      ],
                    ),
                  ),
                ),
                Sizer(),
                GestureDetector(
                  onTap: cameraCallback,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 5.h),
                    decoration: BoxDecoration(
                      border:
                          Border.all(width: 2, color: AppColors.PRIMARY_COLOR),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('From Camera'),
                        Sizer(),
                        const Icon(Icons.videocam,
                            color: AppColors.SECONDARY_COLOR),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
