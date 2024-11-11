import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/functions/helper/auth_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/entities/favourite_subcategory_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/localization/locales.dart';

class FavouriteSubCategoryCard extends StatefulWidget {
  const FavouriteSubCategoryCard(
      {super.key, required this.item, required this.onFav});

  final FavouriteSubcategoryEntity item;
  final Function() onFav;

  @override
  State<FavouriteSubCategoryCard> createState() =>
      _FavouriteSubCategoryCardState();
}

class _FavouriteSubCategoryCardState extends State<FavouriteSubCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => context.push(Routes.ADS,
      //     extra: AdsViewParams(
      //         mainCategory: widget.mainCategory,
      //         subCategory: widget.item,
      //     ),),
      child: Container(
        margin: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10.r),
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
                      url: widget.item.picture,
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
            const Sizer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                          style: Styles.mediumText(fontWeight: FontWeight.bold),
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
                      icon: Icons.add_box_rounded,
                      size: 40.h,
                      onPressed: () {
                        if (AuthHelper().isLoggedIn()) {
                          // context.push(Routes.CREATEAD,
                          //     extra: CategorizationEntity(
                          //         mainCategory: mainCategory,
                          //         subCategory: item));
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
