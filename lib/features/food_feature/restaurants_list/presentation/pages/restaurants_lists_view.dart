// For JSON decoding

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/ads/native_ad_card.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_scaffold.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/cubit/create_resturant_cubit.dart';
import 'package:fourtyninehub/features/food_feature/create_restaurant/views/create_resturant_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/search_cubit/search_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/cubit/restaurants_list_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/expired_request_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/request_logs_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/searsh_view.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/banner.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/meal_categories.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/pages/widgets/restaurant_list/resturant_dashboard_banner.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/presentation/widgets/subcatigories_restaurant_card.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/registration_status.dart';
import '../../../../../res/style/app_colors.dart';

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

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _adsManager.preloadAds();
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    context.read<RestaurantsCubit>().loadData();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<RestaurantsCubit>().fetchRestaurants();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  bool _showSearch = false;
  bool _showExpire = false;
  bool _showLog = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = context.watch<RestaurantsCubit>().state;
    return SharedScaffold(
      mainCategoryId: 1,
      // backgroundColor: scaffoldDarkColor(context),
      body: RefreshIndicator(
        onRefresh: () async {
          if (context.read<UserCubit>().isLoggedIn) {
            setState(() {
              context.read<RestaurantsCubit>().loadData();
            });
          }
        },
        child: state.isLoading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : _buildLoggedInView(state),
      ),
    );
  }

  Widget _buildLoggedInView(RestaurantsListState state) {
    return ListView(
      padding: EdgeInsets.all(10.w),
      controller: _scrollController,
      shrinkWrap: true,
      children: [
        const MealBanner(),
        // if (!(state.isResturant?.isRestaurant ?? false))
        _buildRegisterRestaurantPrompt(state),
        const Sizer(),
        // if ((state.isResturant?.isRestaurant ?? false) &&
        //     (state.isResturant?.approved ?? false))
        //   const ResturantDashboardButton(),
        _buildSearchAndExpiredRequests(),
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
            ),
          ),
        if (_showExpire)
          BlocProvider(
            key: ValueKey("expired-${DateTime.now().millisecondsSinceEpoch}"),
            create: (context) =>
                serviceLocator<RestaurantsCubit>()..loadInitialExpiredOrders(),
            child: RestaurantExpiredRequestsScreen(
              key: ValueKey(
                  "expired-screen-${DateTime.now().millisecondsSinceEpoch}"),
              onClose: () => setState(() => _showExpire = false),
            ),
          ),

        if (_showLog)
          BlocProvider(
            create: (context) =>
                serviceLocator<RestaurantsCubit>()..loadInitialReqLogs(),
            child: RestaurantRequestLogsScreen(
              onClose: () => setState(() => _showLog = false),
            ),
          ),
        if (!_showSearch && !_showExpire && !_showLog)
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
                        ? ListView.separated(
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
                                        context
                                                .read<RestaurantsCubit>()
                                                .restaurants[i]
                                                .isFavorite =
                                            !context
                                                .read<RestaurantsCubit>()
                                                .restaurants[i]
                                                .isFavorite!;
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          )
                        : Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 40.h),
                              child: Text(
                                context.isArabic
                                    ? "لا توجد مطاعم متوفرة."
                                    : "No Restaurants Found.",
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
    // return CustomApproveMealButton(text:  LocaleKeys.serveClientsByClickRegister.tr() ,onPressed: (){},);
    //        if (!(state.isResturant?.isRestaurant ?? false))
    return Padding(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            child: Stack(
              children: [
                Container(
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
                                          restaurantId:
                                              state.isResturant?.restaurantId ??
                                                  '',
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  context.push(Routes.REGISTER);
                                }
                              },
                    // onPressed: state.isResturant?.approved == false  ? ()async{
                    //   var result = await context.push(Routes.RestaurantDashboard,
                    //       extra: state.isResturant!.restaurantId!);
                    //   if (result == true) {
                    //     context.read<RestaurantsCubit>().loadData();
                    //   }
                    // } : () {
                    //   if (context.read<UserCubit>().isLoggedIn) {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (context) => BlocProvider<CreateRestaurantCubit>(
                    //           create: (context) =>
                    //           serviceLocator<CreateRestaurantCubit>()..loadData(),
                    //           child: CreateRestaurantForm(
                    //             from: 'create',
                    //             restaurantId: state.isResturant?.restaurantId ?? '',
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   } else {
                    //     context.push(Routes.REGISTER);
                    //   }
                    // },
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
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
                ? const SizedBox() // show SizedBox if approved is true
                : Label(
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.PRIMARY_COLOR_DARK,
                    ),
                    textAlign: TextAlign.end,
                    text: LocaleKeys.waitingApproval.localize,
                  ),

          // if(state.isResturant?.approved != null)
          //   Label(
          //     style: TextStyle(
          //       fontWeight: FontWeight.w600,
          //       fontSize: 14,
          //       color: AppColors.PRIMARY_COLOR_DARK
          //     ),
          //     textAlign: TextAlign.end,
          //       text: state.isResturant?.approved == false ? LocaleKeys.waitingApproval.localize :null),
        ],
      ),
    );
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
            LocaleKeys.serveClientsByClickRegister.tr(),
            style: Styles.mediumText(color: Colors.red),
          ),
        ),
      ),
    );
  }


  Widget _buildSearchAndExpiredRequests() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  if (context.read<UserCubit>().isLoggedIn) {
                    setState(() {
                      _showSearch = !_showSearch;
                      if (_showSearch) {
                        _showExpire = false;
                        _showLog = false;
                      }
                    });
                  } else {
                    context.push(Routes.LOGIN);
                  }
                },
                child: Icon(
                  _showSearch ? Icons.search_off_rounded : Icons.search,
                  color: _showSearch
                      ? AppColors.PRIMARY_COLOR_DARK
                      : AppColors.PRIMARY_COLOR,
                ),
              ),
              const Sizer(),
              InkWell(
                  onTap: () {
                    context.push(Routes.FOODCART);
                  },
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  )),
            ],
          ),
          SizedBox(
            width: 5,
          ),
          BlocBuilder<RestaurantsCubit, RestaurantsListState>(
            builder: (context, state) {
              return Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    InkWell(
                      onTap: () {
                        if (context.read<UserCubit>().isLoggedIn) {
                          setState(() {
                            _showLog = !_showLog;
                            if (_showLog) {
                              _showSearch = false;
                              _showExpire = false;
                            }
                          });
                        } else {
                          context.push(Routes.LOGIN);
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _showLog
                                ? AppColors.PRIMARY_COLOR_DARK
                                : AppColors.PRIMARY_COLOR,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          color: _showLog
                              ? AppColors.PRIMARY_COLOR
                              : AppColors.cD9D9D9,
                        ),
                        child: Label(
                          text: LocaleKeys.requestLog.localize,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _showLog
                                ? AppColors.whiteColor
                                : AppColors.black,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -10,
                      right: -6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 20,
                          minHeight: 20,
                        ),
                        child: Center(
                          child: Text(
                            '${context.read<RestaurantsCubit>().state.reqCount?.count ?? "0"}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(
            width: 5,
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                if (context.read<UserCubit>().isLoggedIn) {
                  setState(() {
                    _showExpire = !_showExpire;
                    if (_showExpire) {
                      _showSearch = false;
                      _showLog = false;
                    }
                  });
                } else {
                  context.push(Routes.LOGIN);
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: _showExpire
                            ? AppColors.PRIMARY_COLOR_DARK
                            : AppColors.PRIMARY_COLOR),
                    borderRadius: BorderRadius.circular(15),
                    color: _showExpire
                        ? AppColors.PRIMARY_COLOR
                        : AppColors.cD9D9D9),
                child: Label(
                  text: LocaleKeys.expiredRequests.localize,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color:
                          _showExpire ? AppColors.whiteColor : AppColors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
                ? "rejected"
                : status == RegistrationStatus.pending.status
                    ? "waiting for approval"
                    : status == RegistrationStatus.initial.status
                        ? "Pending"
                        : '',
            style: const TextStyle(color: Colors.red),
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
