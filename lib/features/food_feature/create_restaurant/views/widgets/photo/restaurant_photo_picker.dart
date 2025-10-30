import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../cubit/create_restaurant_cubit.dart';
import '../../../../../../res/assets/assets.dart';
import '../../../../../../res/style/styles.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../res/style/app_colors.dart';
import '../../../../../../helpers/manage_vibration.dart';

class CreateRestaurantProfilePhotoPicker extends StatefulWidget {
  final String? subcategoryId;

  const CreateRestaurantProfilePhotoPicker({super.key, this.subcategoryId});

  @override
  State<CreateRestaurantProfilePhotoPicker> createState() =>
      _CreateRestaurantProfilePhotoPickerState();
}

class _CreateRestaurantProfilePhotoPickerState
    extends State<CreateRestaurantProfilePhotoPicker> {
  @override
  Widget build(BuildContext context) {
    final createRestaurantCubit = context.read<CreateRestaurantCubit>();

    return BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
      builder: (context, state) {
        // سنختصر الوصول للصور والمصفوفة هنا - نأخذ نسخة جديدة
        final images = List<XFile>.from(createRestaurantCubit.restaurantImages);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان
            Label(
              text: LocaleKeys.photoForRestaurant.localize,
              style: Styles.headerText(fontSize: 40),
            ),

            20.verticalSpace,

            // Container مع ارتفاع محدد وscroll
            Container(
              height: 400.h,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.getFillColor(context).withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.getRedColor(context).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: GridView.builder(
                physics: const BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 1,
                ),
                itemCount: images.length + 1,
                itemBuilder: (context, index) {
                  final bool isAddBox = (index == images.length);

                  return buildPhotoBox(
                    context: context,
                    isAddBox: isAddBox,
                    image: isAddBox ? null : images[index],
                    onTap: () async {
                      ManageVibration.vibrate();

                      await createRestaurantCubit.uploadProfileImage(
                        context: context,
                        subcategoryId:
                            widget.subcategoryId ?? "62c8babb8e28a58a3edf581d",
                        index: isAddBox ? null : index,
                      );
                    },
                    onDelete: isAddBox
                        ? null
                        : () {
                            createRestaurantCubit.restaurantImages
                                .removeAt(index);
                            createRestaurantCubit.restaurantImagesIds
                                .removeAt(index);
                            createRestaurantCubit
                                    .createRestaurantParams.restaurantMedia =
                                createRestaurantCubit.restaurantImagesIds;
                            createRestaurantCubit.refreshUI();
                          },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget buildPhotoBox({
  required BuildContext context,
  required bool isAddBox,
  required VoidCallback onTap,
  required XFile? image,
  VoidCallback? onDelete,
}) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.getFillColor(context),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        // color: !isAddBox
        //     ? AppColors.getRedColor(context).withOpacity(0.4)
        //     : Colors.transparent,
        color:  Colors.transparent,
        width: 2,
      ),
    ),
    child: Stack(
      children: [
        // 1) صورة الخلفية
        if (!isAddBox && image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: File(image.path).existsSync()
                ? Image.file(
                    File(image.path),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    Assets.icon,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),

        // 2) InkWell الكبير ليجعل الصندوق بأكمله قابلاً للنقر
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: isAddBox
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          Assets.cameraSvg,
                          width: 45.w,
                          height: 45.w,
                          colorFilter: ColorFilter.mode(
                            AppColors.getRedColor(context),
                            BlendMode.srcIn,
                          ),
                        ),
                        8.verticalSpace,
                        Text(
                          LocaleKeys.addPhoto.localize,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.sp,
                            color: context.isDarkMode
                                ? AppColors.whiteColor
                                : AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),

        // 3) زر الحذف (في الأعلى على اليمين)
        if (!isAddBox && onDelete != null)
          Positioned(
            top: 4,
            right: 4,
            child: InkWell(
              onTap: onDelete,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: AppColors.whiteColor,
                  size: 18.w,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
