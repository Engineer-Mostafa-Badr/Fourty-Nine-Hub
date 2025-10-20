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
      padding: EdgeInsets.all(
        8,
      ),
      constraints: BoxConstraints(minWidth: 220.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40.h),
          color: subCategory?.isSelected == true
              ? AppColors.getButtonPrimaryColor(context)
              : AppColors.getFillColor(context),
          border: Border.all(
              color: AppColors.getButtonPrimaryColor(context), width: 2)),
      child: Text(
        context.isArabic
            ? (subCategory?.nameAr ?? '')
            : (subCategory?.nameEn ?? ''),
        maxLines: 2,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: Styles.headerText(
            fontSize: 24,
            color: subCategory?.isSelected == true
                ? context.isDarkMode
                    ? Colors.black
                    : Colors.white
                : AppColors.getTextColor(context)),
      ),
    );
  }
}
