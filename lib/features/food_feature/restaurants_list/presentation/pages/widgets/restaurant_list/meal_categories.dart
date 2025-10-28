import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../ads/interstitial_ad_model.dart';
import '../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../core/extensions/context_extension.dart';
import '../../all_meal_categories_view.dart';
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
  final Map<String, GlobalKey> _itemKeys = {};

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

  void _scrollToCategory(String categoryId, RestaurantsCubit cubit) {
    // Find the index of the selected category
    final index = cubit.subCategories.indexWhere((cat) => cat.id == categoryId);

    if (index == -1) {
      log('⚠️ Category not found: $categoryId');
      return;
    }

    // Wait for the frame to complete, then scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      // Step 1: Calculate approximate position and scroll there first
      final screenWidth = MediaQuery.of(context).size.width;
      final approximateItemWidth =
          0.55 * screenWidth + 16.0; // card width + spacing
      final approximatePosition = (index * approximateItemWidth) -
          (screenWidth / 2) +
          (approximateItemWidth / 2);

      // Clamp to valid range
      final maxScroll = _scrollController.position.maxScrollExtent;
      final clampedPosition = approximatePosition.clamp(0.0, maxScroll);

      // Scroll to approximate position first (this builds the widget)
      _scrollController.jumpTo(clampedPosition);

      // Step 2: Use ensureVisible for precise positioning after a short delay
      Future.delayed(const Duration(milliseconds: 100), () {
        final key = _itemKeys[categoryId];
        if (key != null && key.currentContext != null) {
          try {
            Scrollable.ensureVisible(
              key.currentContext!,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              alignment: 0.5, // Center alignment
            );
            log('✅ Scrolled to category: $categoryId at index $index');
          } catch (e) {
            log('❌ Error in ensureVisible: $e');
          }
        } else {
          log('⚠️ Widget not built yet for category: $categoryId');
        }
      });
    });
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
                  onTap: () async {
                    log("see more");
                    ManageVibration.vibrate();

                    // Navigate and wait for the selected category ID
                    final selectedCategoryId = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AllMealCategoriesView(cubit: controller),
                      ),
                    );

                    // If a category was selected, scroll to it
                    if (selectedCategoryId != null &&
                        selectedCategoryId.isNotEmpty) {
                      _scrollToCategory(selectedCategoryId, controller);
                    }
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

                            // Create or get key for this category
                            final categoryId = subCategory.id ?? '';
                            _itemKeys.putIfAbsent(
                                categoryId, () => GlobalKey());

                            return Container(
                              key: _itemKeys[categoryId],
                              child: MealCategoryCard(
                                index: index,
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
                              ),
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
            baseColor:
                context.isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
            highlightColor:
                context.isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    children: [
                      const Spacer(),
                      Container(
                        width: 80.0,
                        height: 16.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Container(
                        width: 16.0,
                        height: 16.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
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
                        const SizedBox(width: 12.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 0.55.sw,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image placeholder
                            Container(
                              width: double.infinity,
                              height: 0.15.sh,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12.0),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title placeholder
                                  Container(
                                    width: double.infinity,
                                    height: 16.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  // Subtitle placeholder
                                  Container(
                                    width: 0.3.sw,
                                    height: 12.0,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(4.0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
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
