import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/ads/app_open_model.dart';
import 'package:fourtyninehub/ads/interstitial_ad_model.dart';
import 'package:fourtyninehub/common/widgets/dynamic/drawer.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/dynamic/wallet_widget.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_taps_cubit/main_categories_taps_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/pages/main_categories_cards_view.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/pages/main_categories_taps_view.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/widgets/animated_text.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/firebase_notfications_cubit/firebase_notfications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_socket_io/notification_socket_io_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/notification_snackbar.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../../core/utils/custom_show_dialog.dart';
import '../../../../fourty_nine/presentation/widgets/grid_blocks_widget.dart';
import '../../../../subcategories/presentation/cubit/subcategories_cubit.dart';
import '../../../../subcategories/presentation/pages/custom_page_sub_categories_view.dart';

class ServicePagePreview extends StatefulWidget {
  const ServicePagePreview({super.key, this.noNavBar = false});

  final bool noNavBar;

  @override
  State<ServicePagePreview> createState() => _ServicePagePreviewState();
}

class _ServicePagePreviewState extends State<ServicePagePreview>
    with WidgetsBindingObserver {
  ScrollController scrollController = ScrollController();
  bool _isScrollingDown = false;

  checkLogin() {
    try {
      if (!context.isUserLoggedIn) context.read<UserCubit>().getUser();
    } catch (e) {
      print(e.toString());
    }
  }

  AppOpenAdManager appOpenAdManager = AppOpenAdManager();
  bool isPaused = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      print("xd==========================");
      isPaused = true;
    }
    if (state == AppLifecycleState.resumed && isPaused) {
      print("Resumed==========================");
      appOpenAdManager.showAdIfAvailable();
      isPaused = false;
    }
  }

  @override
  void initState() {
    HandleCashback.setCount('threeDotsCount', context);
    AdInterstitialTop.loadIntersitialAd();
    AdInterstitialTop.showInterstitialAd();
    HandleCashback.setCount('mainCategoriesSliderCount', context);
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);
    checkLogin();
    super.initState();
    _setupScrollController();
    context
        .read<FirebaseNotficationsCubit>()
        .setupInterceptedMessage(context: context);
  }

  void _setupScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!_isScrollingDown) {
          setState(() {
            _isScrollingDown = true;
          });
        }
      } else if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_isScrollingDown) {
          setState(() {
            _isScrollingDown = false;
          });
        }
      }
    });
    context
        .read<FirebaseNotficationsCubit>()
        .setupInterceptedMessage(context: context);
    // super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _setupScrollController();
  }

  List<Widget> getMainCategoryWidgets(
          MainCategoriesCubit controller, MainCategoriesState state) =>
      [
        MainCategoriesListView(controller: controller, state: state),
        // SliverToBoxAdapter(child: Label(text: state.customPage![0].name!)),
        // ...List.generate(state.customPage?.length??0, (index)=>Label(text: state.customPage![index].name!)),
        SliverToBoxAdapter(
            child: MainCategoriesGrideViewSection(
                controller: controller, state: state)),
        SliverToBoxAdapter(
          child: BlocProvider(
            create: (context) => serviceLocator<MainCategoriesTapsCubit>(),
            child: Builder(builder: (context) {
              print(
                  '==> mainCategories ${context.read<MainCategoriesTapsCubit>().mainCategories}');
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  height: 400,
                  child: MainCategoriesFlipCardsView(
                    isAppBarShow: false,
                    mainCategoriesCardsParams: MainCategoriesCardsParams(
                      data: context
                          .read<MainCategoriesTapsCubit>()
                          .mainCategories,
                      isCustomPage: true,
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        SliverToBoxAdapter(
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => serviceLocator<MainCategoriesTapsCubit>(),
              ),
              BlocProvider(
                create: (context) => serviceLocator<SubcategoriesCubit>(),
              ),
            ],
            child: Builder(builder: (context) {
              return SizedBox(
                height: MediaQuery.sizeOf(context).height * .7,
                child:
                    const MainCategoriesGridViewCustomPage(isAppBarShow: false),
              );
            }),
          ),
        ),
      ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print("objectUser${UserCubit.to.state.data?.id}");
    return
        // BlocListener<NotificationSocketIoCubit, NotificationSocketIoState>(
        //   listener: (context, state) {
        //     if (state is NotificationSocketIoNewNotification) {
        //       // pr('new notfication is recieved by the bloc listner');
        //       // pr(state.notificationEntity);
        //       notificationSnackBar(
        //           context: context,
        //           notificationEntity: state.notificationEntity,
        //           isAppNotification: state.notificationEntity.filterType == 'app');
        //     } else if (state is NotificationSocketIoFailed) {
        //       // pr('Failed to recieve the new notfication ');
        //       // pr(state.message);
        //     }
        //   },
        //   child:
        Scaffold(
      key: _scaffoldKey,
      bottomNavigationBar: widget.noNavBar
          ? null
          : BottomNavigator(
              scrollController: scrollController,
              isScrollingDown: _isScrollingDown,
              mainCategory: 1,
              index: 2,
            ),
      floatingActionButton: _isScrollingDown || widget.noNavBar
          ? null
          : const FloatingButton(
              changeView: 1,
              icon: Icons.person,
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawer: const DrawerWidget(),
      body: Stack(
        children: [
          CustomScrollView(
            controller: scrollController,
            // padding: EdgeInsets.symmetric(horizontal: 20.w),
            slivers: [
              // const SliverToBoxAdapter(child: AddBanner()),
              //wallet
              SliverToBoxAdapter(
                child: context.read<UserCubit>().isLoggedIn
                    ? const WalletWidget()
                    : const SizedBox.shrink(),
              ),
              // SliverToBoxAdapter(child: _buildStarWidget()),
              const SliverToBoxAdapter(child: Sizer()),
              SliverToBoxAdapter(
                child: ScrollableTextWithAnimation(
                  textDirection:
                      context.isArabic ? TextDirection.rtl : TextDirection.ltr,
                ),
              ),
              const SliverToBoxAdapter(child: Sizer()),
              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 10),
              //     child: Row(children: [
              //       const Sizer(width: 8),
              //       Expanded(
              //         child: _buildStarWidget(
              //           onTap: () {
              //             AdInterstitialTop.loadIntersitialAd();
              //             AdInterstitialTop.showInterstitialAd();
              //             context.push(Routes.RIDE_HOME);
              //           },
              //           shadowColor: Color(0xff8000FF),
              //           image: Assets.car2Image,
              //           title: LocaleKeys.ride.localize,
              //         ),
              //       ),
              //       const Sizer(width: 32),
              //       Expanded(
              //         child: _buildStarWidget(
              //           onTap: () {
              //             AdInterstitialTop.loadIntersitialAd();
              //             AdInterstitialTop.showInterstitialAd();
              //             context.push(Routes.VISITA);
              //           },
              //           shadowColor: Color(0xff4997D0),
              //           image: Assets.doctorImage,
              //           title: LocaleKeys.health.localize,
              //         ),
              //       ),
              //       const Sizer(width: 32),
              //       Expanded(
              //         child: _buildStarWidget(
              //           onTap: () {
              //             AdInterstitialTop.loadIntersitialAd();
              //             AdInterstitialTop.showInterstitialAd();
              //             HandleCashback.setCount('beAStarCount', context);
              //             context.push(Routes.FOOD);
              //           },
              //           shadowColor: Color(0xffFF7F00),
              //           image: Assets.mealImage,
              //           title: LocaleKeys.meal.localize,
              //         ),
              //       ),
              //       const Sizer(width: 8),
              //     ]),
              //   ),
              // ),
              // const SliverToBoxAdapter(child: Sizer()),
              // const SliverToBoxAdapter(child: Sizer()),
              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 10),
              //     child: Row(
              //       children: [
              //         const Sizer(width: 8),
              //         Expanded(child: _pickMeAndComeWithUWidget()),
              //         const Sizer(width: 32),
              //         Expanded(
              //           child: _buildStarWidget(
              //             onTap: () {
              //               AdInterstitialTop.loadIntersitialAd();
              //               AdInterstitialTop.showInterstitialAd();
              //               HandleCashback.setCount('beAStarCount', context);
              //               context.push(Routes.BE_STAR);
              //             },
              //             shadowColor:
              //                 AppColors.SECONDARY_COLOR.withValues(alpha: .7),
              //             image: Assets.tube1,
              //             title: LocaleKeys.tube.localize,
              //           ),
              //         ),
              //         const Sizer(width: 32),
              //         Expanded(
              //           child: _buildStarWidget(
              //             onTap: () {
              //               AdInterstitialTop.loadIntersitialAd();
              //               AdInterstitialTop.showInterstitialAd();
              //               context.push(Routes.MARRIAGESUBCATEGORIES);
              //             },
              //             shadowColor: const Color(0xffFFC0CB),
              //             image: Assets.marriage,
              //             title: LocaleKeys.marriage.localize,
              //           ),
              //         ),
              //         const Sizer(width: 8),
              //       ],
              //     ),
              //   ),
              // ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: const GridBlocksWidget(),
                ),
              ),
              const SliverToBoxAdapter(child: Sizer()),
              SliverToBoxAdapter(
                child: CustomAnimatedText(
                  text: LocaleKeys.youCanDeActivatePage.localize,
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const CustomDeActivateDialog();
                      },
                    );
                  },
                ),
              ),
              // SliverToBoxAdapter(child: _buildTenPercentWidget()),
              const SliverToBoxAdapter(child: Sizer()),
              // _buildMainCategoriesViews(),
              // const Sizer(),
              //main cats
              BlocProvider(
                create: (BuildContext context) =>
                    serviceLocator<MainCategoriesCubit>()
                      ..getMainCategoryCustomPage(),
                child: BlocBuilder<MainCategoriesCubit, MainCategoriesState>(
                  builder: (context, state) {
                    final controller = context.read<MainCategoriesCubit>();
                    if (state.status == StateStatus.loading) {
                      if (CacheManager.getInt(
                                  CacheManager.selectedCategoryView) ==
                              1 ||
                          CacheManager.getInt(
                                  CacheManager.selectedCategoryView) ==
                              3) {
                        return SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[100]!,
                                  highlightColor: Colors.white24,
                                  child: Container(
                                    height: 200,
                                    width: double.infinity,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.w),
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                  ),
                                );
                              },
                              childCount: 10,
                            ),
                          ),
                        );
                      }
                      if (CacheManager.getInt(
                              CacheManager.selectedCategoryView) ==
                          2) {
                        return SliverToBoxAdapter(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[100]!,
                            highlightColor: Colors.white24,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                height: 400,
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(horizontal: 10.w),
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                decoration: BoxDecoration(
                                  color: AppColors.AUTH_CONTAINER_COLOR,
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const MainCategoriesShimmerLoading();
                      }
                    }
                    print('==> state.customPage ${state.customPage}');
                    print(
                        '==> selectedCategoryView ${CacheManager.getInt(CacheManager.selectedCategoryView)}');
                    if (state.customPage != null) {
                      return getMainCategoryWidgets(controller, state)[
                          CacheManager.getInt(
                                  CacheManager.selectedCategoryView) ??
                              0];
                    } else {
                      return const SliverToBoxAdapter(child: SizedBox.shrink());
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      // ),
    );
  }

  // BlocBuilder<ThumbnailsCubit, BasicState<List<RideThumbnailEntity>>>
  _pickMeAndComeWithUWidget() {
    return _buildRideSubCategoryItem(
      title: context.isArabic ? 'جاي معاك' : 'Trip Join',
      // image: '',

      route: Routes.AVAILABLE_TRIPS,
      onTab: () {
        AdInterstitialTop.loadIntersitialAd();
        AdInterstitialTop.showInterstitialAd();
        return HandleCashback.setCount('tripJoinCount', context);
      },
      // isFavorite: state.data![1].isFavorite,
      // numberOfAds: state.data![1].numberOfAds?.toInt(),
    );
  }

  Widget _buildStarWidget({
    void Function()? onTap,
    required Color shadowColor,
    required String title,
    required String image,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: kToolbarHeight * 2.h,
        height: 64,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(40.r),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.fill,
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              spreadRadius: 5,
              blurRadius: 5,
              offset: const Offset(1, 1),
            )
          ],
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Image.asset(
            //   image,
            //   fit: BoxFit.fill,
            //   // width: double.infinity,
            //   // height: double.infinity,
            // ),
            Container(
              color: Colors.black38,
            ),
            Label(
              text: title,
              style: Styles.mediumText(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 45,
              ),
            ),
          ],
        ),
      ),
    );
    // return SizedBox(
    //   height: kToolbarHeight * 2.h,
    //   width: double.infinity,
    //   child: GestureDetector(
    //     onTap: () {
    //       AdInterstitialTop.loadIntersitialAd();
    //       AdInterstitialTop.showInterstitialAd();
    //       HandleCashback.setCount('beAStarCount', context);
    //       context.push(Routes.BE_STAR);
    //     },
    //     child: Container(
    //       height: kToolbarHeight * 2.h,
    //       decoration: BoxDecoration(
    //         color: Theme
    //             .of(context)
    //             .scaffoldBackgroundColor,
    //         borderRadius: BorderRadius.circular(40.r),
    //         boxShadow: [
    //           BoxShadow(
    //             color: AppColors.SECONDARY_COLOR.withValues(alpha: .7),
    //             spreadRadius: 5,
    //             blurRadius: 5,
    //             offset: const Offset(1, 1),
    //           )
    //         ],
    //         image: DecorationImage(
    //             image: AssetImage(Assets.tube1), fit: BoxFit.fill),
    //       ),
    //       child: Center(
    //         child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    //           Label(
    //             text: LocaleKeys.tube.localize,
    //             style: Styles.mediumText(
    //               color: Colors.white,
    //               fontWeight: FontWeight.bold,
    //               fontSize: 45,
    //             ),
    //           )
    //         ]),
    //       ),
    //     ),
    //   ),
    // );
  }

  Widget itemAuctionAndInstallmentWidget(
      String label, Function function, IconData icon) {
    return Expanded(
      child: InkWell(
        onTap: () => context.go(Routes.MAZADAT),
        child: SizedBox(
          height: kToolbarHeight * .9.h,
          child: Stack(
            children: [
              Positioned.fill(
                child: AppButton(
                    color: AppColors.AUTH_CONTAINER_COLOR,
                    backColor: AppColors.PRIMARY_COLOR,
                    label: label,
                    style: Styles.mediumText(
                      color: AppColors.AUTH_CONTAINER_COLOR,
                      fontWeight: FontWeight.bold,
                    ),
                    icon: icon,
                    iconSize: 50.h,
                    onPressed: () => function()),
              ),
              Positioned(
                  bottom: 5,
                  left: 5,
                  child: Icon(
                    Icons.star,
                    size: 20.h,
                    color: AppColors.ACCENT_COLOR,
                  )),
              Positioned(
                  top: 0,
                  left: 10,
                  child: Icon(
                    Icons.star,
                    size: 20.h,
                    color: AppColors.ACCENT_COLOR,
                  )),
              Positioned(
                  top: 15,
                  right: 10,
                  child: Icon(
                    Icons.star,
                    size: 20.h,
                    color: AppColors.ACCENT_COLOR,
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRideSubCategoryItem(
      {required String title, String? route, required Function() onTab}) {
    return InkWell(
      // onTap: () => context.push(Routes.ADS, extra: service.value()),
      onTap: () {
        onTab();
        route != null ? context.push(route) : null;
      },
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(40.r),
          image: DecorationImage(
            image: AssetImage(Assets.joinTrip),
            fit: BoxFit.fill,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.PRIMARY_COLOR.withValues(alpha: .8),
              spreadRadius: 5,
              blurRadius: 5,
              offset: const Offset(1, 1),
            )
          ],
          // image: DecorationImage(
          //     image: AssetImage(Assets.joinTrip), fit: BoxFit.fill),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Image.asset(
            //   Assets.joinTrip,
            //   fit: BoxFit.fill,
            //   width: double.infinity,
            // ),
            Container(
              color: Colors.black38,
            ),
            Label(
              text: title,
              style: Styles.mediumText(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTenPercentWidget() {
    return SizedBox(
      height: kToolbarHeight * .9.h,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: AppButton(
                      color: AppColors.AUTH_CONTAINER_COLOR,
                      label: LocaleKeys.billCashback.localize,
                      style: Styles.mediumText(
                        color: AppColors.AUTH_CONTAINER_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                      icon: Icons.star,
                      iconSize: 50.h,
                      onPressed: () {
                        HandleCashback.setCount('tenPercentCount', context);
                        context.push(Routes.TenPercent);
                      }),
                ),
                Positioned(
                    bottom: 5,
                    left: 5,
                    child: Icon(
                      Icons.star,
                      size: 20.h,
                      color: AppColors.ACCENT_COLOR,
                    )),
                Positioned(
                    top: 0,
                    left: 10,
                    child: Icon(
                      Icons.star,
                      size: 20.h,
                      color: AppColors.ACCENT_COLOR,
                    )),
                Positioned(
                    top: 15,
                    right: 10,
                    child: Icon(
                      Icons.star,
                      size: 20.h,
                      color: AppColors.ACCENT_COLOR,
                    ))
              ],
            ),
          ),
          // const Sizer(),
          // Expanded(
          //   child: Stack(
          //     children: [
          //       Positioned.fill(
          //         child: AppButton(
          //             color: AppColors.AUTH_CONTAINER_COLOR,
          //             label: LocaleKeys.marriage.localize,
          //             style: Styles.mediumText(
          //               color: AppColors.AUTH_CONTAINER_COLOR,
          //               fontWeight: FontWeight.bold,
          //             ),
          //             icon: Icons.star,
          //             iconSize: 50.h,
          //             onPressed: () {
          //               //HandleCashback.setCount('tenPercentCount',context);
          //               context.push(Routes.Married);
          //             }),
          //       ),
          //       Positioned(
          //           bottom: 5,
          //           left: 5,
          //           child: Icon(
          //             Icons.star,
          //             size: 20.h,
          //             color: AppColors.ACCENT_COLOR,
          //           )),
          //       Positioned(
          //           top: 0,
          //           left: 10,
          //           child: Icon(
          //             Icons.star,
          //             size: 20.h,
          //             color: AppColors.ACCENT_COLOR,
          //           )),
          //       Positioned(
          //           top: 15,
          //           right: 10,
          //           child: Icon(
          //             Icons.star,
          //             size: 20.h,
          //             color: AppColors.ACCENT_COLOR,
          //           ))
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

class CustomDeActivateDialog extends StatelessWidget {
  const CustomDeActivateDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      title: Center(
        child: Text(
          LocaleKeys.deActivateCustomPage.localize,
          style: Styles.headerText(
              color: Theme.of(context).textTheme.bodyMedium?.color),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.areYouSureToDeActivate.localize,
          ),
          Sizer(
            height: 16,
          ),
          Row(children: [
            Expanded(
              child: CustomElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(LocaleKeys.cancel.localize,
                    style: Styles.smallText(color: AppColors.whiteColor)),
              ),
            ),
            Sizer(),
            Expanded(
              child: CustomElevatedButton(
                onPressed: () async {
                  // await context.read<CustomPageCubit>().updateActivate(false);
                  // // Restart.restartApp();
                  // Phoenix.rebirth(context);
                  showAnimatedDialog(
                    context,
                    AlertDialog(
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Label(
                              text: LocaleKeys.restartToApply.localize,
                              style: Styles.headerText(
                                  fontWeight: FontWeight.w400)),
                          const Sizer(),
                          Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  label: LocaleKeys.cancel.localize,
                                ),
                              ),
                              const Sizer(
                                width: 16,
                              ),
                              Expanded(
                                child: AppButton(
                                  backColor: AppColors.PRIMARY_COLOR,
                                  onPressed: () {
                                    context
                                        .read<CustomPageCubit>()
                                        .updateActivate(true);
                                    Restart.restartApp();
                                  },
                                  label: LocaleKeys.restart.localize,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Text(
                  LocaleKeys.yes.localize,
                  style: Styles.smallText(color: AppColors.whiteColor),
                ),
              ),
            ),
          ])
        ],
      ),
    );
  }
}

class CustomAnimatedText extends StatelessWidget {
  const CustomAnimatedText({
    super.key,
    required this.text,
    this.onTap,
    this.textDirection,
  });

  final String text;
  final void Function()? onTap;
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    return ClickableWidget(
      onTap: onTap,
      child: Container(
        height: 60.h,
        alignment: Alignment.center,
        child: AutoScrollText(
          velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
          text,
          style:
              Styles.headerText(fontSize: 30, color: AppColors.SECONDARY_COLOR),
          textDirection: textDirection ??
              (context.isArabic ? TextDirection.rtl : TextDirection.ltr),
          selectable: true,
          // textStyle: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class PickMeAndComeWithYouLShimmerLoading extends StatelessWidget {
  const PickMeAndComeWithYouLShimmerLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[100]!,
      highlightColor: Colors.white24,
      child: Container(
        width: 100.h,
        height: kToolbarHeight * 2.h,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: AppColors.AUTH_CONTAINER_COLOR,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.grey),
        ),
      ),
    );
  }
}

class MainCategoriesShimmerLoading extends StatelessWidget {
  const MainCategoriesShimmerLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[100]!,
        highlightColor: Colors.white24,
        child: Column(
          children: List.generate(
            6,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 15.h),
              child: Container(
                height: MediaQuery.of(context).size.height * .15.h,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: AppColors.AUTH_CONTAINER_COLOR,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainCategoriesListView extends StatelessWidget {
  const MainCategoriesListView({
    super.key,
    required this.controller,
    required this.state,
  });

  final MainCategoriesState state;
  final MainCategoriesCubit controller;

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(
      state.customPage?.length ?? 0,
      (index) {

        final category = state.customPage![index];

        return InkWell(
          onTap: () {
            AdInterstitialTop.loadIntersitialAd();
            AdInterstitialTop.showInterstitialAd();
            HandleCashback.setCount('mainCategoriesCount', context);
            print('category.id ${category.id}');
            print('category $category');
            if (category.id == '62c8b5b09332225799fe335e') {
              context.push(Routes.MARRIAGESUBCATEGORIES, extra: category);
            } else {
              context.push(
                Routes.CustomPageSubCategoriesView,
                extra: CustomPageSubCategoriesParams(
                    mainCategory: category, isCustomPage: true),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: MainCategoryBanner(
              category: category,
              onFavorite: () async {
                final result =
                    await controller.toggleFavoriteMedicalService(category.id);
                print("result $result");
                return result;
              },
            ),
          ),
        );
      },
    );
    return SliverToBoxAdapter(
      child: CarouselSlider(
        options: CarouselOptions(
          height: MediaQuery.of(context).size.height * (0.4),
          // Adjust depending on card height
          autoPlay: true,
          enlargeCenterPage: false,
          enlargeStrategy: CenterPageEnlargeStrategy.scale,
          viewportFraction: 0.31,
          // enlargeFactor: 0.3,
          // padEnds: false,
          // disableCenter: true,
          // Show 3 cards: center + partial sides
          enableInfiniteScroll: true,
          autoPlayInterval: const Duration(seconds: 3),
          scrollDirection: Axis.vertical,
        ),
        items: items.map((item) {
          return item;
        }).toList(),
      ),
    );
   /* return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final isLastItem = index == (state.customPage?.length ?? 0) * 2 - 1;

          if (index.isOdd) {
            return const Sizer(); // separator
          }

          final realIndex = index ~/ 2;
          final category = state.customPage![realIndex];

          return InkWell(
            onTap: () {
              AdInterstitialTop.loadIntersitialAd();
              AdInterstitialTop.showInterstitialAd();
              HandleCashback.setCount('mainCategoriesCount', context);
              print('category.id ${category.id}');
              print('category $category');
              if (category.id == '62c8b5b09332225799fe335e') {
                context.push(Routes.MARRIAGESUBCATEGORIES, extra: category);
              } else {
                context.push(
                  Routes.CustomPageSubCategoriesView,
                  extra: CustomPageSubCategoriesParams(
                      mainCategory: category, isCustomPage: true),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: MainCategoryBanner(
                category: category,
                onFavorite: () async {
                  final result = await controller
                      .toggleFavoriteMedicalService(category.id);
                  print("result $result");
                  return result;
                },
              ),
            ),
          );
        },
        childCount:
            (state.customPage?.length ?? 0) * 2 - 1, // account for separators
      ),
    );*/
  }
}
