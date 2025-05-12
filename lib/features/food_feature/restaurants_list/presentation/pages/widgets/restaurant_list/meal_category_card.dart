import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import '../../../../../../../res/style/app_colors.dart';

class MealCategoryCard extends StatefulWidget {
  final FoodCategoryEntity? subCategory;
  final Function(String) onTap;
  final Function() favouriteSubCategory;

  const MealCategoryCard(
      {super.key,
      this.subCategory,
      required this.onTap,
      required this.favouriteSubCategory});

  @override
  State<MealCategoryCard> createState() => _MealCategoryCardState();
}

class _MealCategoryCardState extends State<MealCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: widget.subCategory?.isSelected == true ? 0 : null,
        // color: widget.subCategory?.isSelected==true?AppColors.SECONDARY_COLOR:cardDarkColor(context),
        child: SizedBox(
          width: 0.55.sw,
          child: InkWell(
            onTap: () => widget.onTap(widget.subCategory?.id ?? ""),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color:widget.subCategory?.isSelected == true
                        ? AppColors.getRedColor(context):
                    AppColors.getFillColor(context),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 0.5, color: AppColors.black),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    // This makes children fill the width
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                        // Slightly less than container radius to account for border
                        child: widget.subCategory?.fromAsset == true
                            ? Image.asset(
                                widget.subCategory?.image ?? '',
                                fit: BoxFit.cover,
                                // This makes the image fill the space
                                // height: 300.h,
                                width: double.infinity, // Takes full width
                              )
                            : ImageFromInternet(
                                image: widget.subCategory?.picture ?? '',
                                defaultLogo: true,
                                fit: BoxFit.cover,
                                height: 300.h,
                                width: double.infinity,
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        // Add some padding around the title
                        child:  Label(
                          text: (getLang() == "ar"
                              ? widget.subCategory?.nameAr
                              : widget.subCategory?.nameEn) ??
                              "",
                          style: Styles.headerText(
                            color: widget.subCategory?.isSelected == true
                                ?AppColors.getReversedTextColor(context)
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Stack(
                //   children: [
                //     // Heart image
                //     widget.subCategory?.fromAsset == true
                //         ? Image.asset(
                //             widget.subCategory?.image ?? '',
                //             fit: BoxFit.fill,
                //             height: 300.h,
                //             width: 0.55.sw,
                //           )
                //         : ImageFromInternet(
                //             image: widget.subCategory?.picture ?? '',
                //             defaultLogo: true,
                //             height: 300.h,
                //             width: 0.55.sw,
                //           ),
                //     if (context.read<UserCubit>().isLoggedIn &&
                //         widget.subCategory?.id != '')
                //       Positioned(
                //         top: 5,
                //         right: 5,
                //         child: IconAppButton(
                //             size: 25,
                //             icon: widget.subCategory?.isFavorite ?? false
                //                 ? Icons.favorite
                //                 : Icons.favorite_border,
                //             color: AppColors.PRIMARY_COLOR_DARK,
                //             onPressed: () async {
                //               await widget.favouriteSubCategory();
                //             }),
                //       ),
                //   ],
                // ),
                // Container(
                //   width: double.infinity,
                //   color: widget.subCategory?.isSelected == true
                //       ? AppColors.SECONDARY_COLOR
                //       : cardDarkColor(context),
                //   padding: EdgeInsetsDirectional.only(
                //       top: 8.h, end: 10.w, start: 16.w, bottom: 16.h),
                //   child: Label(
                //     text: (getLang() == "ar"
                //             ? widget.subCategory?.nameAr
                //             : widget.subCategory?.nameEn) ??
                //         "",
                //     style: Styles.headerText(
                //       color: widget.subCategory?.isSelected == true
                //           ? Colors.white
                //           : null,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
