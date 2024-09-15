import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/CarouselSlider.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/square_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/search_cubit/search_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/search_restaurant_card.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:fourtyninehub/res/strings/labels.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fourtyninehub/res/style/styles.dart';

class SearchRestaurantView extends StatelessWidget {
  const SearchRestaurantView({super.key});

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchRestaurantsCubit>();
    return BlocBuilder<SearchRestaurantsCubit, SearchRestaurantState>(
        builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => searchCubit.back(),
            icon: const Icon(Icons.arrow_back),
          ),
          title:
              Text("${LocaleKeys.search.tr()} ${LocaleKeys.restaurants.tr()}"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              /// top
              TextFormField(
                onChanged: (value) {
                  if (state.status ==
                      SearchRestaurantStates.loadingSubCategories) {
                    context
                        .read<SearchRestaurantsCubit>()
                        .searchSubCategories(value);
                  }
                  if (state.status ==
                      SearchRestaurantStates.loadingGovernorates) {
                    context
                        .read<SearchRestaurantsCubit>()
                        .searchGovernorates(value);
                  }
                  if (state.status == SearchRestaurantStates.loadingCities) {
                    context.read<SearchRestaurantsCubit>().searchCities(value);
                  }
                  if (state.status == SearchRestaurantStates.loadingResult) {
                    context.read<SearchRestaurantsCubit>().searchResult(value);
                  }
                },
                decoration: InputDecoration(
                  hintText: LocaleKeys.search.tr(),
                  prefixIcon: const Icon(Icons.search),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.h),
                  filled: false,
                ),
              ),

              /// data
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (state.status == SearchRestaurantStates.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state.status == SearchRestaurantStates.error) {
                      return RefreshIndicator(
                        onRefresh: () async => searchCubit.refreshState(),
                        child: ListView(
                          children: [
                            Center(
                              child: Text(
                                LocaleKeys.somethingWentWrong.tr(),
                                style: Styles.headerText(),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    /// ------- search sub categories
                    else if (state.status ==
                        SearchRestaurantStates.loadingSubCategories) {
                      return RefreshIndicator(
                        onRefresh: () async => searchCubit.refreshState(),
                        child: ListView.builder(
                          itemCount: state.mealCategories?.length,
                          itemBuilder: (context, index) {
                            FoodCategoryEntity? category =
                                state.mealCategories?[index];
                            return GestureDetector(
                              onTap: () =>
                                  searchCubit.selectSubcategory(category),
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: category?.picture ?? "",
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                  ),
                                  Sizer(),
                                  Text(getLang() == "ar"
                                      ? (category?.nameAr ?? "")
                                      : (category?.nameEn ?? "")),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state.status ==
                        SearchRestaurantStates.loadingSearchSubCategory) {
                      return RefreshIndicator(
                        onRefresh: () async => searchCubit.refreshState(),
                        child: ListView.builder(
                          itemCount: state.searchMealCategories?.length,
                          itemBuilder: (context, index) {
                            FoodCategoryEntity? category =
                                state.searchMealCategories?[index];
                            return GestureDetector(
                              onTap: () =>
                                  searchCubit.selectSubcategory(category),
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: category?.picture ?? "",
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                  ),
                                  Sizer(),
                                  Text(getLang() == "ar"
                                      ? (category?.nameAr ?? "")
                                      : (category?.nameEn ?? "")),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    }

                    /// ------- search governorates
                    else if (state.status ==
                        SearchRestaurantStates.loadingGovernorates) {
                      return RefreshIndicator(
                        onRefresh: () async => searchCubit.refreshState(),
                        child: ListView.builder(
                          itemCount: state.governorates?.length,
                          itemBuilder: (context, index) {
                            GovernorateEntity? governorate =
                                state.governorates?[index];
                            return GestureDetector(
                              onTap: () =>
                                  searchCubit.selectGovernorate(governorate),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text((getLang() == "ar"
                                        ? governorate?.nameAr
                                        : governorate?.nameEn) ??
                                    ''),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state.status ==
                        SearchRestaurantStates.loadingSearchGevnorates) {
                      return RefreshIndicator(
                        onRefresh: () async => searchCubit.refreshState(),
                        child: ListView.builder(
                          itemCount: state.searchGovernorates?.length,
                          itemBuilder: (context, index) {
                            GovernorateEntity? governorate =
                                state.searchGovernorates?[index];
                            return GestureDetector(
                              onTap: () =>
                                  searchCubit.selectGovernorate(governorate),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(getLang() == "ar"
                                    ? (governorate?.nameAr ?? "")
                                    : (governorate?.nameEn ?? "")),
                              ),
                            );
                          },
                        ),
                      );
                    }

                    /// ------- search cities
                    else if (state.status ==
                        SearchRestaurantStates.loadingCities) {
                      return RefreshIndicator(
                        onRefresh: () async => searchCubit.refreshState(),
                        child: ListView.builder(
                          itemCount: state.cities?.length,
                          itemBuilder: (context, index) {
                            CityEntity? city = state.cities?[index];
                            return GestureDetector(
                              onTap: () => searchCubit.selectCity(city),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text((getLang() == "ar"
                                        ? city?.nameAr
                                        : city?.nameAr) ??
                                    ''),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (state.status ==
                        SearchRestaurantStates.loadingSearchCities) {
                      return RefreshIndicator(
                        onRefresh: () async => searchCubit.refreshState(),
                        child: ListView.builder(
                          itemCount: state.searchCities?.length,
                          itemBuilder: (context, index) {
                            CityEntity? city = state.searchCities?[index];
                            return GestureDetector(
                              onTap: () => searchCubit.selectCity(city),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(getLang() == "ar"
                                    ? (city?.nameAr ?? "")
                                    : (city?.nameEn ?? "")),
                              ),
                            );
                          },
                        ),
                      );
                    }

                    /// ------- search result
                    else if ((state.allRestaurant?.isEmpty ?? true) ||
                        (state.searchRestaurant?.isEmpty ?? false)) {
                      return Center(
                        child: Text(
                          LocaleKeys.noResultFound.tr(),
                          style: Styles.headerText(),
                        ),
                      );
                    } else if (state.status ==
                        SearchRestaurantStates.loadingResult) {
                      return RefreshIndicator(
                        onRefresh: () async => searchCubit.refreshState(),
                        child: ListView.builder(
                          itemCount: state.allRestaurant?.length,
                          itemBuilder: (context, index) {
                            Restaurant? restaurant =
                                state.allRestaurant?[index];
                            return SearchRestaurantCard(restaurant: restaurant);
                          },
                        ),
                      );
                    } else if (state.status ==
                        SearchRestaurantStates.loadingSearchResult) {
                      return RefreshIndicator(
                        onRefresh: () async => searchCubit.refreshState(),
                        child: ListView.builder(
                          itemCount: state.searchRestaurant?.length,
                          itemBuilder: (context, index) {
                            Restaurant? restaurant =
                                state.searchRestaurant?[index];
                            return SearchRestaurantCard(restaurant: restaurant);
                          },
                        ),
                      );
                    }

                    /// -------------

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
