import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/search_cubit/search_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/Images_profile_for_restaurant.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchRestaurantCard extends StatefulWidget {
  const SearchRestaurantCard({
    super.key,
    required this.restaurant,
  });

  final Restaurant? restaurant;

  @override
  State<SearchRestaurantCard> createState() => _SearchRestaurantCardState();
}

class _SearchRestaurantCardState extends State<SearchRestaurantCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(Routes.RESTAURANTDETAILS,
            extra: widget.restaurant?.id);
      },
      child: Card(
        margin: const EdgeInsets.only(top: 10),
        color: Colors.white,
        elevation: 5,
        shape: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.h),
              decoration: const BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.YELLOW_COLOR,
                    AppColors.ACCENT_COLOR,
                  ],
                ),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.workspace_premium_outlined,
                    color: Colors.black,
                    size: 25,
                  ),
                  Sizer(),
                  Text(
                    LocaleKeys.premium.tr(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            ImagesProfileForRestaurant(
              restaurantMedia: widget.restaurant?.restaurantMedia,
              heightCarousel: MediaQuery.of(context).size.width * 0.72,
              widthForImages: MediaQuery.of(context).size.width,
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// first row
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(
                          text: widget.restaurant?.name ?? "",
                          style: Styles.mediumText(
                              fontSize: 18.sp, fontWeight: FontWeight.w500)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<SearchRestaurantsCubit,
                              SearchRestaurantState>(builder: (context, state) {
                            return Label(
                              text: widget.restaurant?.subcategoryId?.name ??
                                  "${getLang() == "ar" ? state.selectedMealCategory?.nameAr : state.selectedMealCategory?.nameEn}",
                              style: Styles.mediumText(
                                  fontSize: 15.sp,
                                  color: AppColors.PRIMARY_COLOR_DARK),
                            );
                          }),
                          Label(
                            text: "${LocaleKeys.comma.tr()} ",
                            style: Styles.mediumText(
                                fontSize: 15.sp,
                                color: AppColors.PRIMARY_COLOR_DARK),
                          ),
                          Label(
                            text: (getLang() == "ar"
                                    ? widget.restaurant?.mainCategoryId?.nameAr
                                    : widget
                                        .restaurant?.mainCategoryId?.nameEn) ??
                                LocaleKeys.meal.tr(),
                            style: Styles.mediumText(
                                fontSize: 15.sp,
                                color: AppColors.PRIMARY_COLOR_DARK),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),

                  /// second row
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: AppColors.ACCENT_COLOR,
                          ),
                          Sizer(),
                          Label(
                              text: '${widget.restaurant?.totalRating}',
                              style: Styles.mediumText(
                                  fontWeight: FontWeight.w500)),
                          Label(
                              text: '(${widget.restaurant?.numberOfReviews}+)',
                              style: Styles.mediumText()),
                        ],
                      ),
                      Label(
                        text:
                            "${widget.restaurant?.menu?.length ?? 0} ${LocaleKeys.meals.tr()}",
                        style: Styles.mediumText(
                          fontSize: 15.sp,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
