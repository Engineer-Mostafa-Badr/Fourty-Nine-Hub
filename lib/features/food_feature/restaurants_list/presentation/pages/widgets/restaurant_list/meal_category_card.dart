import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../cubit/restaurants_list_cubit.dart';

class MealCategoryCard extends StatefulWidget {
  final FoodCategoryEntity? subCategory;
  final Function(String) onTap;

  const MealCategoryCard({super.key, this.subCategory, required this.onTap});

  @override
  State<MealCategoryCard> createState() => _MealCategoryCardState();
}

class _MealCategoryCardState extends State<MealCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Card(
        clipBehavior: Clip.hardEdge,
        color: cardDarkColor(context),
        child: SizedBox(
          width: 0.55.sw,
          child: InkWell(
            onTap: () => widget.onTap(widget.subCategory?.id ?? ""),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    // Heart image
                    ImageFromInternet(image: widget.subCategory?.picture??'',defaultLogo: true,height: 300.h,width: 0.55.sw,),
                   if(context.read<UserCubit>().isLoggedIn) Positioned(
                      top: 5,
                      right: 5,
                      child: IconAppButton(
                          size: 25,
                          icon: widget.subCategory?.isFavorite ?? false
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: AppColors.PRIMARY_COLOR_DARK,
                          onPressed: () {
                            var result = context
                                .read<RestaurantsCubit>()
                                .toggleFavoriteSubcategory(
                                    widget.subCategory?.id ?? "");
                            if(result == true){
                              widget.subCategory?.isFavorite=!(widget.subCategory?.isFavorite??false);
                              setState(() {});
                            }
                          }),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding:EdgeInsets.symmetric(vertical: 8.h,horizontal: 10.w),
                  child: Label(
                    text: (getLang() == "ar"
                            ? widget.subCategory?.nameAr
                            : widget.subCategory?.nameEn) ??
                        "",
                    style: Styles.headerText(),
                  ),
                ),
                Padding(
                  padding:EdgeInsets.only(bottom: 10.h,left: 10.w,right: 10.w),
                  child: Label(
                    text:
                        '${widget.subCategory?.numberOfRestaurant ?? "0"} ${LocaleKeys.restaurants.tr()}',
                    style: Styles.mediumText(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/*
Container(
  width: 200,
  padding: const EdgeInsets.all(10),
  decoration: BoxDecoration(
    color: Theme.of(context).scaffoldBackgroundColor,
    borderRadius: BorderRadius.circular(10),
  ),
  child: Column(
    children: [
           Sizer(),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Sizer(
                  width: double.infinity,
                ),
              ),
            ],
          ),

        ],
      ),
    ],
  ),
),
*/
