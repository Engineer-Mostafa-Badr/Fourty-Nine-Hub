import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/ads/app_open_model.dart';
import 'package:fourtyninehub/ads/banner_ad_model.dart';
import 'package:fourtyninehub/ads/interstitial_ad_model.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/core/utils/shared_pref.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/thumbnails/thumbnails_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/widgets/animated_text.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/firebase_notfications_cubit/firebase_notfications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_socket_io/notification_socket_io_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/notification_snackbar.dart';
import 'package:fourtyninehub/features/ride/RideRequest/domain/entity/ride_thumbnail_entity.dart';
import 'package:fourtyninehub/features/ride/RideRequest/presentation/cubit/location_socket_cubit.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../common/widgets/dynamic/drawer.dart';
import '../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/dynamic/wallet_widget.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../common/widgets/stateless/buttons/app_button.dart';
import '../../../../core/enums/ride_services_enum.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../custom_page/presentation/page/widget/service_page_preview copy.dart';
import '../widgets/announce_widget.dart';
import 'package:auto_scroll_text/auto_scroll_text.dart';

import '../widgets/exit_widget.dart';
import 'package:circular_menu/circular_menu.dart';

class FourtyNineView extends StatefulWidget {
  const FourtyNineView({super.key});

  @override
  State<FourtyNineView> createState() => _FourtyNineViewState();
}

