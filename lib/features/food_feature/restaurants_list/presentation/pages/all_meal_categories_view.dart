import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../ads/interstitial_ad_model.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../core/widget/custom_circular_progress_indicator.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/app_colors.dart';
import '../cubit/restaurants_list_cubit.dart';
import 'widgets/restaurant_list/meal_category_card.dart';

class AllMealCategoriesView extends StatefulWidget {
  final RestaurantsCubit cubit;

  const AllMealCategoriesView({super.key, required this.cubit});

  @override
  State<AllMealCategoriesView> createState() => _AllMealCategoriesViewState();
}

class _AllMealCategoriesViewState extends State<AllMealCategoriesView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      widget.cubit.fetchSubCategories();
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
    return CustomScaffold(
      enableCustomAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: BackAppBar(
          label: context.locale.languageCode == 'ar'
              ? 'جميع التصنيفات'
              : 'All Categories',
          // backColor: AppColors.getFillColor(context),
        ),
      ),
      body: BlocProvider.value(
        value: widget.cubit,
        child: BlocBuilder<RestaurantsCubit, RestaurantsListState>(
          builder: (context, state) {
            // Debug: Check if we have data
            print(
                '🔍 AllMealCategories: subCategories count = ${widget.cubit.subCategories.length}');
            print('🔍 AllMealCategories: state = ${state.status}');

            if (widget.cubit.subCategories.isEmpty) {
              return const Center(
                child: CustomCircularProgressIndicator(),
              );
            }

            return GridView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemCount: widget.cubit.subCategories.length +
                  (widget.cubit.isLoadingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == widget.cubit.subCategories.length) {
                  return const Center(
                    child: CustomCircularProgressIndicator(),
                  );
                }

                final subCategory = widget.cubit.subCategories[index];

                return MealCategoryCard(
                  onTap: (String id) {
                    AdInterstitialTop.loadIntersitialAd();
                    AdInterstitialTop.showInterstitialAd();
                    widget.cubit.loadInitialRestaurantsData(id);
                    // Return the selected category ID to the parent page
                    Navigator.pop(context, id);
                  },
                  index: index,
                  subCategory: subCategory,
                  favouriteSubCategory: () async {
                    var result = await widget.cubit.toggleFavoriteSubcategory(
                      subCategory.id ?? "",
                    );
                    if (result == true) {
                      widget.cubit.subCategories[index].isFavorite =
                          !(widget.cubit.subCategories[index].isFavorite ??
                              false);
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
