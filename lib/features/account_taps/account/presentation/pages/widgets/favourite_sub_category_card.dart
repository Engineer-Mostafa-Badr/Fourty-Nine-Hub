import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/auth_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/ads_feature/ads/presentation/pages/ads_view.dart';
import 'package:fourtyninehub/features/ads_feature/create_ad/domain/entities/categorization_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/subcategories/domain/entities/sub_category_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../../core/localization/locales.dart';
import '../../../../../../core/utils/hex_color_helper.dart';

class FavouriteSubCategoryCard extends StatefulWidget {
  const FavouriteSubCategoryCard(
      {super.key,
      required this.item,
      required this.onFav,
      required this.mainCategory});

  final SubCategoryEntity item;
  final MainCategoryEntity mainCategory;
  final Function() onFav;

  @override
  State<FavouriteSubCategoryCard> createState() =>
      _FavouriteSubCategoryCardState();
}

class _FavouriteSubCategoryCardState extends State<FavouriteSubCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(
        Routes.ADS,
        extra: AdsViewParams(
          mainCategory: widget.mainCategory,
          subCategory: widget.item,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: context.isDarkMode? AppColors.QUANTITY_COLOR : HexColor('E6E7EB'),
          borderRadius: BorderRadius.circular(30.r),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SquareImage(
                      fit: BoxFit.cover,
                      radius: 30.r,
                      url: widget.item.image,
                    ),
                  ),
                  Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: IconAppButton(
                        icon: Icons.favorite,
                        onPressed: () => widget.onFav(),
                        color: AppColors.SECONDARY_COLOR,
                      ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.h,
                vertical: 8.h,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Label(
                          text: context.locale == Locales.english
                              ? widget.item.nameEn
                              : widget.item.nameAr,
                          style: Styles.mediumText(fontWeight: FontWeight.bold,color: context.isDarkMode? Colors.white : Colors.black),
                        ),
                        // Label(
                        //   text:
                        //       '${widget.item.numOfAds} ${LocaleKeys.ad.localize}',
                        //   style: Styles.smallText(fontSize: 40.sp),
                        // )
                      ],
                    ),
                  ),
                  IconAppButton(
                      icon: Icons.add_box_outlined,
                      color: context.isDarkMode? Colors.white : AppColors.PRIMARY_COLOR,
                      size: 40.h,
                      onPressed: () {
                        if (AuthHelper().isLoggedIn()) {
                          context.push(Routes.CREATEAD,
                              extra: CategorizationEntity(
                                  mainCategory: widget.mainCategory,
                                  subCategory: widget.item));
                        } else {
                          return pleaseLoginDialog(context);
                          // context.push(Routes.LOGIN);
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
