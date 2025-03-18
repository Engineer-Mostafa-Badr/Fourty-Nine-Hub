import 'package:flutter/material.dart';
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
      height: 32,
      width: 116,
      decoration: BoxDecoration(
        color: subCategory?.isSelected == true
            ? AppColors.PRIMARY_COLOR
            : const Color(0xffE0E0E0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Label(
        text: context.isArabic
            ? (subCategory?.nameAr ?? '')
            : (subCategory?.nameEn ?? ''),
        style: Styles.mediumText(
          fontSize: 24,
          color: subCategory?.isSelected == true ? Colors.white : null,
        ),
      ),
    );
  }
}
