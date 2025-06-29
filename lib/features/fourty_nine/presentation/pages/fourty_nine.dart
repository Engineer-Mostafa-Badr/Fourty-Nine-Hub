import 'dart:developer';

import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/ads/app_open_model.dart';
import 'package:fourtyninehub/ads/banner_ad_model.dart';
import 'package:fourtyninehub/ads/interstitial_ad_model.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/main_category_banner.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/core/widget/clickable_widget.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/features/fourty_nine/domain/entities/main_category_entity.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/widgets/animated_text.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/firebase_notfications_cubit/firebase_notfications_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/notification_socket_io/notification_socket_io_cubit.dart';
import 'package:fourtyninehub/features/notifications/presentation/widgets/notification_snackbar.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../common/widgets/dynamic/wallet_widget.dart';
import '../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../core/localization/locale_keys.g.dart';
import '../../../../core/widget/custom_scaffold.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../widgets/announce_widget.dart';
import '../widgets/exit_widget.dart';
import '../widgets/favourite_screens_view.dart';
import '../widgets/grid_blocks_widget.dart';
import 'main_categories_cards_view.dart';

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

    // await checkLogin();
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
    _setupScrollController();
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
       ExitWidget(
        child: CustomScaffold(
          key: _scaffoldKey,
          appBar: const HomeAppbar(
            isWithBackArrow: false,
            language: true,
            // isHaveLeading: true,
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
          // drawer: const DrawerWidget(),
          body: ListView(
            controller: scrollController,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            children: [
              const AddBanner(),
              const AnnounceWidget(),
              const Sizer(),
              !context.read<UserCubit>().isLoggedIn
                  ? const Sizer()
                  : const SizedBox.shrink(),
              ScrollableTextWithAnimation(
                textDirection:
                    context.isArabic ? TextDirection.rtl : TextDirection.ltr,
              ),

              //wallet

              context.read<UserCubit>().isLoggedIn
                  ? const WalletWidget()
                  : const SizedBox.shrink(),
              ClickableWidget(
                onTap: () {
                  if (!context.read<UserCubit>().isLoggedIn) {
                    return pleaseLoginDialog(context);
                  }
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
                    "${LocaleKeys.choosePreferredAppStyle.localize}..  ${LocaleKeys.clickHere.localize}!!                                         ",
                    style: Styles.headerText(
                        fontSize: 30,
                        color: context.isDarkMode
                            ? Colors.white
                            : AppColors.SECONDARY_COLOR),
                    textDirection: context.isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                    selectable: true,
                    // textStyle: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              const Sizer(),
              GridBlocksWidget(),
              // Row(children: [
              //   const Sizer(width: 8),
              //   Expanded(
              //     child: _buildStarWidget(
              //       onTap: () {
              //         AdInterstitialTop.loadIntersitialAd();
              //         AdInterstitialTop.showInterstitialAd();
              //         context.push(Routes.RIDE_HOME);
              //       },
              //       shadowColor: Color(0xff8000FF),
              //       image: Assets.car2Image,
              //       title: LocaleKeys.ride.localize,
              //     ),
              //   ),
              //   const Sizer(width: 32),
              //   Expanded(
              //     child: _buildStarWidget(
              //       onTap: () {
              //         AdInterstitialTop.loadIntersitialAd();
              //         AdInterstitialTop.showInterstitialAd();
              //         context.push(Routes.VISITA);
              //       },
              //       shadowColor: Color(0xff4997D0),
              //       image: Assets.doctorImage,
              //       title: LocaleKeys.health.localize,
              //     ),
              //   ),
              //   const Sizer(width: 32),
              //   Expanded(
              //     child: _buildStarWidget(
              //       onTap: () {
              //         AdInterstitialTop.loadIntersitialAd();
              //         AdInterstitialTop.showInterstitialAd();
              //         HandleCashback.setCount('beAStarCount', context);
              //         context.push(Routes.FOOD);
              //       },
              //       shadowColor: Color(0xffFF7F00),
              //       image: Assets.mealImage,
              //       title: LocaleKeys.meal.localize,
              //     ),
              //   ),
              //   const Sizer(width: 8),
              // ]),
              // const Sizer(),
              // const Sizer(),
              // Row(
              //   children: [
              //     const Sizer(width: 8),
              //     Expanded(child: _pickMeAndComeWithUWidget()),
              //     const Sizer(width: 32),
              //     Expanded(
              //       child: _buildStarWidget(
              //         onTap: () {
              //           AdInterstitialTop.loadIntersitialAd();
              //           AdInterstitialTop.showInterstitialAd();
              //           HandleCashback.setCount('beAStarCount', context);
              //           context.push(Routes.BE_STAR);
              //         },
              //         shadowColor:
              //             AppColors.SECONDARY_COLOR.withValues(alpha: .7),
              //         image: Assets.tube1,
              //         title: LocaleKeys.tube.localize,
              //       ),
              //     ),
              //     const Sizer(width: 32),
              //     Expanded(
              //       child: _buildStarWidget(
              //         onTap: () {
              //           AdInterstitialTop.loadIntersitialAd();
              //           AdInterstitialTop.showInterstitialAd();
              //           context.push(Routes.MARRIAGESUBCATEGORIES);
              //         },
              //         shadowColor: Color(0xffFFC0CB),
              //         image: Assets.marriage,
              //         title: LocaleKeys.marriage.localize,
              //       ),
              //     ),
              //     const Sizer(width: 8),
              //   ],
              // ),
              const Sizer(),
              const Sizer(),
              //cats layout
              BlocBuilder<MainCategoriesCubit, MainCategoriesState>(
                builder: (context, state) {
                  var data = state.data;
                  print('MainCategoriesCubit data is $data');
                  return _buildMainCategoriesViews(data);
                },
              ),
              const Sizer(),
              //main cats
              BlocBuilder<MainCategoriesCubit, MainCategoriesState>(
                builder: (context, state) {
                  final controller = context.read<MainCategoriesCubit>();
                  if (state.status == StateStatus.loading) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[100]!,
                      highlightColor: Colors.white24,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 10,
                                crossAxisCount: 2,
                                childAspectRatio: 2 / 3),
                        itemCount: 6,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Container(
                              height:
                                  MediaQuery.of(context).size.height * .15.h,
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: 10.w),
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              decoration: BoxDecoration(
                                color: AppColors.AUTH_CONTAINER_COLOR,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: Colors.grey),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }
                  if (state.data != null) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 10,
                              crossAxisCount: 2,
                              childAspectRatio: .9),
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
      // ),
    );
  }

  Widget _buildMainCategoriesViews(List<MainCategoryEntity>? extra) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 16,
      children: [
        Expanded(
          child: _buildItemTabBar(
            Image.asset(
              Assets.gridIcon,
              width: 24,
              height: 24,
            ),
            Routes.MAINCATEGORIESTREE,
            () => HandleCashback.setCount('threeDotsCount', context),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (context.read<UserCubit>().isLoggedIn) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FavouriteScreensView()));
            } else {
              return pleaseLoginDialog(context);
            }
          },
          child: Container(
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFD9D9D9),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.favorite, color: Colors.red),
          ),
        ),
        Expanded(
          child: _buildItemTabBar(
            Image.asset(
              Assets.sliderIcon,
              width: 24,
              height: 24,
            ),
            Routes.MAINCATEGORIESCARDS,
            () {
              log('extra is $extra');
              AdInterstitialTop.loadIntersitialAd();
              AdInterstitialTop.showInterstitialAd();
              HandleCashback.setCount('mainCategoriesSliderCount', context);
            },
            extra: extra,
          ),
        ),
      ],
    );
  }

  Widget _buildItemTabBar(Widget icon, String routeName, Function() onTab,
      {List<MainCategoryEntity>? extra}) {
    return InkWell(
      onTap: () {
        onTab();
        if (routeName == Routes.MAINCATEGORIESCARDS) {
          context.push(routeName, extra: MainCategoriesCardsParams(data: extra,isCustomPage: false));
        } else {
          context.push(routeName, extra: extra);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.BG_GRAY_COLOR,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: icon,
      ),
    );
  }
}
// BlocBuilder<ThumbnailsCubit, BasicState<List<RideThumbnailEntity>>>
/*  _pickMeAndComeWithUWidget() {
    return _buildRideSubCategoryItem(
      title: context.isArabic ? 'جاي معاك' : 'Trip Join',
      // image: '',

      route: Routes.newRideModeScreen,
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
}*/

/*  Row _auctionAndInstallmentWidget() {
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
  }*/

/*  Widget _buildBookingWidget() {
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
  }*/

/*  Widget _walletsWidget() {
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
  }*/

/*  Widget _buildTenPercentWidget() {
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }*/

/*  Widget itemAuctionAndInstallmentWidget(
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
  }*/
