import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/images/square_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../data/models/food_category_model.dart';

class FoodOfferCard extends StatelessWidget {
  final FoodCategoryModel item;
  const FoodOfferCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:()=> context.push(Routes.CusineRestaurants),
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
            Expanded(child: SquareImage(source: NetworkImage(item.image))),
            const Sizer(),
            Label(
                textAlign: TextAlign.center,
                text: item.name,
                style: Styles.mediumText()),
            const Sizer(),
          ],
        ),
      ),
    );
  }
}
