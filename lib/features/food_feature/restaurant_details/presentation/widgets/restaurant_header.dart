import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_details/presentation/cubit/restaurant_details_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/Images_profile_for_restaurant.dart';
import 'package:go_router/go_router.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
class RestaurantHeader extends StatefulWidget {
  final GetAllRestaurantEntity restaurant;

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
              // Restaurant images
              ImagesProfileForRestaurant(
                autoPlay: true,
                restaurantMedia: widget.restaurant.restaurantMedia,
                heightCarousel: imageHeight,
                widthForImages: MediaQuery.of(context).size.width,
              ),
              // Overlay gradient
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

              // Text section (restaurant name, favorite icon, and review rating)
              Padding(
                padding: EdgeInsets.all(30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Restaurant name
                        IconButton(
                          iconSize: 32,
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.redAccent,
                          ),
                          onPressed: () async {
                            if (context.isUserLoggedIn) {
                              final success = await context
                                  .read<RestaurantDetailsCubit>()
                                  .toggleFavoriteRestaurant(
                                  widget.restaurant.id ?? "", context);
                              if (success) {
                                setState(() {
                                  isFavorite = !isFavorite;
                                });
                              }
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    LocaleKeys.pleaseLoginRegisterToEnjoyTheApp.localize,
                                    style: Styles.smallText(
                                        color: AppColors.whiteColor
                                    ),
                                  ),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 4),
                                  action: SnackBarAction(
                                    label: LocaleKeys.login.localize,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      context.push(Routes.LOGIN);
                                    },
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      RatingBar(
                                        initialRating: widget.restaurant.totalRating?.toDouble() ?? 0,
                                        ignoreGestures: true,
                                        allowHalfRating: true,
                                        itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                                        ratingWidget: RatingWidget(
                                          full: SvgPicture.asset(Assets.star1),
                                          half: SvgPicture.asset(Assets.halfStar),  // <-- same as full!
                                          empty: SvgPicture.asset(Assets.starEmpty),
                                        ),
                                        itemSize: 13,
                                        onRatingUpdate: (double value) {},
                                      ),
                                      Text(
                                        '${widget.restaurant.totalRating ?? '0.0'} ',
                                        style: Styles.mediumText(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.PRIMARY_COLOR
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  '(${widget.restaurant.numberOfReviews ?? 0} ${LocaleKeys.review.localize})',
                                  style: Styles.mediumText(
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                        // Favorite icon

                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