class _FourtyNineViewState extends State<FourtyNineView>
    with WidgetsBindingObserver {
  ScrollController scrollController = ScrollController();
  bool _isScrollingDown = false;

  checkLogin() async {
    try {
      if (!context.isUserLoggedIn) await context.read<UserCubit>().getUser();
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
  void didChangeDependencies() async {
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);

    await checkLogin();
    super.didChangeDependencies();
    _setupScrollController();

    context
        .read<FirebaseNotficationsCubit>()
        .setupInterceptedMessage(context: context);
    // context.read<LocationSocketCubit>().updateDriverLocationOn();
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
    // context
    //     .read<NotificationSocketIoCubit>()
    //     .notificationListener(languageCode: 'en');
  }

  @override
  initState() {
    context
        .read<NotificationSocketIoCubit>()
        .notificationListener(languageCode: 'en');

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // context.push(Routes.REELS);
    print("objectUser${UserCubit.to.state.data?.id}");
    return BlocListener<NotificationSocketIoCubit, NotificationSocketIoState>(
      listener: (context, state) {
        if (state is NotificationSocketIoNewNotification) {
          // pr('new notfication is recieved by the bloc listner');
          // pr(state.notificationEntity);
          notificationSnackBar(
              context: context,
              notificationEntity: state.notificationEntity,
              isAppNotification: state.notificationEntity.filterType == 'app');
        } else if (state is NotificationSocketIoFailed) {
          // pr('Failed to recieve the new notfication ');
          // pr(state.message);
        }
      },
      child: ExitWidget(
        child: CustomScaffold(
          key: _scaffoldKey,
          appBar: HomeAppbar(
            isWithBackArrow: false,
            language: true,
            leading: IconButton(
              icon: const Icon(Icons.menu), // The menu icon
              onPressed: () {
                HandleCashback.setCount('drawerCount', context);
                _scaffoldKey.currentState?.openDrawer(); // Open the drawer
              },
            ),
          ),
          bottomNavigationBar: BottomNavigator(
            scrollController: scrollController,
            isScrollingDown: _isScrollingDown,
            mainCategory: 1,
            index: 2,
          ),
          floatingActionButton: _isScrollingDown
              ? null
              : const FloatingButton(
            changeView: 1,
            icon: Icons.person,
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
          drawer: const DrawerWidget(),
          body: ListView(
            controller: scrollController,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            children: [
              const AddBanner(),
              //carousel slider
              const Sizer(),
              const AnnounceWidget(),
              const Sizer(),
              !context
                  .read<UserCubit>()
                  .isLoggedIn
                  ? const Sizer()
                  : const SizedBox.shrink(),
              ScrollableTextWithAnimation(
                textDirection:
                context.isArabic ? TextDirection.rtl : TextDirection.ltr,
              ),

              //wallet

              context
                  .read<UserCubit>()
                  .isLoggedIn
                  ? const WalletWidget()
                  : const SizedBox.shrink(),
              ClickableWidget(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditPage(),
                    ),
                  );
                },
                child: Container(
                  height: 60.h,
                  alignment: Alignment.center,
                  child: AutoScrollText(
                    velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
                    "${LocaleKeys.choosePreferredAppStyle
                        .localize}..  ${LocaleKeys.clickHere
                        .localize}!!                                         ",
                    style: Styles.headerText(
                        fontSize: 30, color: AppColors.SECONDARY_COLOR),
                    textDirection: context.isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    selectable: true,
                    // textStyle: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              // ScrollableTextWithAnimation(text: 'Colored text.kasmdlkasdmklasmdkladmslkamdklasmdkndasjkdnasjkdnsjka',),
              //    Sizer(),
              //admob
              //   const GoogleAddsBanner(),
              // Row(
              //   children: [
              //     // Expanded(
              //     //   child: _walletsWidget(),
              //     // ),
              //     // const Sizer(),
              //     Expanded(child: _buildStarWidget()),
              //   ],
              // ),
              const Sizer(),
              //pick me and come with U
              Row(children: [
                Expanded(child: _buildStarWidget()),
                const Sizer(
                  width: 32,
                ),
                Expanded(child: _pickMeAndComeWithUWidget()),
              ]),
              // _pickMeAndComeWithUWidget(),
              const Sizer(),
              // _buildTenPercentWidget(),
              // const Sizer(),
              // _auctionAndInstallmentWidget(),
              // const Sizer(),
              // _buildBookingWidget(),
              const Sizer(),
              //cats layout
              _buildMainCategoriesViews(),
              const Sizer(),
              //main cats
              BlocBuilder<MainCategoriesCubit, MainCategoriesState>(
                builder: (context, state) {
                  final controller = context.read<MainCategoriesCubit>();
                  if (state.status == StateStatus.loading) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[100]!,
                      highlightColor: Colors.white24,
                      child: Column(
                        children: List.generate(
                            6,
                                (index) =>
                                Padding(
                                  padding: EdgeInsets.only(bottom: 15.h),
                                  child: Container(
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height *
                                        .15.h,
                                    width: double.infinity,
                                    margin:
                                    EdgeInsets.symmetric(horizontal: 10.w),
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 10.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.AUTH_CONTAINER_COLOR,
                                      borderRadius: BorderRadius.circular(20.r),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                  ),
                                )),
                      ),
                    );
                  }
                  if (state.data != null) {
                    return GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 10,
                          crossAxisCount: 2,
                          childAspectRatio: 2 / 3),
                      itemCount: state.data?.length ?? 0,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            onTap: () {
                              AdInterstitialTop.loadIntersitialAd();
                              AdInterstitialTop.showInterstitialAd();
                              HandleCashback.setCount(
                                  'mainCategoriesCount', context);
                              if (state.data![index].id ==
                                  '62c8b5b09332225799fe335e') {
                                context.push(Routes.MARRIAGESUBCATEGORIES,
                                    extra: state.data![index]);
                              } else {
                                context.push(Routes.SUBCATEGORIES,
                                    extra: state.data![index]);
                              }
                            },
                            child: MainCategoryBanner(
                              category: state.data![index],
                              onFavorite: () async {
                                var result = await controller
                                    .toggleFavoriteMedicalService(
                                    state.data![index].id);
                                print("result$result");
                                return result;
                              },
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainCategoriesViews() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildItemTabBar(
            const Icon(
              Icons.grid_view,
              color: AppColors.PRIMARY_COLOR,
            ),
            Routes.MAINCATEGORIESTREE,
                () => HandleCashback.setCount('threeDotsCount', context),
          ),
        ),
        const Sizer(),
        const Sizer(),
        CircularMenu(
            radius: 70,
            backgroundWidget: Container(
              decoration: const BoxDecoration(
                color: AppColors.BG_GRAY_COLOR,
                shape: BoxShape.circle,
              ),
              width: 40,
              height: 40,
              child: const Icon(
                Icons.favorite_rounded,
                color: AppColors.SECONDARY_COLOR,
              ),
            ),
            //   items: [
            //     CircularMenuItem(
            //       // menu item callback
            //         onTap: () {
            //         },
            //         icon: Icons.home,
            //         color: Colors.blue,
            //         iconColor: Colors.white,
            //         iconSize: 30.0,
            //         margin: 10.0,
            //         padding: 10.0,
            //
            //     ),
            //     CircularMenuItem(
            //         icon: Icons.search,
            //         onTap: () {
            //           //callback
            //         }),
            //     CircularMenuItem(
            //         icon: Icons.settings,
            //         onTap: () {
            //           //callback
            //         }),
            //     CircularMenuItem(
            //         icon: Icons.star,
            //         onTap: () {
            //           //callback
            //         }),
            //     CircularMenuItem(
            //         icon: Icons.pages,
            //         onTap: () {
            //           //callback
            //         }),
            //   ]
            //   backgroundWidget: Center(
            //     child: Text(
            //       "Flutter ",
            //       style: TextStyle(
            //         fontWeight: FontWeight.bold,
            //         fontSize: 18,
            //       ),
            //     ),
            //   ),
            toggleButtonColor: Colors.transparent,
            alignment: Alignment.center,
            items: [
              CircularMenuItem(
                onTap: () {
                  print('tapped');
                },
                icon: Icons.search,
                iconSize: 50,
                color: Colors.blue,
              ),
              CircularMenuItem(
                onTap: () {
                  print('tapped');
                },
                icon: Icons.home,
                color: Colors.grey,
              ),
              CircularMenuItem(
                onTap: () {
                  print('tapped');
                },
                icon: Icons.settings,
                color: Colors.green,
              ),
              CircularMenuItem(
                onTap: () {
                  print('tapped');
                },
                icon: Icons.search,
                color: Colors.blue,
              ),
              CircularMenuItem(
                onTap: () {
                  print('tapped');
                },
                icon: Icons.home,
                color: Colors.grey,
              ),
              CircularMenuItem(
                onTap: () {
                  print('tapped');
                },
                icon: Icons.settings,
                color: Colors.green,
              ),
            ]),
        const Sizer(),
        const Sizer(),
        Expanded(
          child: _buildItemTabBar(
              const Icon(
                Icons.view_carousel,
                color: AppColors.PRIMARY_COLOR,
              ),
              Routes.MAINCATEGORIESCARDS, () {
            AdInterstitialTop.loadIntersitialAd();
            AdInterstitialTop.showInterstitialAd();
            HandleCashback.setCount('mainCategoriesSliderCount', context);
          }),
        ),
      ],
    );
  }

  Widget _buildItemTabBar(Widget icon,
      String routeName,
      Function() onTab,) {
    return InkWell(
      onTap: () {
        onTab();
        context.push(routeName);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.BG_GRAY_COLOR,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: icon,
      ),
    );
  }

  // BlocBuilder<ThumbnailsCubit, BasicState<List<RideThumbnailEntity>>>
      _pickMeAndComeWithUWidget() {
    return  Row(
      children: [
        // Expanded(
        //   child: _buildRideSubCategoryItem(
        //     service: state.data?[0].service ?? RideServicesEnum.pickMe,
        //     title: LocaleKeys.carpool.localize,
        //     image: state.data?[0].image ?? '',
        //     onTab: () {
        //       AdInterstitialTop.loadIntersitialAd();
        //       AdInterstitialTop.showInterstitialAd();
        //       return HandleCashback.setCount('carPoolCount',context);
        //     },
        //     // image: Assets.carpool,
        //     // isFavorite: state.data![0].is,
        //     // numberOfAds: state.data![0].numberOfAds?.toInt(),
        //     route: Routes.CAR_POOL,
        //   ),
        // ),
        // const Sizer(),
        const Sizer(),
        Expanded(
          child: _buildRideSubCategoryItem(
            title: context.isArabic?'جاي معاك':'Trip Join',
            // image: '',

            route: Routes.AVAILABLE_TRIPS,
            onTab: () {
              AdInterstitialTop.loadIntersitialAd();
              AdInterstitialTop.showInterstitialAd();
              return HandleCashback.setCount('tripJoinCount', context);
            },
            // isFavorite: state.data![1].isFavorite,
            // numberOfAds: state.data![1].numberOfAds?.toInt(),
          ),
        )
      ],
    );
  }

  Row _auctionAndInstallmentWidget() {
    return Row(
      children: [
        itemAuctionAndInstallmentWidget(LocaleKeys.auction.localize, () {
          HandleCashback.setCount('mazadat', context);
          context.push(Routes.MAZADAT);
        }, Icons.group),
        const Sizer(),
        itemAuctionAndInstallmentWidget(LocaleKeys.installments.localize, () {
          HandleCashback.setCount('installments', context);
          context.push(Routes.INSTALLMENT);
        }, Icons.list),
      ],
    );
  }

  Widget _buildBookingWidget() {
    return SizedBox(
      height: kToolbarHeight * .9.h,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: AppButton(
                color: AppColors.AUTH_CONTAINER_COLOR,
                label: LocaleKeys.booking.localize,
                style: Styles.mediumText(
                  color: AppColors.AUTH_CONTAINER_COLOR,
                  fontWeight: FontWeight.bold,
                ),
                icon: Icons.auto_awesome,
                iconSize: 50.h,
                onPressed: () async {
                  HandleCashback.setCount('booking', context);
                  int? num = CacheManager.getInt('booking');
                  print(num);
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
    );
  }

  Widget _buildStarWidget() {
    return SizedBox(
        height: kToolbarHeight * 2.h,
        width: double.infinity,
        child: Positioned.fill(
          child: GestureDetector(
              onTap: () {
                AdInterstitialTop.loadIntersitialAd();
                AdInterstitialTop.showInterstitialAd();
                HandleCashback.setCount('beAStarCount', context);
                context.push(Routes.BE_STAR);
              },
              child: Container(
                  height: kToolbarHeight * 2.h,
                  decoration: BoxDecoration(
                    color: Theme
                        .of(context)
                        .scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(40.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.SECONDARY_COLOR.withValues(alpha: .7),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: const Offset(1, 1),
                      )
                    ],
                    image: DecorationImage(
                        image: AssetImage(Assets.tube1), fit: BoxFit.fill),
                  ),
                  child: Center(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Label(
                            text: LocaleKeys.tube.localize,
                            style: Styles.mediumText(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 45,
                            ),
                          )
                        ]),
                  ))),
        ));
  }

  Widget _walletsWidget() {
    return SizedBox(
      height: kToolbarHeight * .9.h,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: AppButton(
                color: AppColors.AUTH_CONTAINER_COLOR,
                label: LocaleKeys.wallets.localize,
                style: Styles.mediumText(
                  color: AppColors.AUTH_CONTAINER_COLOR,
                  fontWeight: FontWeight.bold,
                ),
                icon: Icons.star,
                iconSize: 50.h,
                onPressed: () {
                  // AdInterstitialTop.loadIntersitialAd();
                  // AdInterstitialTop.showInterstitialAd();
                  // HandleCashback.setCount('beAStarCount', context);
                  context.push(Routes.WALLET);
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
    );
  }

  Widget _buildTenPercentWidget() {
    return SizedBox(
      height: kToolbarHeight * .9.h,
      width: double.infinity,
      child: Row(
        children: [
          // Expanded(
          //   child: Stack(
          //     children: [
          //       Positioned.fill(
          //         child: AppButton(
          //             color: AppColors.AUTH_CONTAINER_COLOR,
          //             label: LocaleKeys.billCashback.localize,
          //             style: Styles.mediumText(
          //               color: AppColors.AUTH_CONTAINER_COLOR,
          //               fontWeight: FontWeight.bold,
          //             ),
          //             icon: Icons.star,
          //             iconSize: 50.h,
          //             onPressed: () {
          //               HandleCashback.setCount('tenPercentCount', context);
          //               context.push(Routes.TenPercent);
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
          // const Sizer(),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: AppButton(
                      color: AppColors.AUTH_CONTAINER_COLOR,
                      label: LocaleKeys.marriage.localize,
                      style: Styles.mediumText(
                        color: AppColors.AUTH_CONTAINER_COLOR,
                        fontWeight: FontWeight.bold,
                      ),
                      icon: Icons.star,
                      iconSize: 50.h,
                      onPressed: () {
                        //HandleCashback.setCount('tenPercentCount',context);
                        context.push(Routes.MARRIAGESUBCATEGORIES,
                            extra: MainCategoryEntity(
                                id: '62c8b5b09332225799fe335e',
                                nameEn: 'Marriage',
                                name: 'زواج',
                                image: "",
                                banner: '',
                                cover: '',
                                total: 0));
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
                    ),),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget itemAuctionAndInstallmentWidget(String label, Function function,
      IconData icon) {
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

  Widget _buildRideSubCategoryItem({
    required String title,
    String? route,
    required Function() onTab}) {
    return InkWell(
      // onTap: () => context.push(Routes.ADS, extra: service.value()),
      onTap: () {
        onTab();
        route != null ? context.push(route) : null;
      },
      child: Container(
        height: kToolbarHeight * 2.h,
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(40.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.PRIMARY_COLOR.withValues(alpha: .8),
              spreadRadius: 5,
              blurRadius: 5,
              offset: const Offset(1, 1),
            )
          ],
          image: DecorationImage(
              image: AssetImage(Assets.joinTrip), fit: BoxFit.fill),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
      ),
    );
  }
}
