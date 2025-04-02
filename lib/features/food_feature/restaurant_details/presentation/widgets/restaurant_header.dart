import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/Images_profile_for_restaurant.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
class RestaurantHeader extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantHeader({Key? key, required this.restaurant}) : super(key: key);

  @override
  State<RestaurantHeader> createState() => _RestaurantHeaderState();
}

class _RestaurantHeaderState extends State<RestaurantHeader> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.restaurant.isFavorite == true;
  }

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.of(context).size.width * 0.5;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          width: double.infinity,
          height: imageHeight,
          child: Stack(
            fit: StackFit.expand,
            children: [
              ImagesProfileForRestaurant(
                autoPlay: true,
                restaurantMedia: widget.restaurant.restaurantMedia,
                heightCarousel: imageHeight,
                widthForImages: MediaQuery.of(context).size.width,
              ),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),

              // (3) البيانات النصية (الاسم والتقييم)
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: Padding(
                  padding: EdgeInsets.all(30.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.restaurant.name ?? '',
                        style: Styles.headerText(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: AppColors.ACCENT_COLOR,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.restaurant.totalRating ?? '0.0'} ',
                                  style: Styles.mediumText(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          10.horizontalSpace,
                          Text(
                            '(${widget.restaurant.numberOfReviews ?? 0} ${LocaleKeys.reviews.localize})',
                            style: Styles.mediumText(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // (4) زر المفضّلة في أعلى اليمين
             Align(
              alignment: AlignmentDirectional.topStart,
                child: IconButton(
                  iconSize: 32,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.redAccent,
                  ),
                  onPressed: () async {
                    /// استدعاء Cubit لعمل Toggle
                    final success = await context
                        .read<RestaurantDetailsCubit>()
                        .toggleFavoriteRestaurant(widget.restaurant.id ?? "",context);

                    if (success) {
                      /// إذا نجح الطلب، اقلب الحالة المحلية وأظهر Snackbar
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                  
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
