import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/main_categry_entity.dart';
import 'package:fourtyninehub/features/chance_feature/domain/entity/sup_category_entity.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/pages/chance_details_view.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/image_card_widget.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/subscribe_widget_in_card.dart';
import 'package:fourtyninehub/features/chance_feature/presentation/widgets/rate_product_widget.dart';

import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../domain/entity/chance_entity.dart';
import '../../domain/entity/image_chance_entity.dart';

class ChanceCardWidget extends StatelessWidget {
  const ChanceCardWidget({
    super.key,
    required this.chance,
    required this.image, required this.subCategoryEntity, required this.mainCategoryEntity,
  });

  final ChanceEntity chance;
  final ImageChanceEntity image;
  final SubCategoryEntity subCategoryEntity;

  final MainCategoryEntity mainCategoryEntity;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChanceDetailsView(
                      chance: chance,
                      image: image,
                      subCategoryEntity: subCategoryEntity.nameEn,
                      mainCategoryEntity: mainCategoryEntity.nameEn,
                    )));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: AppColors.SHADOW_LIGHT,
        ),
        child: Row(
          children: [
            ImageCardWidget(
              image: image.photo,
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chance.description,
                    style: Styles.mediumText(fontSize: 50.sp),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${chance.price}',
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        'EGP',
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.SECONDARY_COLOR,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  const NotSubscribedWidget(),
                  SizedBox(height: 20.h),
                  const LinerProgressIndicator(
                    
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// 'assets/images/doctor.png'
