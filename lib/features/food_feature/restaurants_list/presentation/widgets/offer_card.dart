import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../subcategories/domain/entities/sub_category_entity.dart';

class FoodOfferCard extends StatelessWidget {
  final SubCategoryEntity item;
  final Function(String) onTap;
  const FoodOfferCard({super.key, required this.onTap, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(item.id),
      child: Container(
        height: kToolbarHeight * 2,
        width: kToolbarHeight * 1.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.SECONDARY_COLOR.withAlpha(100)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Sizer(),
            Expanded(
                child: SquareImage(
              url: item.image,
            )),
            const Sizer(),
            Label(
                textAlign: TextAlign.center,
                text: context.isArabic ? item.nameAr : item.nameEn,
                style: Styles.mediumText()),
            const Sizer(),
          ],
        ),
      ),
    );
  }
}
