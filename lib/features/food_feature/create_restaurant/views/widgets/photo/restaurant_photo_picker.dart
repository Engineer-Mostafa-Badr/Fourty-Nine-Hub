import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/image_picker_placeholder.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/app_colors.dart';

class CreateRestaurantProfilePhotoPicker extends StatefulWidget {
  final String? subcategoryId;

  const CreateRestaurantProfilePhotoPicker({Key? key, this.subcategoryId})
      : super(key: key);

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
        // سنختصر الوصول للصور والمصفوفة هنا
        final images = createRestaurantCubit.restaurantImages;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // العنوان
            Center(
              child: Label(
                text: LocaleKeys.photoForRestaurant.localize,
                style: Styles.headerText(fontSize: 40),
              ),
            ),

            15.verticalSpace,

            Column(children: [
              ...List.generate(
                images.length + 1,
                (index) {
                  final bool isAddBox = (index == images.length);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: buildPhotoBox(
                      context: context,
                      isAddBox: isAddBox,
                      image: isAddBox ? null : images[index],
                      onTap: () async {

                        await createRestaurantCubit.uploadProfileImage(
                          context: context,
                          subcategoryId: widget.subcategoryId,
                          index: isAddBox ? null : index,
                        );
                        setState(() {});
                      },
                      onDelete: isAddBox
                          ? null
                          : () {
                              // حذف الصورة
                              createRestaurantCubit.restaurantImages
                                  .removeAt(index);
                              createRestaurantCubit.restaurantImagesIds
                                  .removeAt(index);
                              createRestaurantCubit
                                      .createRestaurantParams.restaurantMedia =
                                  createRestaurantCubit.restaurantImagesIds;
                              setState(() {});
                            },
                    ),
                  );
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.addPhoto.localize,
                    style:
                        TextStyle(fontSize: 26.sp, fontWeight: FontWeight.w400),
                  ),
                  8.verticalSpace,
                  Container(
                    width: 210.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.SECONDARY_COLOR_DARK2,
                    ),
                    child: IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () async {
                        // لو isAddBox = true => إضافة جديدة
                        // لو false => استبدال الصورة
                        await createRestaurantCubit.uploadProfileImage(
                          context: context,
                          subcategoryId: widget.subcategoryId,
                          //   index: isAddBox ? null : index,
                        );
                        setState(() {});
                      },
                      icon: Icon(Icons.add),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ]),
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
  double? width,
}) {
  return Container(
    width: width ?? double.infinity,
    height: 200.h,
    decoration: BoxDecoration(
      color: AppColors.BG_GRAY_COLOR,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Stack(
      children: [
        // 1) صورة الخلفية
        if (!isAddBox && image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.file(
              File(image.path),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
          ),

        // 2) InkWell الكبير ليجعل الصندوق بأكمله قابلاً للنقر (إضافة / استبدال صورة)
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Center(
              child: isAddBox
                  ? SvgPicture.asset(Assets.cameraSvg)
                  : const SizedBox.shrink(),
            ),
          ),
        ),

        // 3) زر الحذف (في الأعلى على اليمين)
        if (!isAddBox && onDelete != null)
          Positioned(
            top: 6,
            right: 6,
            child: InkWell(
              onTap: onDelete, // <-- الآن سيعمل
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                radius: 15,
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 36.w,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
