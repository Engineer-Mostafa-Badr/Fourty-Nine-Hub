// For JSON decoding

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/ads/native_ad_card.dart';
import 'package:fourtyninehub/common/widgets/dialogs/please_login_dialog.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/account_taps/wallet/presentation/widgets/custom_empty_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/create_resturant_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/search_cubit/search_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/expired_request_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/request_logs_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/searsh_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/banner.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/meal_categories.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/subcatigories_restaurant_card.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/registration_status.dart';
import '../../../../../core/widget/custom_loading_search_widget.dart';
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
    with AutomaticKeepAliveClientMixin {
  NoAuthRestaurantCategory? restaurantCategory;
  late ScrollController _scrollController;
  bool isFirstSearchListenerCall = true;

  final AdsManager _adsManager = AdsManager();
  final FocusNode _focusNode = FocusNode();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _adsManager.preloadAds();
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
    super.dispose();
  }

  bool _showSearch = false;

  bool _showExpire = false;

  bool _showFavAds = false;

  bool _showLog = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = context.watch<RestaurantsCubit>().state;
    return SharedScaffold(
      mainCategoryId: 1,
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
      padding: EdgeInsets.all(10.w),
      child: GlowingOverscrollIndicator(
        color: AppColors.SECONDARY_COLOR,
        axisDirection: AxisDirection.down,
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
                    const Sizer(),
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
                            ? SizedBox(
                                height: MediaQuery.sizeOf(context).height * .7,
                                child: OlxPaginationWidget(
                                  scrollController: _scrollController,
                                  itemsPerPage: 2,
                                  loadPage: (page) async {},
                                  banners: bannersList,
                                  items: List.generate(
                                    context
                                        .read<RestaurantsCubit>()
                                        .restaurants
                                        .length,
                                    (index) {
                                      // final request = controller.reqLogs[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: SubCategoriesRestaurantCard(
                                          item: context
                                              .read<RestaurantsCubit>()
                                              .restaurants[index],
                                          mealId: '',
                                          favouriteRestaurant: (String id) async {
                                            var result = await context
                                                .read<RestaurantsCubit>()
                                                .toggleFavoriteRestaurant(id);
                                            if (result == true) {
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
                                ),
                              )
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
                                  padding: EdgeInsets.only(top: 40.h),
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
                      onPressed: (state.isResturant?.approved == false)
                          ? null // Disabled
                          : (state.isResturant?.approved == true)
                              ? () async {
                                  var result = await context.push(
                                    Routes.RestaurantDashboard,
                                    extra: state.isResturant!.restaurantId!,
                                  );
                                  if (result == true) {
                                    context.read<RestaurantsCubit>().loadData();
                                  }
                                }
                              : () {
                                  if (context.read<UserCubit>().isLoggedIn) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider<CreateRestaurantCubit>(
                                          create: (context) => serviceLocator<
                                              CreateRestaurantCubit>()
                                            ..loadData(),
                                          child: CreateRestaurantForm(
                                            from: 'create',
                                            restaurantId: state.isResturant
                                                    ?.restaurantId ??
                                                '',
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return pleaseLoginDialog(context);
                                    // context.push(Routes.REGISTER);
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
                          // padding: const EdgeInsets.symmetric(
                          //     horizontal: 16.0, vertical: 12.0),
                          child: Text(
                            state.isResturant?.isRestaurant == false
                                ? LocaleKeys.serveClientsByClickRegister.tr()
                                : LocaleKeys.restaurantMode.localize,
                            style: Styles.mediumText(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (state.isResturant?.approved == false &&
                      state.isResturant?.approved != null)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          // Optional opacity for transparency
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
          if (state.isResturant?.approved != null)
            state.isResturant?.approved == true
                ? const SizedBox()
                : context.read<UserCubit>().isLoggedIn
                    ? Label(
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.PRIMARY_COLOR_DARK,
                        ),
                        textAlign: TextAlign.end,
                        text: LocaleKeys.waitingApproval.localize,
                      )
                    : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildSearchAndExpiredRequests() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          spacing: 5,
          children: [
            Row(
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

                      // context.push(Routes.LOGIN);
                    }
                  },
                  child: Icon(
                      _showSearch ? Icons.search_off_rounded : Icons.search,
                      color: _showSearch
                          ? AppColors.getRedColor(context)
                          : AppColors.getTextColor(context)),
                ),
                const Sizer(),
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
                    )),
              ],
            ),
            GestureDetector(
              onTap: () {
                ManageVibration.vibrate();
                if (context.read<UserCubit>().isLoggedIn) {
                  setState(() {
                    _showFavAds = !_showFavAds;
                    if (_showFavAds) {
                      _showSearch = false;
                      _showLog = false;
                      _showExpire = false;
                    } else if (!_showFavAds) {
                      context
                          .read<RestaurantsCubit>()
                          .loadInitialRestaurantsData('');
                    }
                  });
                } else {
                  return pleaseLoginDialog(context);

                  // context.push(Routes.LOGIN);
                }
              },
              child: Container(
                padding: EdgeInsets.all(6),
                width: 210.w,
                decoration: BoxDecoration(
                    // border: Border.all(
                    //     color: _showFavAds
                    //         ? AppColors.getRedColor(context)
                    //         : AppColors.getButtonPrimaryColor(context)),
                    borderRadius: BorderRadius.circular(15),
                    color: _showFavAds
                        ? AppColors.getButtonPrimaryColor(context)
                        : AppColors.getFillColor(context)),
                child: Label(
                  text: context.isArabic ? 'مفضلة' : 'Favourites',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _showFavAds
                          ? AppColors.getReversedTextColor(context)
                          : AppColors.getTextColor(context)),
                ),
              ),
            ),
            BlocBuilder<RestaurantsCubit, RestaurantsListState>(
              builder: (context, state) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: () {
                        ManageVibration.vibrate();
                        print(context
                            .read<RestaurantsCubit>()
                            .state
                            .logsEntity
                            ?.length);
                        if (context.read<UserCubit>().isLoggedIn) {
                          setState(() {
                            _showLog = !_showLog;
                            if (_showLog) {
                              _showSearch = false;
                              _showExpire = false;
                              _showFavAds = false;
                            }
                          });
                        } else {
                          return pleaseLoginDialog(context);

                          // context.push(Routes.LOGIN);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        width: 210.w,
                        decoration: BoxDecoration(
                          // border: Border.all(
                          //   color: _showLog
                          //       ? AppColors.getRedColor(context)
                          //       : AppColors.getButtonPrimaryColor(context),
                          // ),
                          borderRadius: BorderRadius.circular(15),
                          color: _showLog
                              ? AppColors.getButtonPrimaryColor(context)
                              : AppColors.getFillColor(context),
                        ),
                        child: Label(
                          text: context.isArabic ? 'سجل طلبات' : 'Request Log',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _showLog
                                ? AppColors.getReversedTextColor(context)
                                : AppColors.getTextColor(context),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: context
                              .read<RestaurantsCubit>()
                              .state
                              .reqCount
                              ?.count !=
                          0,
                      child: Positioned(
                        top: -8,
                        right: -6,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: AppColors.getRedColor(context),
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 20,
                            minHeight: 20,
                          ),
                          child: Center(
                            child: Text(
                              '${context.read<RestaurantsCubit>().state.reqCount?.count ?? 0}'
                                  .toArabicNumbers(context),
                              style: TextStyle(
                                color: AppColors.getReversedTextColor(context),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0.h),
              child: GestureDetector(
                onTap: () {
                  ManageVibration.vibrate();
                  if (context.read<UserCubit>().isLoggedIn) {
                    setState(() {
                      _showExpire = !_showExpire;
                      if (_showExpire) {
                        _showSearch = false;
                        _showLog = false;
                        _showFavAds = false;
                      }
                    });
                  } else {
                    return pleaseLoginDialog(context);

                    // context.push(Routes.LOGIN);
                  }
                },
                child: Container(
                  width: 210.w,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      // border: Border.all(
                      //     color: _showExpire
                      //         ? AppColors.getRedColor(context)
                      //         :AppColors.getButtonPrimaryColor(context)),
                      borderRadius: BorderRadius.circular(15),
                      color: _showExpire
                          ? AppColors.getButtonPrimaryColor(context)
                          : AppColors.getFillColor(context)),
                  child: Label(
                    text: context.isArabic ? 'منتهية' : 'Expired',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _showExpire
                            ? AppColors.getReversedTextColor(context)
                            : AppColors.getTextColor(context)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
