import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/lang_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/food_category_entity.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/entities/restaurant.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/search_cubit/search_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/search_restaurant_card.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/city.dart';
import 'package:fourtyninehub/features/health_feature/create_doctor/domain/entities/governorate_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';

import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../core/widget/olx_pagination/banner.dart';
import '../../../../../core/widget/olx_pagination/olx_pagination_widget.dart';

class SearchRestaurantView extends StatelessWidget {
  const SearchRestaurantView({super.key, this.onClose});

  final VoidCallback? onClose; // Callback to hide search UI
  final FocusNode? focusNode;
  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchRestaurantsCubit>();
    return BlocBuilder<SearchRestaurantsCubit, SearchRestaurantState>(
        builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            /// top
            TextFormField(
              onChanged: (value) {
                if (state.status ==
                        SearchRestaurantStates.loadingSubCategories ||
                    state.status ==
                        SearchRestaurantStates.loadingSearchSubCategory) {
                  context
                      .read<SearchRestaurantsCubit>()
                      .searchSubCategories(value);
                }
                if (state.status ==
                        SearchRestaurantStates.loadingGovernorates ||
                    state.status ==
                        SearchRestaurantStates.loadingSearchGevnorates) {
                  context
                      .read<SearchRestaurantsCubit>()
                      .searchGovernorates(value);
                }
                if (state.status == SearchRestaurantStates.loadingCities ||
                    state.status ==
                        SearchRestaurantStates.loadingSearchCities) {
                  context.read<SearchRestaurantsCubit>().searchCities(value);
                }
                if (state.status == SearchRestaurantStates.loadingResult ||
                    state.status ==
                        SearchRestaurantStates.loadingSearchResult) {
                  context.read<SearchRestaurantsCubit>().searchResult(value);
                }
              },
              decoration: InputDecoration(
                hintText: LocaleKeys.search.tr(),
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: context.isDarkMode
                        ? AppColors.whiteColor
                        : AppColors.PRIMARY_COLOR),
                prefixIcon: const Icon(Icons.search),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                filled: false,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                      color: context.isDarkMode
                          ? AppColors.whiteColor
                          : AppColors.PRIMARY_COLOR,
                      width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide: BorderSide(
                      color: context.isDarkMode
                          ? AppColors.whiteColor
                          : AppColors.PRIMARY_COLOR,
                      width: 2),
                ),
              ),
              focusNode: focusNode,
            ),

            /// data
            SizedBox(
              height: MediaQuery.sizeOf(context).height * .7,
              child: Builder(
                builder: (context) {
                  if (state.status == SearchRestaurantStates.loading) {
                    return const Center(
                      child: CustomCircularProgressIndicator(),
                    );
                  } else if (state.status == SearchRestaurantStates.error) {
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        Center(
                          child: Text(
                            LocaleKeys.somethingWentWrong.tr(),
                            style: Styles.headerText(),
                          ),
                        ),
                      ],
                    );
                  }

                  /// ------- search sub categories
                  else if (state.status ==
                      SearchRestaurantStates.loadingSubCategories) {
                    return Expanded(
                      child: OlxPaginationWidget(
                        itemsPerPage: 3,
                        loadPage: (page) async {},
                        banners: bannersList,
                        items: List.generate(
                          state.mealCategories?.length ?? 0,
                              (index) {
                                FoodCategoryEntity? category =
                                state.mealCategories?[index];
                            return GestureDetector(
                              onTap: () =>
                                  searchCubit.selectSubcategory(category),
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: category?.picture ?? "",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          width: 150.w,
                                          height: 150.h,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey.shade300,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.PRIMARY_COLOR
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 3,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                    width: 150.w,
                                  ),
                                  const Sizer(),
                                  Text(getLang() == "ar"
                                      ? (category?.nameAr ?? "")
                                      : (category?.nameEn ?? "")),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                   /* return ListView.separated(
                      itemCount: state.mealCategories?.length ?? 0,
                      padding: EdgeInsets.all(10.w),
                      separatorBuilder: (context, index) => Sizer(
                        height: 0.h,
                      ),
                      itemBuilder: (context, index) {
                        FoodCategoryEntity? category =
                            state.mealCategories?[index];
                        return GestureDetector(
                          onTap: () => searchCubit.selectSubcategory(category),
                          child: Row(
                            children: [
                              CachedNetworkImage(
                                imageUrl: category?.picture ?? "",
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  width: 150.w,
                                  height: 150.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    // boxShadow: [
                                    //   BoxShadow(
                                    //     color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
                                    //     spreadRadius: 2,
                                    //     blurRadius: 3,
                                    //     offset: const Offset(0, 3),
                                    //   ),
                                    // ],
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                width: 150.w,
                              ),
                              Sizer(
                                width: 40.w,
                              ),
                              Label(
                                text: getLang() == "ar"
                                    ? (category?.nameAr ?? "")
                                    : (category?.nameEn ?? ""),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      },
                    );*/
                  } else if (state.status ==
                      SearchRestaurantStates.loadingSearchSubCategory) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height*.7,
                      child: RefreshIndicator(
                        onRefresh: () async => searchCubit.refreshState(),
                        child: OlxPaginationWidget(
                          itemsPerPage: 3,
                          loadPage: (page) async {},
                          banners: bannersList,
                          items: List.generate(
                            state.searchMealCategories!.length,
                            (index) {
                              FoodCategoryEntity? category =
                                  state.searchMealCategories?[index];
                              return GestureDetector(
                                onTap: () =>
                                    searchCubit.selectSubcategory(category),
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: category?.picture ?? "",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: 150.w,
                                        height: 150.h,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey.shade300,
                                            boxShadow: [
                                              BoxShadow(
                                                color: AppColors.PRIMARY_COLOR
                                                    .withOpacity(0.5),
                                                spreadRadius: 2,
                                                blurRadius: 3,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      width: 150.w,
                                    ),
                                    const Sizer(),
                                    Text(getLang() == "ar"
                                        ? (category?.nameAr ?? "")
                                        : (category?.nameEn ?? "")),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        /* ListView.builder(
                          itemCount: state.searchMealCategories?.length,
                          padding: EdgeInsets.all(15.w),
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
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          width: 150.w,
                                          height: 150.h,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey.shade300,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: AppColors.PRIMARY_COLOR
                                                      .withOpacity(0.5),
                                                  spreadRadius: 2,
                                                  blurRadius: 3,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              )),
                                        ),
                                    width: 150.w,
                                  ),
                                  const Sizer(),
                                  Text(getLang() == "ar"
                                      ? (category?.nameAr ?? "")
                                      : (category?.nameEn ?? "")),
                                ],
                              ),
                            );
                          },
                        ),*/
                      ),
                    );
                  }

                  /// ------- search governorates
                  else if (state.status ==
                      SearchRestaurantStates.loadingGovernorates) {
                    return ListView.separated(
                      shrinkWrap: true,
                      itemCount: state.governorates?.length ?? 0,
                      itemBuilder: (context, index) {
                        GovernorateEntity? governorate =
                            state.governorates?[index];
                        return GestureDetector(
                          onTap: () =>
                              searchCubit.selectGovernorate(governorate),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              (getLang() == "ar"
                                      ? governorate?.nameAr
                                      : governorate?.nameEn) ??
                                  '',
                              style: Styles.headerText(),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Sizer(),
                    );
                  } else if (state.status ==
                      SearchRestaurantStates.loadingSearchGevnorates) {
                    return RefreshIndicator(
                      onRefresh: () async => searchCubit.refreshState(),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: state.searchGovernorates!.length,
                        itemBuilder: (context, index) {
                          GovernorateEntity? governorate =
                              state.searchGovernorates?[index];
                          return GestureDetector(
                            onTap: () =>
                                searchCubit.selectGovernorate(governorate),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                context.isArabic
                                    ? (governorate?.nameAr ?? "")
                                    : (governorate?.nameEn ?? ""),
                                style: Styles.headerText(),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Sizer(),
                      ),
                    );
                  }

                  /// ------- search cities
                  else if (state.status ==
                      SearchRestaurantStates.loadingCities) {
                    return RefreshIndicator(
                      onRefresh: () async => searchCubit.refreshState(),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.cities?.length,
                        itemBuilder: (context, index) {
                          CityEntity? city = state.cities?[index];
                          return GestureDetector(
                            onTap: () => searchCubit.selectCity(city),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                (context.isArabic
                                        ? city?.nameAr
                                        : city?.nameEn) ??
                                    '',
                                style: Styles.headerText(),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state.status ==
                      SearchRestaurantStates.loadingSearchCities) {
                    return RefreshIndicator(
                      onRefresh: () async => searchCubit.refreshState(),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: state.searchCities!.length,
                        itemBuilder: (context, index) {
                          CityEntity? city = state.searchCities?[index];
                          return GestureDetector(
                            onTap: () => searchCubit.selectCity(city),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                context.isArabic
                                    ? (city?.nameAr ?? "")
                                    : (city?.nameEn ?? ""),
                                style: Styles.headerText(),
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Sizer(),
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
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.001,
                        ),
                        itemCount: state.allRestaurant?.length,
                        itemBuilder: (context, index) {
                          GetAllRestaurantEntity? restaurant =
                              state.allRestaurant?[index];
                          return SearchRestaurantCard(restaurant: restaurant);
                        },
                      ),
                    );
                  } else if (state.status ==
                      SearchRestaurantStates.loadingSearchResult) {
                    return RefreshIndicator(
                      onRefresh: () async => searchCubit.refreshState(),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.001,
                        ),
                        itemCount: state.searchRestaurant?.length,
                        itemBuilder: (context, index) {
                          GetAllRestaurantEntity? restaurant =
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
      );
    });
  }
}

/*
class SearchRestaurantView extends StatelessWidget {
  const SearchRestaurantView({super.key});

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchRestaurantsCubit>();
    return BlocBuilder<SearchRestaurantsCubit, SearchRestaurantState>(
        builder: (context, state) {
      return CustomScaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: BackAppBar(
            label: "${LocaleKeys.search.tr()} ${LocaleKeys.restaurants.tr()}",
            leading: IconButton(
              onPressed: () => searchCubit.back(),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              /// top
              TextFormField(
                // onFieldSubmitted: (value) {
                //   if (value.isNotEmpty) {
                //     if (state.status ==
                //         SearchRestaurantStates.loadingSubCategories) {
                //       context
                //           .read<SearchRestaurantsCubit>()
                //           .searchSubCategories(value);
                //     }
                //     if (state.status ==
                //         SearchRestaurantStates.loadingGovernorates) {
                //       context
                //           .read<SearchRestaurantsCubit>()
                //           .searchGovernorates(value);
                //     }
                //     if (state.status == SearchRestaurantStates.loadingCities) {
                //       context
                //           .read<SearchRestaurantsCubit>()
                //           .searchCities(value);
                //     }
                //     if (state.status == SearchRestaurantStates.loadingResult) {
                //       context
                //           .read<SearchRestaurantsCubit>()
                //           .searchResult(value);
                //     }
                //   }
                // },
                // onSaved: (value) {
                //   if (value!.isNotEmpty) {
                //     if (state.status ==
                //         SearchRestaurantStates.loadingSubCategories) {
                //       context
                //           .read<SearchRestaurantsCubit>()
                //           .searchSubCategories(value);
                //     }
                //     if (state.status ==
                //         SearchRestaurantStates.loadingGovernorates) {
                //       context
                //           .read<SearchRestaurantsCubit>()
                //           .searchGovernorates(value);
                //     }
                //     if (state.status == SearchRestaurantStates.loadingCities) {
                //       context
                //           .read<SearchRestaurantsCubit>()
                //           .searchCities(value);
                //     }
                //     if (state.status == SearchRestaurantStates.loadingResult) {
                //       context
                //           .read<SearchRestaurantsCubit>()
                //           .searchResult(value);
                //     }
                //   }
                // },
                onChanged: (value) {
                  if (state.status ==
                          SearchRestaurantStates.loadingSubCategories ||
                      state.status ==
                          SearchRestaurantStates.loadingSearchSubCategory) {
                    context
                        .read<SearchRestaurantsCubit>()
                        .searchSubCategories(value);
                  }
                  if (state.status ==
                          SearchRestaurantStates.loadingGovernorates ||
                      state.status ==
                          SearchRestaurantStates.loadingSearchGevnorates) {
                    context
                        .read<SearchRestaurantsCubit>()
                        .searchGovernorates(value);
                  }
                  if (state.status == SearchRestaurantStates.loadingCities ||
                      state.status ==
                          SearchRestaurantStates.loadingSearchCities) {
                    context.read<SearchRestaurantsCubit>().searchCities(value);
                  }
                  if (state.status == SearchRestaurantStates.loadingResult ||
                      state.status ==
                          SearchRestaurantStates.loadingSearchResult) {
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
                        child: CustomCircularProgressIndicator(),
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
                        child: ListView.separated(
                          itemCount: state.mealCategories?.length ?? 0,
                          padding: EdgeInsets.all(10.w),
                          separatorBuilder: (context, index) => Sizer(
                            height: 0.h,
                          ),
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
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 150.w,
                                      height: 150.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.shade300,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.PRIMARY_COLOR
                                                  .withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 3,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    width: 150.w,
                                  ),
                                  Sizer(
                                    width: 40.w,
                                  ),
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
                          padding: EdgeInsets.all(15.w),
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
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 150.w,
                                      height: 150.h,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.shade300,
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.PRIMARY_COLOR
                                                  .withOpacity(0.5),
                                              spreadRadius: 2,
                                              blurRadius: 3,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          )),
                                    ),
                                    width: 150.w,
                                  ),
                                  const Sizer(),
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
                                child: Text(
                                  (getLang() == "ar"
                                          ? governorate?.nameAr
                                          : governorate?.nameEn) ??
                                      '',
                                  style: Styles.headerText(),
                                ),
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
                                child: Text(
                                  context.isArabic
                                      ? (governorate?.nameAr ?? "")
                                      : (governorate?.nameEn ?? ""),
                                  style: Styles.headerText(),
                                ),
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
                                child: Text(
                                  (context.isArabic
                                          ? city?.nameAr
                                          : city?.nameEn) ??
                                      '',
                                  style: Styles.headerText(),
                                ),
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
                                child: Text(
                                  context.isArabic
                                      ? (city?.nameAr ?? "")
                                      : (city?.nameEn ?? ""),
                                  style: Styles.headerText(),
                                ),
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
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 1.001,
                          ),
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
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 1.001,
                          ),
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

 */
