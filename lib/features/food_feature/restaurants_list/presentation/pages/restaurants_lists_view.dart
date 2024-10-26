// For JSON decoding
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/functions/helper/numbers_helper.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/create_resturant_view.dart';
import 'package:fourtyninehub/features/food_feature/food_cart/presentation/pages/cart_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/search_cubit/search_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/expired_request_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/searsh_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/banner.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/meal_categories.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/resturant_dashboard_banner.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/subcatigories_restaurant_card.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
// For HTTP requests
import 'package:shimmer/shimmer.dart';

class RestaurantsListsView extends StatefulWidget {
  const RestaurantsListsView({super.key});

  @override
  State<RestaurantsListsView> createState() => _RestaurantsListsViewState();
}

class _RestaurantsListsViewState extends State<RestaurantsListsView>
    with AutomaticKeepAliveClientMixin {
  NoAuthRestaurantCategory? restaurantCategory;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    context.read<RestaurantsCubit>().loadData();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = context.watch<RestaurantsCubit>().state;
    return SharedScaffold(
      mainCategoryId: 1,
      backgroundColor: scaffoldDarkColor(context),
      body: RefreshIndicator(
        onRefresh: () async {
          if (context.read<UserCubit>().isLoggedIn) {
            setState(() {
              context.read<RestaurantsCubit>().loadData();
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Builder(
            builder: (context) {
              // if (context.watch<UserCubit>().isLoggedIn==false) {
              //   return _buildNotLoggedInView(context);
              // }
              if (state.isLoading) {
                print("objectHiiii");
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
              return _buildLoggedInView(state);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNotLoggedInView(BuildContext context) {
    // if (restaurantCategory == null) {
    //   return const Center(child: CircularProgressIndicator.adaptive());
    // }
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                restaurantCategory!.data.banner,
                width: double.infinity,
                height: 100.h,
                fit: BoxFit.fitWidth,
                errorBuilder: (context, error, stackTrace) =>
                    _buildShimmerPlaceholder(),
              ),
              PositionedDirectional(
                start: 8,
                child: Label(
                  text:
                      '${restaurantCategory!.data.numberOfAds.toShortScale} ${LocaleKeys.ads.tr()}',
                  style: Styles.mediumText(
                    shadows: const [
                      Shadow(
                        offset: Offset(1.0, 1.0),
                        blurRadius: 4.0,
                        color: Colors.black,
                      ),
                    ],
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Center(
                child: Label(
                  text: LocaleKeys.meal.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 45.sp,
                  ),
                ),
              ),
              PositionedDirectional(
                end: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () => context.push(Routes.REGISTER),
                    child: Text(
                      LocaleKeys.register.tr(),
                      style: Styles.mediumText(
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            offset: Offset(1.0, 1.0),
                            blurRadius: 4.0,
                            color: Colors.black,
                          ),
                        ],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => context.push(Routes.REGISTER),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                LocaleKeys
                    .youCanEnjoyServingYourClintsUsingYourRestaurantByClickingOnTheRigesterButtonAbove
                    .tr(),
                style: Styles.mediumText(color: Colors.red),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: _buildShimmerPlaceholder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedInView(RestaurantsListState state) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const MealBanner(),
              if (!(state.isResturant?.isRestaurant ?? false))
                _buildRegisterRestaurantPrompt(state),
              const Sizer(),
              if ((state.isResturant?.isRestaurant ?? false) &&
                  (state.isResturant?.approved ?? false))
                const ResturantDashboardButton(),
              const Sizer(),
              _buildSearchAndExpiredRequests(),
              const Sizer(),
              if ((state.mealCategories?.isNotEmpty ?? false)) const MealCategories(),
              if (state.loadingSubCategories)
                _buildLoadingSubCategoriesPlaceholder(),
              const Sizer(),
              if ((state.allRestaurant?.isNotEmpty ?? false)) ...[
                Label(
                  text: LocaleKeys.allRestaurants.tr(),
                  style: Styles.headerText(),
                ),
                const Sizer(),
              ],
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: _buildAllRestaurants(state),
        ),
      ],
    );
  }

  Widget _buildRegisterRestaurantPrompt(RestaurantsListState state) {
    return GestureDetector(
      onTap: () {
        if (context.read<UserCubit>().isLoggedIn) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider<CreateRestaurantCubit>(
                create: (context) =>
                    serviceLocator<CreateRestaurantCubit>()..loadData(),
                child: CreateRestaurantForm(
                  from: 'create',
                  restaurantId: state.isResturant?.restaurantId ?? '',
                ),
              ),
            ),
          );
        } else {
          context.push(Routes.REGISTER);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Text(
          LocaleKeys
              .youCanEnjoyServingYourClintsUsingYourRestaurantByClickingOnTheRigesterButtonAbove
              .tr(),
          style: Styles.mediumText(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildSearchAndExpiredRequests() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => context.read<UserCubit>().isLoggedIn
                ?Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => SearchRestaurantsCubit(
                    serviceLocator(),
                    serviceLocator(),
                    serviceLocator(),
                    serviceLocator(),
                  )..loadData(),
                  child: const SearchRestaurantView(),
                ),
              ),
            ):context.push(Routes.LOGIN),
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(LocaleKeys.search.tr()),
                  const Icon(Icons.search, color: Colors.grey),
                ],
              ),
            ),
          ),
        ),
        const Sizer(),
        Expanded(
          child: InkWell(
            onTap: () {
              context.read<UserCubit>().isLoggedIn
                  ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: serviceLocator<RestaurantsCubit>()
                      ..getExpiredOrders(),
                    child: const RestaurantExpiredRequestsScreen(),
                  ),
                ),
              ):context.push(Routes.LOGIN);
            },
            child: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(width: 1, color: Colors.grey),
              ),
              child: Center(
                child: Text(LocaleKeys.expiredRequests.tr()),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingSubCategoriesPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100]!,
      highlightColor: Colors.white,
      child: Row(
        children: List.generate(
          2,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: MediaQuery.of(context).size.width * 0.2,
            width: MediaQuery.of(context).size.width * 0.2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAllRestaurants(RestaurantsListState state) {
    final restaurants = state.allRestaurant ?? [];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.001,
      ),
      itemCount: restaurants.length,
      itemBuilder: (context, index) {
        final restaurant = restaurants[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SubCategoriesRestaurantCard(
            item: restaurant,
            mealId: '',
          ),
        );
      },
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100]!,
      highlightColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              height: MediaQuery.of(context).size.width * 0.2,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NoAuthRestaurantCategory {
  final bool status;
  final CategoryData data;

  NoAuthRestaurantCategory({
    required this.status,
    required this.data,
  });

  factory NoAuthRestaurantCategory.fromJson(Map<String, dynamic> json) {
    return NoAuthRestaurantCategory(
      status: json['status'] as bool? ?? false,
      data: CategoryData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class CategoryData {
  final String id;
  final String banner;
  final String cover;
  final int index;
  final String createdAt;
  final String updatedAt;
  final String nameAr;
  final String nameEn;
  final String nameCode;
  final bool isHidden;
  final bool enableInstallmentAndAuction;
  final int numberOfAds;

  CategoryData({
    required this.id,
    required this.banner,
    required this.cover,
    required this.index,
    required this.createdAt,
    required this.updatedAt,
    required this.nameAr,
    required this.nameEn,
    required this.nameCode,
    required this.isHidden,
    required this.enableInstallmentAndAuction,
    required this.numberOfAds,
  });

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      id: json['_id'] as String? ?? '',
      banner: json['banner'] as String? ?? '',
      cover: json['cover'] as String? ?? '',
      index: json['index'] as int? ?? 0,
      createdAt: json['createdAt'] as String? ?? '',
      updatedAt: json['updatedAt'] as String? ?? '',
      nameAr: json['nameAr'] as String? ?? '',
      nameEn: json['nameEn'] as String? ?? '',
      nameCode: json['nameCode'] as String? ?? '',
      isHidden: json['isHidden'] as bool? ?? false,
      enableInstallmentAndAuction:
          json['EnableInstallmentAndAuction'] as bool? ?? false,
      numberOfAds: json['numberOfAds'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'banner': banner,
      'cover': cover,
      'index': index,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'nameCode': nameCode,
      'isHidden': isHidden,
      'EnableInstallmentAndAuction': enableInstallmentAndAuction,
      'numberOfAds': numberOfAds,
    };
  }
}
