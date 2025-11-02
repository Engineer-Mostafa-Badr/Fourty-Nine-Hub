// For JSON decoding

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/is_restaurant_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/ads/native_ad_card.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_restaurant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/create_restaurant_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/search_cubit/search_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/expired_request_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/request_logs_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/search_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/banner.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/meal_categories.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/subcategories_restaurant_card.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../core/constants/registration_status.dart';
import '../../../../../core/widget/common/tab_widget.dart';
import '../../../../../core/widget/custom_loading_search_widget.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../core/widget/olx_pagination/banner.dart';
import '../../../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../../../../res/style/app_colors.dart';
import 'favorite_ads.dart';

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

class CustomApproveMealButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDisabled;
  final bool isRed;
  final bool isPending;
  final String status;
  final GestureTapCallback? onTap;

  const CustomApproveMealButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
    this.isRed = false,
    this.isPending = false,
    this.status = 'pending',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Stack(
            children: [
              Container(
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isRed
                        ? [
                            AppColors.cF33D49,
                            AppColors.cC0303A,
                            AppColors.cA72A32,
                            AppColors.c9A272E,
                            AppColors.c93252C,
                            AppColors.c90242B,
                          ]
                        : [
                            AppColors.c0B1035,
                            AppColors.c161F68,
                            AppColors.c1B2781,
                            AppColors.c1E2B8E,
                            AppColors.c1F2D95,
                            AppColors.c0B1035,
                          ],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      offset: const Offset(0, 4),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              if (isDisabled)
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              Positioned.fill(
                child: ElevatedButton(
                  onPressed: isDisabled ? null : onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: isDisabled ? Colors.grey[400] : Colors.white,
                      shadows: isDisabled
                          ? [
                              const Shadow(
                                color: Color(0xFFFFFFFF),
                                offset: Offset(0, 1),
                                blurRadius: 4,
                              ),
                              const Shadow(
                                color: Color(0xFFD9D9D9),
                                offset: Offset(1, 0),
                                blurRadius: 4,
                              ),
                              const Shadow(
                                color: Color(0xFFFFFFFF),
                                offset: Offset(0, 0),
                                blurRadius: 4,
                              ),
                              const Shadow(
                                color: Color(0xFFD9D9D9),
                                offset: Offset(0, 0),
                                blurRadius: 4,
                              ),
                              const Shadow(
                                color: Color(0xFF3C3C43),
                                offset: Offset(0, 0),
                                blurRadius: 4,
                              ),
                              const Shadow(
                                color: Color(0xFF818181),
                                offset: Offset(0, 0),
                                blurRadius: 4,
                              ),
                            ]
                          : [
                              const Shadow(
                                color: Color(0xFFFFFFFF),
                                offset: Offset(0, 1),
                                blurRadius: 4,
                              ),
                              const Shadow(
                                color: Color(0xFFD9D9D9),
                                offset: Offset(1, 0),
                                blurRadius: 4,
                              ),
                              const Shadow(
                                color: Color(0xFFFFFFFF),
                                offset: Offset(0, 0),
                                blurRadius: 4,
                              ),
                              const Shadow(
                                color: Color(0xFFD9D9D9),
                                offset: Offset(0, 0),
                                blurRadius: 4,
                              ),
                              const Shadow(
                                color: Color(0xFF3C3C43),
                                offset: Offset(0, 0),
                                blurRadius: 4,
                              ),
                              const Shadow(
                                color: Color(0xFF818181),
                                offset: Offset(0, 0),
                                blurRadius: 4,
                              ),
                            ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Sizer(),
          Text(
            status == RegistrationStatus.rejected.status
                ? context.isArabic
                    ? 'مرفوض'
                    : "rejected"
                : status == RegistrationStatus.pending.status
                    ? context.isArabic
                        ? 'انتظار الموافقة'
                        : "waiting for approval"
                    : status == RegistrationStatus.initial.status
                        ? context.isArabic
                            ? 'قيد الانتظار'
                            : "Pending"
                        : '',
            style: TextStyle(color: AppColors.getRedColor(context)),
          )
        ],
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

class RestaurantsListsView extends StatefulWidget {
  const RestaurantsListsView({super.key});

  @override
  State<RestaurantsListsView> createState() => _RestaurantsListsViewState();
}

class _RestaurantsListsViewState extends State<RestaurantsListsView>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  NoAuthRestaurantCategory? restaurantCategory;
  late ScrollController _scrollController;
  late TabController _tabController;
  bool isFirstSearchListenerCall = true;

  final AdsManager _adsManager = AdsManager();
  final FocusNode _focusNode = FocusNode();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _adsManager.preloadAds();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<RestaurantsCubit>().loadData();
  }

  void _onScroll() {
    // if (_scrollController.position.pixels >=
    //     _scrollController.position.maxScrollExtent - 200) {
    //   context.read<RestaurantsCubit>().fetchRestaurants();
    // }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  bool _showSearch = false;

  bool _showExpire = false;

  bool _showFavAds = false;

  bool _showLog = false;

  int? _selectedTabIndex; // null means no tab is selected

  String _getRestaurantButtonText(IsRestaurantModel? restaurant) {
    if (restaurant == null || restaurant.isRestaurant == false) {
      return LocaleKeys.serveClientsByClickRegister.tr();
    }

    switch (restaurant.status) {
      case "pending":
        return LocaleKeys.restaurantMode.localize;
      case "approved":
        return LocaleKeys.restaurantMode.localize;
      case "rejected":
        return context.isArabic
            ? "تم رفض طلبك - اضغط لمعرفة السبب"
            : "Request Rejected - Tap for Details";
      case "blocked":
        return context.isArabic
            ? "مطعمك محظور - اضغط لمعرفة السبب"
            : "Restaurant Blocked - Tap for Details";
      case "banned":
        return context.isArabic
            ? "مطعمك محظور مؤقتاً - اضغط للتفاصيل"
            : "Temporarily Banned - Tap for Details";
      default:
        return LocaleKeys.serveClientsByClickRegister.tr();
    }
  }

  void _showRejectedDialog(BuildContext context, IsRestaurantModel restaurant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            context.isArabic ? "طلبك مرفوض" : "Request Rejected",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.isArabic ? "سبب الرفض:" : "Rejection Reason:",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                restaurant.reason ??
                    (context.isArabic
                        ? "لم يتم تحديد السبب"
                        : "No reason provided"),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Text(
                context.isArabic
                    ? "يمكنك تقديم طلب جديد بعد تصحيح المشاكل المذكورة."
                    : "You can submit a new request after fixing the mentioned issues.",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.isArabic ? "حسناً" : "OK"),
            ),
          ],
        );
      },
    );
  }

  void _showBlockedDialog(BuildContext context, IsRestaurantModel restaurant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            context.isArabic ? "مطعمك محظور" : "Restaurant Blocked",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.isArabic ? "سبب الحظر:" : "Block Reason:",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                restaurant.reason ??
                    (context.isArabic
                        ? "لم يتم تحديد السبب"
                        : "No reason provided"),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Text(
                context.isArabic
                    ? "تم حظر مطعمك مؤقتاً. يرجى التواصل مع الإدارة لحل المشكلة."
                    : "Your restaurant has been blocked. Please contact support to resolve this issue.",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.isArabic ? "حسناً" : "OK"),
            ),
          ],
        );
      },
    );
  }

  void _showBannedDialog(BuildContext context, IsRestaurantModel restaurant) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String banInfo = "";
        if (restaurant.banDurationDays != null) {
          banInfo = context.isArabic
              ? "مدة الحظر: ${restaurant.banDurationDays} يوم"
              : "Ban Duration: ${restaurant.banDurationDays} days";
        } else if (restaurant.bannedUntil != null) {
          banInfo = context.isArabic
              ? "محظور حتى: ${restaurant.bannedUntil}"
              : "Banned Until: ${restaurant.bannedUntil}";
        }

        return AlertDialog(
          title: Text(
            context.isArabic
                ? "مطعمك محظور مؤقتاً"
                : "Restaurant Temporarily Banned",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (banInfo.isNotEmpty) ...[
                Text(
                  banInfo,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
              ],
              Text(
                context.isArabic ? "سبب الحظر:" : "Ban Reason:",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                restaurant.reason ??
                    (context.isArabic
                        ? "لم يتم تحديد السبب"
                        : "No reason provided"),
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Text(
                context.isArabic
                    ? "لن تتمكن من استخدام المطعم خلال فترة الحظر. يرجى الالتزام بالقوانين في المستقبل."
                    : "You won't be able to use the restaurant during the ban period. Please follow the rules in the future.",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(context.isArabic ? "حسناً" : "OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = context.watch<RestaurantsCubit>().state;
    return CustomScaffold(
      enableCustomAppBar: true,
      appBar: BackAppBar(
        label: context.isArabic ? 'أكلة' : 'Meal',
      ),
      // mainCategoryId: 1,
      // backgroundColor: scaffoldDarkColor(context),
      body: RefreshIndicator(
        backgroundColor: AppColors.getFindFillColor(context),
        color: AppColors.getTextColor(context),
        onRefresh: () async {
          if (context.read<UserCubit>().isLoggedIn) {
            setState(() {
              context.read<RestaurantsCubit>().loadData();
            });
          }
        },
        child: state.isLoading
            ? const Center(child: CustomLoadingSearchWidget())
            : _buildLoggedInView(state),
      ),
    );
  }

  Widget _buildLoggedInView(RestaurantsListState state) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h, left: 10.w, right: 10.w),
      child: ListView(
        children: [
          const MealBanner(),
          _buildRegisterRestaurantPrompt(state),
          _buildSearchAndExpiredRequests(),
          const Sizer(),
          if (_showSearch)
            BlocProvider(
              create: (context) => SearchRestaurantsCubit(
                serviceLocator(),
                serviceLocator(),
                serviceLocator(),
                serviceLocator(),
              )..loadData(),
              child: SearchRestaurantView(
                onClose: () => setState(() => _showSearch = false),
                focusNode: _focusNode,
              ),
            ),
          if (_showExpire)
            BlocProvider(
              key: ValueKey("expired-${DateTime.now().millisecondsSinceEpoch}"),
              create: (context) => serviceLocator<RestaurantsCubit>()
                ..loadInitialExpiredOrders(),
              child: RestaurantExpiredRequestsScreen(
                key: ValueKey(
                    "expired-screen-${DateTime.now().millisecondsSinceEpoch}"),
                onClose: () => setState(() => _showExpire = false),
              ),
            ),
          if (_showLog)
            BlocProvider(
              key: ValueKey("log-${DateTime.now().millisecondsSinceEpoch}"),
              create: (context) =>
                  serviceLocator<RestaurantsCubit>()..loadInitialReqLogs(),
              child: RestaurantRequestLogsScreen(
                key: ValueKey(
                    "log-screen-${DateTime.now().millisecondsSinceEpoch}"),
                onClose: () => setState(() => _showLog = false),
              ),
            ),
          if (_showFavAds)
            BlocProvider(
              create: (context) =>
                  serviceLocator<RestaurantsCubit>()..loadInitialFoodAds(),
              child: RestaurantFavAdsScreen(
                onClose: () => setState(() {
                  context.read<RestaurantsCubit>().loadInitialData();
                  _showFavAds = false;
                }),
              ),
            ),
          if (!_showSearch && !_showExpire && !_showLog && !_showFavAds)
            Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                children: [
                  const Sizer(),
                  const Sizer(),
                  const MealCategories(),
                  Sizer(
                    height: 35.h,
                  ),
                  Label(
                    text: context.isArabic
                        ? "${state.selectedCategory?.id != '' ? "مطاعم " : ''}${state.selectedCategory?.nameAr}"
                        : "${state.selectedCategory?.nameEn}${state.selectedCategory?.id != '' ? " Restaurants" : ''}",
                    style: Styles.headerText(),
                  ),
                  const Sizer(),
                  (state.isLoadingRestaurantsMore == true &&
                          context
                                  .read<RestaurantsCubit>()
                                  .currentRestaurantsPage ==
                              1)
                      ? ListView.builder(
                          itemCount: 1,
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) =>
                              const PropertyCardShimmer(),
                        )
                      : context.read<RestaurantsCubit>().restaurants.isNotEmpty
                          ? OlxPaginationWidget(
                              scrollController: ScrollController(),
                              itemsPerPage: 3,
                              loadPage: (page) async {},
                              banners: bannersList,
                              items: List.generate(
                                context
                                    .read<RestaurantsCubit>()
                                    .restaurants
                                    .length,
                                (index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: SubCategoriesRestaurantCard(
                                      item: context
                                          .read<RestaurantsCubit>()
                                          .restaurants[index],
                                      mealId: '',
                                      favouriteRestaurant: (String id) async {
                                        var result = await context
                                            .read<RestaurantsCubit>()
                                            .toggleFavoriteRestaurant(id);
                                        if (result == true && mounted) {
                                          context
                                                  .read<RestaurantsCubit>()
                                                  .restaurants[index]
                                                  .isFavorite =
                                              !context
                                                  .read<RestaurantsCubit>()
                                                  .restaurants[index]
                                                  .isFavorite!;
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ).buildAsStaticList()

                          /*ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: context
                                    .read<RestaurantsCubit>()
                                    .restaurants
                                    .length,
                                separatorBuilder: (context, index) => const Sizer(),
                                itemBuilder: (context, i) {
                                  // if (i > nativeAdStart && i % adFrequency == adFrequency - 1) {
                                  //   return getAdIfNeeded(i, _adsManager);
                                  // }
                                  // if (i > context.read<RestaurantsCubit>().restaurants.length && i % adFrequency == adFrequency - 1) {
                                  //   print("the index ${context.read<RestaurantsCubit>().restaurants.length}");
                                  //   return getAdIfNeeded(i, _adsManager);
                                  // }

                                    return Column(
                                      children: [
                                        if (i % adFrequency == adFrequency - 1)
                                          getAdIfNeeded(
                                              i, _adsManager), // Only show ad
                                        SubCategoriesRestaurantCard(
                                          item: context
                                              .read<RestaurantsCubit>()
                                              .restaurants[i],
                                          mealId: '',
                                          favouriteRestaurant: (String id) async {
                                            var result = await context
                                                .read<RestaurantsCubit>()
                                                .toggleFavoriteRestaurant(id);
                                            if (result == true) {
                                              context.read<RestaurantsCubit>().restaurants[i].isFavorite
                                              = !context.read<RestaurantsCubit>().restaurants[i].isFavorite!;

                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                )*/
                          : Center(
                              child: Padding(
                                padding: EdgeInsets.only(top: 70.h),
                                child: CustomEmptyWidget(
                                  label: context.isArabic
                                      ? "لا توجد مطاعم متوفرة."
                                      : "No Restaurants Found.",
                                ),
                              ),
                            )
                ],
              ),
            )
        ],
      ),
    );
  }

  Widget _buildRegisterRestaurantPrompt(RestaurantsListState state) {
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (context.read<UserCubit>().isLoggedIn)
            GestureDetector(
              child: Stack(
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: state.isResturant?.isRestaurant == false
                            ? [
                                Color(0xFF0B1035),
                                Color(0xFF161F68),
                                Color(0xFF1B2781),
                                Color(0xFF1E2B8E),
                                Color(0xFF1F2D95),
                                Color(0xFF0B1035),
                              ]
                            : [
                                Color(0xFFF33D49),
                                Color(0xFFC0303A),
                                Color(0xFFA72A32),
                                Color(0xFF9A272E),
                                Color(0xFF93252C),
                                Color(0xFF90242B),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        final status = state.isResturant?.status;
                        final restaurant = state.isResturant;

                        if (status == "pending") {
                          // Do nothing - button is disabled
                          return;
                        } else if (status == "approved") {
                          // Navigate to restaurant dashboard
                          context
                              .push(
                            Routes.RestaurantDashboard,
                            extra: restaurant!.restaurantId!,
                          )
                              .then((result) {
                            if (mounted && result == true) {
                              context.read<RestaurantsCubit>().loadData();
                            }
                          });
                        } else if (status == "rejected") {
                          // Show rejection dialog
                          _showRejectedDialog(context, restaurant!);
                        } else if (status == "blocked") {
                          // Show blocked dialog
                          _showBlockedDialog(context, restaurant!);
                        } else if (status == "banned") {
                          // Show banned dialog
                          _showBannedDialog(context, restaurant!);
                        } else {
                          // No restaurant or create new restaurant
                          if (context.read<UserCubit>().isLoggedIn) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BlocProvider<CreateRestaurantCubit>(
                                  create: (context) =>
                                      serviceLocator<CreateRestaurantCubit>()
                                        ..loadData(),
                                  child: CreateRestaurantForm(
                                    from: 'create',
                                    restaurantId:
                                        restaurant?.restaurantId ?? '',
                                  ),
                                ),
                              ),
                            );
                          } else {
                            pleaseLoginDialog(context);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            _getRestaurantButtonText(state.isResturant),
                            style: Styles.mediumText(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (state.isResturant?.status == "pending")
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                ],
              ),

              // ElevatedButton(
              //   onPressed: (){},
              //   // padding: const EdgeInsets.symmetric(horizontal: 5.0),
              //   child: Text(
              //     LocaleKeys.serveClientsByClickRegister.tr(),
              //     style: Styles.mediumText(color: Colors.red),
              //   ),
              // ),
            ),
          if (state.isResturant?.status == "pending" &&
              context.read<UserCubit>().isLoggedIn)
            Label(
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: AppColors.PRIMARY_COLOR_DARK,
              ),
              textAlign: TextAlign.end,
              text: LocaleKeys.waitingApproval.localize,
            ),
        ],
      ),
    );
  }

  Widget _buildSearchAndExpiredRequests() {
    return Container(
      color: context.isDarkMode ? Colors.black : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Search Icon
              Container(
                margin: EdgeInsets.only(
                  top: 15.h,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        ManageVibration.vibrate();
                        if (context.read<UserCubit>().isLoggedIn) {
                          setState(() {
                            _showSearch = !_showSearch;
                            if (_showSearch) {
                              _showExpire = false;
                              _showLog = false;
                              _showFavAds = false;
                            }
                          });
                        } else {
                          return pleaseLoginDialog(context);
                        }
                      },
                      child: Icon(
                        _showSearch ? Icons.search_off_rounded : Icons.search,
                        color: _showSearch
                            ? AppColors.getRedColor(context)
                            : AppColors.getTextColor(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Cart Icon
                    GestureDetector(
                      onTap: () {
                        ManageVibration.vibrate();
                        if (context.read<UserCubit>().isLoggedIn) {
                          context.push(Routes.FOODCART);
                        } else {
                          return pleaseLoginDialog(context);
                        }
                      },
                      child: Icon(
                        Icons.shopping_cart,
                        color: context.isDarkMode
                            ? AppColors.whiteColor
                            : AppColors.PRIMARY_COLOR,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // 3 Tabs in one row
              Expanded(
                child: Row(
                  children: List.generate(3, (index) {
                    final labels = [
                      context.isArabic ? 'مفضلة' : 'Favourites',
                      context.isArabic ? 'سجل طلبات' : 'Request Log',
                      context.isArabic ? 'منتهية' : 'Expired',
                    ];

                    return Expanded(
                      child: AnimatedBuilder(
                        animation: _tabController,
                        builder: (context, _) {
                          // Determine if this tab is selected based on show flags
                          final isSelected = (index == 0 && _showFavAds) ||
                              (index == 1 && _showLog) ||
                              (index == 2 && _showExpire);

                          // For Request Log tab, show badge
                          Widget tabWidget = TabWidget(
                            textSize: 18,
                            title: labels[index],
                            count: index == 1
                                ? context
                                    .watch<RestaurantsCubit>()
                                    .state
                                    .reqCount
                                    ?.count
                                : null,
                            selected: isSelected,
                            onTap: () {
                              ManageVibration.vibrate();
                              if (context.read<UserCubit>().isLoggedIn) {
                                setState(() {
                                  _showSearch = false;

                                  // Toggle logic: if already selected, unselect it
                                  if (isSelected) {
                                    // Unselect: show main content
                                    _showFavAds = false;
                                    _showLog = false;
                                    _showExpire = false;
                                  } else {
                                    // Select new tab
                                    _showFavAds = index == 0;
                                    _showLog = index == 1;
                                    _showExpire = index == 2;
                                  }

                                  // Load main restaurants data when no tab is selected
                                  if (!_showFavAds &&
                                      !_showLog &&
                                      !_showExpire) {
                                    context
                                        .read<RestaurantsCubit>()
                                        .loadInitialRestaurantsData('');
                                  }
                                });
                              } else {
                                pleaseLoginDialog(context);
                              }
                            },
                          );

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: tabWidget,
                          );
                        },
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
