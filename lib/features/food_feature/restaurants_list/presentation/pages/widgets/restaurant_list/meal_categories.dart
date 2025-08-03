import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../ads/interstitial_ad_model.dart';
import '../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../core/extensions/context_extension.dart';
import 'meal_category_card.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../res/style/styles.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../../../core/widget/custom_circular_progress_indicator.dart';

import '../../../../../../../res/style/app_colors.dart';
import '../../../cubit/restaurants_list_cubit.dart';
import '../../../../../../../helpers/manage_vibration.dart';

class MealCategories extends StatefulWidget {
  const MealCategories({super.key, required});

  @override
  State<MealCategories> createState() => _MealCategoriesState();
}

class _MealCategoriesState extends State<MealCategories> {
  late ScrollController _scrollController;
  bool isFirstSearchListenerCall = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      context.read<RestaurantsCubit>().fetchSubCategories();
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
        if (context.read<RestaurantsCubit>().subCategories.isNotEmpty) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
      ManageVibration.vibrate();
                    _scrollController.animateTo(
                      _scrollController.position.pixels + 0.8.sw,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Row(
                    children: [
                      const Spacer(),
                      Label(
                        text: context.isArabic ? 'مشاهدة المزيد' : 'See More',
                        style: Styles.mediumText(
                            decoration: TextDecoration.underline,
                            color: AppColors.getRedColor(context)),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.getRedColor(context),
                        size: 0.04.sw,
                      ),
                      const Sizer()
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                        height: 0.25.sh,
                        width: double.infinity,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: context
                                  .read<RestaurantsCubit>()
                                  .subCategories
                                  .length +
                              (context.read<RestaurantsCubit>().isLoadingMore
                                  ? 1
                                  : 0),
                          itemBuilder: (context, index) {
                            if (index ==
                                context
                                    .read<RestaurantsCubit>()
                                    .subCategories
                                    .length) {
                              return const Center(
                                  child: CustomCircularProgressIndicator());
                            }

                            final subCategory = context
                                .read<RestaurantsCubit>()
                                .subCategories[index];
                            return MealCategoryCard(
                              onTap: (String id) {
                                AdInterstitialTop.loadIntersitialAd();
                                AdInterstitialTop.showInterstitialAd();
                                context
                                    .read<RestaurantsCubit>()
                                    .loadInitialRestaurantsData(id);
                              },
                              subCategory: subCategory,
                              favouriteSubCategory: () async {
                                var result = await context
                                    .read<RestaurantsCubit>()
                                    .toggleFavoriteSubcategory(
                                        subCategory.id ?? "");
                                if (result == true) {
                                  context
                                      .read<RestaurantsCubit>()
                                      .subCategories[index]
                                      .isFavorite = !(context
                                          .read<RestaurantsCubit>()
                                          .subCategories[index]
                                          .isFavorite ??
                                      false);
                                }
                              },
                            );
                          },
                        )),
                  ),
                  // if (state.isLoadingMore==true)  const Center(child: CustomCircularProgressIndicator())
                ],
              ),
            ],
          );
        } else {
          return Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Spacer(),
                      Container(
                        width: 50.0,
                        height: 20.0,
                        color: Colors.white, // Shimmer placeholder for text
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        width: 20.0,
                        height: 20.0,
                        color: Colors.white, // Shimmer placeholder for icon
                      ),
                      const SizedBox(width: 8.0),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0.25.sh,
                  width: double.infinity,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5, // Number of shimmer placeholders
                    itemBuilder: (context, index) {
                      return Container(
                        width: 0.55.sw,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          // color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}