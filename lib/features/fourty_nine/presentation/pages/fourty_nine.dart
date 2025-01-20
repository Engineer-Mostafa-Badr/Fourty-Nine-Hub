import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/styles.dart';
import '../../../../routes/routes.dart';
import '../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../widgets/announce_widget.dart';
import 'package:auto_scroll_text/auto_scroll_text.dart';

import '../widgets/exit_widget.dart';

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
    context.read<LocationSocketCubit>().updateDriverLocationOn();
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
        child: Scaffold(
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
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          drawer: const DrawerWidget(),
          body: ListView(
            controller: scrollController,
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            children: [
              const AddBanner(),
              //carousel slider
              const AnnounceWidget(),
              !context.read<UserCubit>().isLoggedIn
                  ? const Sizer()
                  : const SizedBox.shrink(),
              const ScrollableTextWithAnimation(),

              //wallet
              context.read<UserCubit>().isLoggedIn
                  ? const WalletWidget()
                  : const SizedBox.shrink(),
              ClickableWidget(
                onTap:(){
                  context.push(Routes.CUSTOMPAGE);
                },
                child: Container(
                  height: 60.h,
                  alignment: Alignment.center,
                  child: AutoScrollText(
                    "${LocaleKeys.choosePreferredAppStyle.localize}...   ",
                    style: Styles.headerText(fontSize: 30, color: AppColors.SECONDARY_COLOR),
                    textDirection: context.isArabic?TextDirection.rtl:TextDirection.ltr,
                    selectable: true,
                    // textStyle: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              // ScrollableTextWithAnimation(text: 'Colored text.kasmdlkasdmklasmdkladmslkamdklasmdkndasjkdnasjkdnsjka',),
              //    Sizer(),
              //admob
              //   const GoogleAddsBanner(),
              _buildStarWidget(),
              const Sizer(),
              //pick me and come with U
              _pickMeAndComeWithUWidget(),
              const Sizer(),
              _buildTenPercentWidget(),
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
                            (index) => Padding(
                                  padding: EdgeInsets.only(bottom: 15.h),
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
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
                    return ListView.separated(
                      itemCount: state.data?.length ?? 0,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            AdInterstitialTop.loadIntersitialAd();
                            AdInterstitialTop.showInterstitialAd();
                            HandleCashback.setCount(
                                'mainCategoriesCount', context);
                            context.push(Routes.SUBCATEGORIES,
                                extra: state.data![index]);
                          },
                          child: MainCategoryBanner(
                            category: state.data![index],
                            onFavorite: () async {
                              var result =
                                  await controller.toggleFavoriteMedicalService(
                                      state.data![index].id);
                              print("result$result");
                              return result;
                            },
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Sizer(),
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
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: const [
            BoxShadow(
              color: AppColors.GRAY_LIGHT_COLOR3,
              blurRadius: 5,
              spreadRadius: 5,
            )
          ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildItemTabBar(
              SvgPicture.asset(
                Assets.threeDots,
                height: 34.h,
                width: 34.h,
              ),
              Routes.MAINCATEGORIESTREE,
              () => HandleCashback.setCount('threeDotsCount', context),
            ),
            _buildItemTabBar(
                SvgPicture.asset(
                  Assets.mobile,
                  height: 34.h,
                  width: 34.h,
                ),
                Routes.MAINCATEGORIESCARDS, () {
              AdInterstitialTop.loadIntersitialAd();
              AdInterstitialTop.showInterstitialAd();
              HandleCashback.setCount('mainCategoriesSliderCount', context);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildItemTabBar(
    Widget icon,
    String routeName,
    Function() onTab,
  ) {
    return InkWell(
      onTap: () {
        onTab();
        context.push(routeName);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 6.h.w, horizontal: 10.h),
        decoration: const BoxDecoration(),
        child: icon,
      ),
    );
  }

  BlocBuilder<ThumbnailsCubit, BasicState<List<RideThumbnailEntity>>>
      _pickMeAndComeWithUWidget() {
    return BlocBuilder<ThumbnailsCubit, BasicState<List<RideThumbnailEntity>>>(
      builder: (context, state) {
        if (state.status == StateStatus.loading) {
          return Row(
            children: List.generate(
                2,
                (index) => Expanded(
                      child: Shimmer.fromColors(
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
                      ),
                    )),
          );
        } else if (state.status == StateStatus.success) {
          return Row(
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
              Expanded(
                child: _buildRideSubCategoryItem(
                  service:
                      state.data?[1].service ?? RideServicesEnum.comeWithYou,
                  title:state.data![1].name.toString(),
                  image: state.data?[1].image ?? '',
                  // image: Assets.tripJoin,

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
        } else {
          return Container(
            padding:
                //EdgeInsets.all
                const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              LocaleKeys.noRideSubcategories.localize,
              style: TextStyle(fontSize: 32.sp.w, fontWeight: FontWeight.w500),
            ),
          );
        }
      },
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
                  int? num = await CacheManager.getInt('booking');
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
      height: kToolbarHeight * .9.h,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: AppButton(
                color: AppColors.AUTH_CONTAINER_COLOR,
                label: LocaleKeys.beAStar.localize,
                style: Styles.mediumText(
                  color: AppColors.AUTH_CONTAINER_COLOR,
                  fontWeight: FontWeight.bold,
                ),
                icon: Icons.star,
                iconSize: 50.h,
                onPressed: () {
                  AdInterstitialTop.loadIntersitialAd();
                  AdInterstitialTop.showInterstitialAd();
                  HandleCashback.setCount('beAStarCount', context);
                  context.push(Routes.BE_STAR);
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
          const Sizer(),
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
                        context.push(Routes.MARRIAGESUBCATEGORIES,extra: MainCategoryEntity(id: '62c8b5b09332225799fe335e', nameEn: 'Marriage',name:'زواج', image: "", banner: '', cover: '', total: 0));
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
        ],
      ),
    );
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
      {required RideServicesEnum service,
      required String title,
      required String image,
      String? route,
      bool? isFavorite,
      required Function() onTab}) {
    return InkWell(
      // onTap: () => context.push(Routes.ADS, extra: service.value()),
      onTap: () {
        onTab();
        route != null ? context.push(route) : null;
      },
      child: Container(
        height: kToolbarHeight * 2.h,
        padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 5.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(255, 249, 159, 162),
              spreadRadius: 1,
              blurRadius: 3,
              offset: Offset(1, 1),
            )
          ],
        ),
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      image,
                      fit: BoxFit.cover,
                      width: 150,
                      // source: AssetImage(image),
                    ),
                    Container(
                      color: Colors.black
                          .withOpacity(0.3), // Darken the background
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                children: [
                  // Container(
                  //   margin: EdgeInsetsDirectional.only(start: 20.w),
                  //   // padding: EdgeInsets.symmetric(vertical: 5.h),
                  //   decoration: BoxDecoration(
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.black.withOpacity(0.5),
                  //           spreadRadius: 0.03,
                  //           blurRadius: 6,
                  //         ),
                  //       ]
                  //   ),
                  //   child: InkWell(
                  //     onTap: () async {},
                  //     child: Icon(
                  //       isFavorite ?? false
                  //           ? Icons.favorite
                  //           : Icons.favorite_border,
                  //       // Icons.favorite,
                  //       color: AppColors.SECONDARY_COLOR,
                  //       size: 38.h,
                  //     ),
                  //   ),
                  // ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 0.03,
                            blurRadius: 6,
                          ),
                        ]
                    ),
                    child: Label(
                      // text: service.title(),
                      text: title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:  45.sp),
                    ),
                  ),
                  const Spacer(),
                  Container()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
