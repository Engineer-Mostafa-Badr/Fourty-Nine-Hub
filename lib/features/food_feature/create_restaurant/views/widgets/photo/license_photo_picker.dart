import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/widgets/photo/restaurant_photo_picker.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../res/style/app_colors.dart';

class CreateRestaurantLicensePhotoPicker extends StatelessWidget {
  const CreateRestaurantLicensePhotoPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final createRestaurantCubit = context.read<CreateRestaurantCubit>();

    return BlocBuilder<CreateRestaurantCubit, CreateRestaurantState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Label(
                text: context.isArabic
                    ? 'السجل التجاري'
                    : 'The Commercial Register',
                style: Styles.headerText(fontSize: 40),
              ),
            ),
            const Sizer(),

            // سنعرض 3 صور في صفّ واحد (كل صورة في صندوقها الخاص)
            Row(
              children: [
                // ====================== الصفحة الأولى ======================
                Expanded(
                  child: _buildLicenseBox(
                    context: context,
                    state: state,
                    pageIndex: 0, // أو أي تمييز تريد
                    label: context.isArabic ? 'الصفحة الأولي' : 'First Page',
                    onTap: () => createRestaurantCubit
                        .uploadLicenseFirstPageImage(context: context),
                    // سنبحث عن الملف (XFile) داخل state
                    fileIfAny:
                        context.read<CreateRestaurantCubit>().licenseFirstPage,
                    onDelete: () {
                      // طالما أننا لا نحتفظ بملف مستقل للصفحة الأولى في الـCubit
                      // يكفي حذف العنصر الأول من licensRestaurantImagesIds (إن وُجد)
                      final licList =
                          createRestaurantCubit.licensRestaurantImagesIds;
                      if (licList.isNotEmpty) {
                        licList.removeAt(0);
                        createRestaurantCubit
                            .createRestaurantParams.licenseMedia = licList;
                      }

                      createRestaurantCubit.emit(CreateRestaurantRefreshUI());
                    },
                  ),
                ),
                const Sizer(width: 16),

                // ====================== الصفحة الثانية ======================
                Expanded(
                  child: _buildLicenseBox(
                    context: context,
                    state: state,
                    pageIndex: 1,
                    label: context.isArabic ? 'الصفحة الثانية' : 'Second Page',
                    onTap: () => createRestaurantCubit
                        .uploadLicenseSecondPageImage(context: context),
                    fileIfAny:
                        context.read<CreateRestaurantCubit>().licenseSecondPage,
                    onDelete: () {
                      final licList =
                          createRestaurantCubit.licensRestaurantImagesIds;
                      if (licList.length >= 2) {
                        licList.removeAt(1);
                        createRestaurantCubit
                            .createRestaurantParams.licenseMedia = licList;
                      }
                      createRestaurantCubit.emit(CreateRestaurantRefreshUI());
                    },
                  ),
                ),
                const Sizer(width: 16),

                // ====================== الصفحة الثالثة ======================
                Expanded(
                  child: _buildLicenseBox(
                    context: context,
                    state: state,
                    pageIndex: 2,
                    label: context.isArabic ? 'الصفحة الثالثة' : 'Third Page',
                    onTap: () => createRestaurantCubit
                        .uploadLicenseThiredPageImage(context: context),
                    fileIfAny:
                        context.read<CreateRestaurantCubit>().licenseThirdPage,
                    onDelete: () {
                      final licList =
                          createRestaurantCubit.licensRestaurantImagesIds;
                      if (licList.length >= 3) {
                        licList.removeAt(2);
                        createRestaurantCubit
                            .createRestaurantParams.licenseMedia = licList;
                      }
                      createRestaurantCubit.emit(CreateRestaurantRefreshUI());
                    },
                  ),
                ),
              ],
            ),

            // الخطأ إذا لم يرفع الصفحات الثلاث
            Visibility(
              visible:
                  state is ValidationState && (state.isCommercialPhoto ?? true),
              child: Padding(
                padding: const EdgeInsets.only(right: 5, left: 5, top: 5.0),
                child: Text(
                  LocaleKeys.youHaveToUploadThe3PagesOfCommercialRegistration
                      .localize,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  /// هذه الدالة تُبسّط بناء صندوق كل صفحة (الأولى/الثانية/الثالثة)
  Widget _buildLicenseBox({
    required BuildContext context,
    required CreateRestaurantState state,
    required int pageIndex,
    required String label,
    required VoidCallback onTap,
    required XFile? fileIfAny,
    required VoidCallback onDelete,
  }) {
    // إذا كان لا يوجد ملف => isAddBox = true
    final isAddBox = (fileIfAny == null);

    // لو أردت تغيير العرض ليتناسب مع تصميم الصندوق

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // الصندوق
        buildPhotoBox(
          context: context,
          isAddBox: isAddBox,
          image: fileIfAny,
          onTap: onTap,
          onDelete: onDelete,
        ),
        16.verticalSpace,

        // العنوان (First Page, ... الخ)
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 26.sp),
        ),
      ],
    );
  }
}
