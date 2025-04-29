import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/expired_requests_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/data/shared/shared.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../domain/entities/food_ads_entity.dart';
import '../../domain/entities/restaurant.dart';
import '../cubit/restaurants_list_cubit.dart';
import '../widgets/Images_profile_for_restaurant.dart';
import '../widgets/subcatigories_restaurant_card.dart';

class RestaurantFavAdsScreen extends StatefulWidget {
  const  RestaurantFavAdsScreen({super.key, this.onClose});
  final VoidCallback? onClose;

  @override
  State<RestaurantFavAdsScreen> createState() =>
      _RestaurantFavAdsScreenState();
}

class _RestaurantFavAdsScreenState
    extends State<RestaurantFavAdsScreen> {
  late ScrollController _scrollController;
  bool isFirstSearchListenerCall = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<RestaurantsCubit>().getFoodAds();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsCubit, RestaurantsListState>(
        builder: (context, state) {
          final controller = context.read<RestaurantsCubit>();
          if (!state.isLoading) {

            return SizedBox(
              height: MediaQuery.sizeOf(context).height * .8,
              child: ListView.builder(
                itemCount:  context
                  .read<RestaurantsCubit>()
                  .foodAdData
                  .length,
                itemBuilder: (context,index){
                  var data =  context.read<RestaurantsCubit>().foodAdData[index];
                  return  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: context.isDarkMode ?  AppColors.whiteColor.withOpacity(0.7) : AppColors.black.withOpacity(0.7),
                            width: 1
                        ),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.symmetric(
                              vertical: 8, horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    Assets.eyeIcon,
                                    color:context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,
                                  ),
                                  Label(
                                    text: "100k",
                                    // text: formatViews(item.totalViews!.toInt()),
                                    style:  Styles.mediumText(
                                      // fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      // color: AppColors.c6C6C6C,
                                      color:context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,
                                    ),
                                  ),
                                  Label(
                                    text: LocaleKeys.views.localize,
                                    style:  Styles.mediumText(
                                      // fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color:context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,
                                    ),
                                  ),
                                ],
                              ),
                              Label(
                                text: ( "Premium"),
                                textAlign: TextAlign.right,
                                style: Styles.mediumText(
                                  fontWeight: FontWeight.w700,
                                  color:context.isDarkMode ? AppColors.whiteColor :  AppColors.PRIMARY_COLOR_DARK,
                                  // fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: ImagesProfileForRestaurant(
                                heightCarousel: 150,
                                autoPlay: true,
                                restaurantMedia: data.restaurantMedia,
                              ),
                            ),
                            if (context.read<UserCubit>().isLoggedIn)
                              Positioned(
                                top: 0,
                                left: 0,
                                child: FavoriteButtonAds(
                                  index: index,
                                  item: data,
                                  mealId: '',
                                  favouriteRestaurant: (String id) async {
                                    var result = await context
                                        .read<RestaurantsCubit>()
                                        .toggleFavoriteRestaurant(id);
                                    if (result == true) {
                                      context.read<RestaurantsCubit>().restaurants[index].isFavorite
                                      = !context.read<RestaurantsCubit>().restaurants[index].isFavorite!;

                                    }
                                  },
                                ),
                              ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              data.name ?? '',
                              style:
                              const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                "${context.isArabic ? data.subcategoryId?.nameAr : data.subcategoryId?.nameEn ?? ''}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },

              ),
            );

          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

}

class FavoriteButtonAds extends StatelessWidget {
  final GetAllRestaurantEntity item;
  final String mealId;
  final int index;
  final Function(String id) favouriteRestaurant;

  const FavoriteButtonAds({
    super.key,
    required this.item,
    required this.mealId,
    required this.index,
    required this.favouriteRestaurant,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        (item.isFavorite ?? false) ? Icons.favorite : Icons.favorite,
        color: AppColors.SECONDARY_COLOR,
      ),
      onPressed: () async {
        await favouriteRestaurant(item.id!);
      },
    );
  }
}



/*
            return context.read<RestaurantsCubit>().foodAdData.isNotEmpty
                ? ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: context
                  .read<RestaurantsCubit>()
                  .foodAdData
                  .length,
              separatorBuilder: (context, index) => const Sizer(),
              itemBuilder: (context, i) {

                return Column(
                  children: [
                    SubCategoriesRestaurantCard(
                      item: context
                          .read<RestaurantsCubit>()
                          .foodAdData[i],
                      mealId: '',
                      favouriteRestaurant: (String id) async {
                        var result = await context
                            .read<RestaurantsCubit>()
                            .toggleFavoriteRestaurant(id);
                        if (result == true) {
                          context.read<RestaurantsCubit>().foodAdData[i].isFavorite = !context.read<RestaurantsCubit>().foodAdData[i].isFavorite!;

                        }
                      },
                    ),
                  ],
                );
              },
            )
                : Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Text(
                  context.isArabic
                      ? "لا توجد مطاعم متوفرة."
                      : "No Restaurants Found.",
                  style: Styles.mediumText(),
                ),
              ),
            );
 */
// class TripRequestCard extends StatelessWidget {
//   final GetAllRestaurantEntity orderData;
//
//   const TripRequestCard({super.key, required this.orderData});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card();
//   }
//
// }
// class DetailsSection extends StatelessWidget {
//   final FoodAdEntity item;
//
//   final bool myRestaurant;
//
//   const DetailsSection(
//       {super.key, required this.item, required this.myRestaurant});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       // height: MediaQuery.sizeOf(context).height * 0.2,
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         // mainAxisAlignment: MainAxisAlignment.spaceAround,
//         spacing: 6,
//         children: [
//           const SizedBox(
//             height: 8,
//           ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 item.title ?? '',
//                 style:
//                 const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
//               ),
//               const SizedBox(width: 5),
//               Expanded(
//                 child: Text(
//                   "${context.isArabic ? item.subCategory?.nameAr : item.subCategory?.nameEn ?? ''}",
//                   style: const TextStyle(
//                       fontWeight: FontWeight.w600, fontSize: 12),
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           if (!myRestaurant)
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Row(
//                   children: [
//                     Label(text: (context.isArabic ? item.rateName?.ar :item.rateName?.en) ?? "N/A",
//                       style: Styles.smallText(
//                         fontWeight: FontWeight.w600,
//                         // fontSize: 16
//                       ),
//                     ),
//                     RatingBar(
//                       initialRating: item.totalRating?.toDouble() ?? 0,
//                       ignoreGestures: true,
//                       allowHalfRating: true,
//                       itemPadding: const EdgeInsets.symmetric(horizontal: 3),
//                       ratingWidget: RatingWidget(
//                         full: SvgPicture.asset(Assets.star1),
//                         half: SvgPicture.asset(Assets.halfStar),
//                         empty: SvgPicture.asset(Assets.starEmpty,
//                           color: context.isDarkMode ? AppColors.whiteColor : AppColors.PRIMARY_COLOR,
//                         ),
//                       ),
//                       itemSize: 13,
//                       onRatingUpdate: (double value) {},
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           if (myRestaurant)
//             Row(
//               // mainAxisAlignment: MainAxisAlignment.end,
//               // crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                     textAlign: TextAlign.end,
//                     '${context.isArabic ? item.government?.governorateNameAr ?? '' : item.government?.governorateNameEn ?? ''}, ${context.isArabic ? item.city?.cityNameAr : item.city?.cityNameEn ?? ''}',
//                     style: Styles.mediumText()),
//                 const Spacer(),
//                 const Icon(
//                   Icons.star_rounded,
//                   color: AppColors.ACCENT_COLOR,
//                 ),
//                 const Sizer(),
//                 Label(
//                   text: '${item.totalRating}',
//                   style: Styles.mediumText(fontWeight: FontWeight.w500),
//                 ),
//                 Label(
//                   text: '(${item.numberOfReviews}+)',
//                   style: Styles.mediumText(),
//                 ),
//               ],
//             )
//           else
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 if (!myRestaurant)
//                   Text(
//                     (item.isActive ?? false)
//                         ? LocaleKeys.available.localize
//                         : LocaleKeys.notAvailable.localize,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 12,
//                       color: AppColors.SECONDARY_COLOR,
//                     ),
//                   ),
//                 Expanded( // <<< حل المشكلة هنا
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       const Icon(Icons.location_on_rounded),
//                       SizedBox(width: 4),
//                       Flexible(
//                         child: Text(
//                           '${context.isArabic ? item.government?.governorateNameAr ?? '' : item.government?.governorateNameEn ?? ''}, ${context.isArabic ? item.city?.cityNameAr ?? '' : item.city?.cityNameEn ?? ''}',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 12,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             )
//
//         ],
//       ),
//     );
//   }
// }