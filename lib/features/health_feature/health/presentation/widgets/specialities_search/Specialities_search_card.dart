import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/health_feature/health/domain/entities/health_subcategory_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class SpecialitiesSearchCard extends StatefulWidget {
  final HealthSubcategoryEntity subCategory;

  const SpecialitiesSearchCard({super.key, required this.subCategory});

  @override
  State<SpecialitiesSearchCard> createState() => _SpecialitiesSearchCardState();
}

class _SpecialitiesSearchCardState extends State<SpecialitiesSearchCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Container(
        height: 140.h,
        decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.PRIMARY_COLOR,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15),
            color: AppColors.GREYBG),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: double.infinity,
              width: 160.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(image: NetworkImage(
                    widget.subCategory.image,

                  ),
                    fit: BoxFit.fill,)
              ),
            ),
            const Sizer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.h),
              child: Text(
                context.isArabic?widget.subCategory.nameAr:widget.subCategory.nameEn,
                style: Styles.headerText(fontSize: 40),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
