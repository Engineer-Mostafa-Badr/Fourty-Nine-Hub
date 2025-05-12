import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class SubCategoryListViewItem extends StatelessWidget {
  const SubCategoryListViewItem({
    super.key,
    required this.subCategory,
  });

  final SubCategoryEntity? subCategory;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 32,
     constraints: BoxConstraints(minWidth: 220.w),
      // width: 116,
      decoration: BoxDecoration(
        color: subCategory?.isSelected == true
            ? AppColors.getButtonPrimaryColor(context)
            : AppColors.getFillColor(context),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Label(
        text: context.isArabic
            ? (subCategory?.nameAr ?? '')
            : (subCategory?.nameEn ?? ''),
        style: Styles.mediumText(
          fontSize: 24,
          color: subCategory?.isSelected == true ? AppColors.getReversedTextColor(context) : AppColors.getTextColor(context),
        ),
      ),
    );
  }
}
