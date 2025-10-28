import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../common/functions/helper/lang_helper.dart';
import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../domain/entities/food_category_entity.dart';
import '../../../../../../social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../../../../res/style/styles.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../helpers/manage_vibration.dart';

class MealCategoryCard extends StatefulWidget {
  final FoodCategoryEntity? subCategory;
  final Function(String) onTap;
  final Function() favouriteSubCategory;
  final int index;

  const MealCategoryCard(
      {super.key,
      this.subCategory,
      required this.onTap,
      required this.favouriteSubCategory,
      required this.index});

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
                    color: widget.subCategory?.isSelected == true
                        ? AppColors.getRedColor(context)
                        : AppColors.getFillColor(context),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(width: 0.5, color: AppColors.black),
                  ),
                  child: Stack(
                    children: [
                      Column(
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
                            child: Label(
                              text: (getLang() == "ar"
                                      ? widget.subCategory?.nameAr
                                      : widget.subCategory?.nameEn) ??
                                  "",
                              style: Styles.headerText(
                                color: widget.subCategory?.isSelected == true
                                    ? AppColors.getReversedTextColor(context)
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (widget.index != 0)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            icon: Icon(
                              (widget.subCategory?.isFavorite ?? false)
                                  ? Icons.favorite_outlined
                                  : Icons.favorite_border,
                              color: Colors.red,
                              size: 55.sp,
                            ),
                            onPressed: () {
                              ManageVibration.vibrate();
                              widget.favouriteSubCategory();
                              setState(() {});
                            },
                            visualDensity: const VisualDensity(
                                horizontal: -4, vertical: -4),
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
