// For JSON decoding
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
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
import 'package:shimmer/shimmer.dart';

class RestaurantsListsView extends StatefulWidget {
  const RestaurantsListsView({super.key});

  @override
  State<RestaurantsListsView> createState() => _RestaurantsListsViewState();
}

class _RestaurantsListsViewState extends State<RestaurantsListsView>
    with AutomaticKeepAliveClientMixin {
  NoAuthRestaurantCategory? restaurantCategory;
  late ScrollController _scrollController;
  bool isFirstSearchListenerCall = true;


  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<RestaurantsCubit>().loadData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<RestaurantsCubit>().fetchRestaurants();
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
        child: state.isLoading ? const Center(child: CircularProgressIndicator.adaptive()) :_buildLoggedInView(state),
      ),
    );
  }


  Widget _buildLoggedInView(RestaurantsListState state) {
    return ListView(
      controller: _scrollController,
      shrinkWrap: true,
      children: [
          const MealBanner(),
          if (!(state.isResturant?.isRestaurant ?? false))
            _buildRegisterRestaurantPrompt(state),
          const Sizer(),
         Padding(
           padding: EdgeInsets.all(10.w),
           child: Column(
             children: [
               if ((state.isResturant?.isRestaurant ?? false) &&
                   (state.isResturant?.approved ?? false))
                 const ResturantDashboardButton(),
               const Sizer(),
               _buildSearchAndExpiredRequests(),
               const Sizer(),
               const MealCategories(),
               const Sizer(),
               Label(
                 text: context.isArabic?"${state.selectedCategory?.id!=''?"مطاعم ":''}${state.selectedCategory?.nameAr}":"${state.selectedCategory?.nameEn}${state.selectedCategory?.id!=''?" Restaurants":''}",
                 style: Styles.headerText(),
               ),
               const Sizer(),
               (state.isLoadingRestaurantsMore==true&&context.read<RestaurantsCubit>().currentRestaurantsPage==1)?ListView.builder(
                 itemCount: 1,
                 padding: EdgeInsets.zero,
                 shrinkWrap: true,
                 physics: const NeverScrollableScrollPhysics(),
                 itemBuilder: (context,i)=>const PropertyCardShimmer(),
               ):context.read<RestaurantsCubit>().restaurants.isNotEmpty?ListView.separated(
                 shrinkWrap: true,
                 physics: const NeverScrollableScrollPhysics(),
                 itemCount: context.read<RestaurantsCubit>().restaurants.length,
                 separatorBuilder: (context, index) => const Sizer(),
                 itemBuilder: (context,i)=>SubCategoriesRestaurantCard(
                   item: context.read<RestaurantsCubit>().restaurants[i],
                   mealId: '', favouriteRestaurant: (String id) async {
                   var result = await context.read<RestaurantsCubit>().toggleFavoriteRestaurant(id);
                   if(result==true){
                     context.read<RestaurantsCubit>().restaurants[i].isFavorite= !context.read<RestaurantsCubit>().restaurants[i].isFavorite!;
                   }
                 },
                 ),
               ):Center(
                 child: Padding(
                   padding: EdgeInsets.only(top: 40.h),
                   child: Text(
                     context.isArabic ? "لا توجد مطاعم متوفرة." : "No Restaurants Found.",
                     style: Styles.mediumText(),
                   ),
                 ),
               )
             ],
           ),
         )
      ],
    );
  }

  Widget _buildRegisterRestaurantPrompt(RestaurantsListState state) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: GestureDetector(
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
                .serveClientsByClickRegister
                .tr(),
            style: Styles.mediumText(color: Colors.red),
          ),
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
