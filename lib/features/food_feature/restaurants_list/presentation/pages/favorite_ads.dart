import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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

  // String formatViews(int views) {
  //   if (views >= 1000000) {
  //     return "${(views / 1000000).toStringAsFixed(1)}M";
  //   } else if (views >= 1000) {
  //     return "${(views / 1000).toStringAsFixed(1)}K";
  //   } else {
  //     return views.toString();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantsCubit, RestaurantsListState>(
        builder: (context, state) {
          final controller = context.read<RestaurantsCubit>();
          if (!state.isLoading) {

            return context.read<RestaurantsCubit>().foodAdData.isNotEmpty ? Padding(
              padding: EdgeInsets.symmetric(vertical:  16,horizontal: 10),
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height * .8,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:  context
                    .read<RestaurantsCubit>()
                    .foodAdData
                    .length,
                  itemBuilder: (context,index){
                    var data =  context.read<RestaurantsCubit>().foodAdData[index];
                    return  FavFoodCard(data: data,index: index);
                  },

                ),
              ),
            ): Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * .65, // Make sure it takes up full height
                child: Center( // This will center it vertically and horizontally
                  child: Text(
                    LocaleKeys.noResultsFound.tr(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );

          } else {
            return SizedBox(
              height: MediaQuery.of(context).size.height * .65, // Make sure it takes up full height
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }

}
class FavFoodCard extends StatelessWidget {
  const FavFoodCard({super.key,required this.data, required this.index});
  final GetAllRestaurantEntity data;
  final int index;
  String formatViews(int views) {
    if (views >= 1000000) {
      return "${(views / 1000000).toStringAsFixed(1)}M";
    } else if (views >= 1000) {
      return "${(views / 1000).toStringAsFixed(1)}K";
    } else {
      return views.toString();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: AppColors.getTextColor(context),
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
                  spacing: 4,
                  children: [
                    SvgPicture.asset(
                      Assets.eyeIcon,
                      color:AppColors.getTextColor(context),
                    ),
                    Label(
                      // text: "100k",
                      text: formatViews(data.totalViews!.toInt()),
                      style:  Styles.mediumText(
                        // fontSize: 12,
                        fontWeight: FontWeight.w400,
                        // color: AppColors.c6C6C6C,
                        color:AppColors.getTextColor(context),
                      ),
                    ),
                    Label(
                      text: LocaleKeys.views.localize,
                      style:  Styles.mediumText(
                        // fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color:AppColors.getTextColor(context),
                      ),
                    ),
                  ],
                ),
                Label(
                  text: (context.isArabic ? data.subscriptionType?.ar : data.subscriptionType?.en) ?? "N/A",
                  textAlign: TextAlign.right,
                  style: Styles.mediumText(
                    fontWeight: FontWeight.w700,
                    color:AppColors.getTextColor(context),
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
                    item: data,
                    mealId: "",
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              spacing: 6,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      data.name ?? '',
                      style: Styles.headerText(
                          fontWeight: FontWeight.w600,
                          fontSize: 32
                      ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Label(text: (context.isArabic ? data.rateName?.ar :data.rateName?.en) ?? "N/A",
                          style: Styles.smallText(
                            fontWeight: FontWeight.w600,
                            // fontSize: 16
                          ),
                        ),
                        RatingBar(
                          initialRating: data.totalRating?.toDouble() ?? 0,
                          ignoreGestures: true,
                          allowHalfRating: true,
                          itemPadding: const EdgeInsets.symmetric(horizontal: 3),
                          ratingWidget: RatingWidget(
                            full: SvgPicture.asset(Assets.star1),
                            half: SvgPicture.asset(Assets.halfStar),
                            empty: SvgPicture.asset(Assets.starEmpty,
                              color: AppColors.getTextColor(context)
                            ),
                          ),
                          itemSize: 13,
                          onRatingUpdate: (double value) {},
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      (data.isActive ?? false)
                          ? LocaleKeys.available.localize
                          : LocaleKeys.notAvailable.localize,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: AppColors.getRedColor(context),
                      ),
                    ),
                    Expanded( // <<< حل المشكلة هنا
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.location_on_rounded),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '${context.isArabic ? data.government?.governorateNameAr ?? '' : data.government?.governorateNameEn ?? ''}, ${context.isArabic ? data.city?.cityNameAr ?? '' : data.city?.cityNameEn ?? ''}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: PremiumAndRequestButtons(item: data),
                    ),
                    Flexible(
                      child: CallMessageReportButtons(item: data),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteButtonAds extends StatelessWidget {
  final GetAllRestaurantEntity item;
  final String mealId;
  final Function(String id) favouriteRestaurant;

  const FavoriteButtonAds({
    super.key,
    required this.item,
    required this.mealId,
    required this.favouriteRestaurant,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        (item.isFavorite ?? false) ? Icons.favorite : Icons.favorite,
        color: AppColors.getRedColor(context),
      ),
      onPressed: () async {
        await favouriteRestaurant(item.id!);
      },
    );
  }
}


