import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/auth_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/src/components/screen_util/core/size_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../domain/entities/sub_category_entity.dart';

class SubCategoryCard extends StatelessWidget {
  final SubCategoryEntity item;
  final MainCategoryEntity mainCategory;

  const SubCategoryCard(
      {super.key, required this.item, required this.mainCategory});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(Routes.ADS, extra: AdsViewParams(mainCategory: mainCategory, subCategory: item)),
      child: Container(
        margin: EdgeInsets.all(10.zW),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(5),
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 1,
                  offset: Offset(-1, 1),
                  blurRadius: 5)
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SquareImage(
                      fit: BoxFit.cover,
                      radius: 5,
                      url: item.image,
                    ),
                  ),
                  Positioned(
                      top: 10.zH,
                      right: 10.zW,
                      child: IconAppButton(
                        icon: Icons.favorite_outline,
                        onPressed: () {},
                        color: AppColors.SECONDARY_COLOR,
                      ))
                ],
              ),
            ),
            const Sizer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0.zW),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(
                          text: item.name,
                          style: Styles.mediumText(fontWeight: FontWeight.bold),
                        ),
                        Label(
                          text: 'dd ${LocaleKeys.ads.localize}',
                          style: Styles.smallText(fontSize: 25),
                        )
                      ],
                    ),
                  ),
                  IconAppButton(
                      icon: Icons.add_box_rounded,
                      size: 40.zH,
                      onPressed: () {
                        if (AuthHelper().isLoggedIn()) {
                          context.push(Routes.CREATEAD,
                              extra: CategorizationEntity(
                                  mainCategory: mainCategory,
                                  subCategory: item));
                        } else {
                          context.push(Routes.LOGIN);
                        }
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
