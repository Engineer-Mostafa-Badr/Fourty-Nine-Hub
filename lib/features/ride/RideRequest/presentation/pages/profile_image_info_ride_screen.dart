import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/pick_driver_image_cubit.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/register_rider_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class ProfileImageInfoRideScreen extends StatefulWidget {
  const ProfileImageInfoRideScreen({super.key});

  @override
  State<ProfileImageInfoRideScreen> createState() =>
      _ProfileImageInfoRideScreenState();
}

class _ProfileImageInfoRideScreenState
    extends State<ProfileImageInfoRideScreen> {
  File? image;
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 80),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: context.isDarkMode
                      ? AppColors.UNSELECTED_DARK_GRAY_COLOR
                      : Colors.white,
                  boxShadow: context.isDarkMode
                      ? []
                      : [
                          BoxShadow(color: Colors.grey.shade400, blurRadius: 30)
                        ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 300,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: image != null
                                ? FileImage(image!)
                                : AssetImage(Assets.personalImage)
                                    as ImageProvider,
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  const Sizer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        context.isArabic
                            ? "وجه مرئي بوضوح"
                            : "Clearly visible face",
                        style: Styles.headerText(fontWeight: FontWeight.w500),
                        textAlign: TextAlign.end,
                      ),
                      const Sizer(),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: Colors.black, shape: BoxShape.circle),
                      ),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        context.isArabic ? "بدون نظارات" : "Without glasses",
                        style: Styles.headerText(fontWeight: FontWeight.w500),
                        textAlign: TextAlign.end,
                      ),
                      const Sizer(),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: Colors.black, shape: BoxShape.circle),
                      ),
                    ],
                  ),
                  const Sizer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        context.isArabic
                            ? "إضاءة جيدة وبدون فلاتر"
                            : "Good lighting and no filters",
                        style: Styles.headerText(fontWeight: FontWeight.w500),
                        textAlign: TextAlign.end,
                      ),
                      const Sizer(),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: Colors.black, shape: BoxShape.circle),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Sizer(
              height: 40,
            ),
            GestureDetector(
              onTap: () async {
      ManageVibration.vibrate();
                var pickedImage =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedImage != null) {
                  image = File(pickedImage.path);
                  context
                      .read<RegisterRiderCubit>()
                      .pickUserImage(image: image!);
                }
                context.read<PickDriverImageCubit>().pick(image: image!);
                context.pop();
                setState(() {});
              },
              child: Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                    color: AppColors.PRIMARY_COLOR,
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text(
                    context.isArabic ? "إضافة صورة" : "Add Image",
                    style: Styles.headerText(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}