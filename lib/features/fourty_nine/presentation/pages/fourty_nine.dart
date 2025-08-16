import 'dart:developer';

import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
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
import 'package:fourtyninehub/features/fourty_nine/presentation/widgets/animated_card.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/widgets/animated_text.dart';
import 'package:fourtyninehub/features/notifications/presentation/cubits/firebase_notfications_cubit/firebase_notfications_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
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
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // context.pushNamed(Routes.REELS);
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
        bottomNavigationBar: _isScrollingDown
            ? null
            : BottomNavigator(
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
        // drawer: const DrawerWidget(),
        body: ListView(
          controller: scrollController,
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          children: [
            const AddBanner(),
            const AnnounceWidget(),
            Sizer(
              height: 5.h,
            ),
            !context.read<UserCubit>().isLoggedIn
                ? Sizer(
                    height: 5.h,
                  )
                : const SizedBox.shrink(),
            context.read<UserCubit>().isLoggedIn
                ? ScrollableTextWithAnimation(
                    textDirection: context.isArabic
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                  )
                : const SizedBox.shrink(),

            //wallet

            context.read<UserCubit>().isLoggedIn
                ? const WalletWidget()
                : const SizedBox.shrink(),
            ClickableWidget(
              onTap: () {
                ManageVibration.vibrate();
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
                height: 40.h,
                alignment: Alignment.center,
                child: AutoScrollText(
                  velocity: const Velocity(pixelsPerSecond: Offset(30, 0)),
                  "${LocaleKeys.choosePreferredAppStyle.localize}..  ${LocaleKeys.clickHere.localize}!!                                         ",
                  style: Styles.headerText(
                      fontSize: 30,
                      color: context.isDarkMode
                          ? Colors.white
                          : AppColors.SECONDARY_COLOR),
                  textDirection:
                      context.isArabic ? TextDirection.rtl : TextDirection.ltr,
                  selectable: true,
                  // textStyle: TextStyle(fontSize: 24),
                ),
              ),
            ),
            Sizer(
              height: 5.h,
            ),
            GridBlocksWidget(),
            Sizer(
              height: 10.h,
            ),
            //cats layout
            BlocBuilder<MainCategoriesCubit, MainCategoriesState>(
              builder: (context, state) {
                var data = state.data;
                return _buildMainCategoriesViews(data);
              },
            ),
            Sizer(
              height: 10.h,
            ),
            //main cats
            BlocBuilder<MainCategoriesCubit, MainCategoriesState>(
              builder: (context, state) {
                final controller = context.read<MainCategoriesCubit>();
                if (state.status == StateStatus.loading) {
                  return Column(
                    children: List.generate(
                      5,
                      (index) => Shimmer.fromColors(
                        baseColor: Colors.grey[100]!,
                        highlightColor: Colors.white24,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 2),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.AUTH_CONTAINER_COLOR,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                if (state.data != null) {
                  List<Widget> items = List.generate(
                    state.data?.length ?? 0,
                    (index) => InkWell(
                      onTap: () {
                        ManageVibration.vibrate();
                        AdInterstitialTop.loadIntersitialAd();
                        AdInterstitialTop.showInterstitialAd();
                        HandleCashback.setCount('mainCategoriesCount', context);
                        if (state.data![index].id ==
                            '62c8b5b09332225799fe335e') {
                          context.pushNamed(Routes.MARRIAGESUBCATEGORIES,
                              extra: state.data![index]);
                        } else {
                          context.pushNamed(Routes.SUBCATEGORIES,
                              extra: state.data![index]);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 2),
                        child: HomeMainCategoryBanner(
                          category: state.data![index],
                          // imageHeight: MediaQuery.sizeOf(context).height * 0.10,
                          onFavorite: () async {
                            ManageVibration.vibrate();
                            var result =
                                await controller.toggleFavoriteMedicalService(
                                    state.data![index].id);
                            print("result$result");
                            return result;
                          },
                        ),
                      ),
                    ),
                  );
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * (0.5),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: MediaQuery.of(context).size.height * (0.5),
                        autoPlay: true,
                        enlargeCenterPage: false,
                        enlargeStrategy: CenterPageEnlargeStrategy.scale,
                        viewportFraction: 1 / 5,
                        enableInfiniteScroll: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        scrollDirection: Axis.vertical,
                        onPageChanged: (index, reason) {
                          print(
                              'Scrolled to index $index'); // <-- Here you can detect
                          print(
                              'Scrolled to currentIndex $currentIndex'); // <-- Here you can detect scroll

                          // Trigger something when scrolling forward
                          if (index > currentIndex) {
                            print('User scrolled forward');
                            _isScrollingDown = false;
                          } else {
                            print('User scrolled backward');
                            _isScrollingDown = true;
                          }
                          setState(() => currentIndex = index);
                        },
                      ),
                      items: items.map((item) {
                        return item;
                      }).toList(),
                    ),
                  );
                  /* return Container(
                    margin: EdgeInsets.only(bottom: 40),
                    height: MediaQuery.of(context).size.height * (0.6),
                    width: double.infinity,
                    child: AnimatedCardsListView(
                      setupScrollController: (controller) {
                        controller.addListener(() {
                          if (controller.position.userScrollDirection ==
                              ScrollDirection.reverse) {
                            if (!_isScrollingDown) {
                              setState(() {
                                _isScrollingDown = true;
                              });
                            }
                          } else if (controller.position.userScrollDirection ==
                              ScrollDirection.forward) {
                            if (_isScrollingDown) {
                              setState(() {
                                _isScrollingDown = false;
                              });
                            }
                          }
                        });
                      },
                      cardsList: List.generate(
                        state.data?.length ?? 0,
                        (index) => InkWell(
                          onTap: () {
                            ManageVibration.vibrate();
                            AdInterstitialTop.loadIntersitialAd();
                            AdInterstitialTop.showInterstitialAd();
                            HandleCashback.setCount(
                                'mainCategoriesCount', context);
                            if (state.data![index].id ==
                                '62c8b5b09332225799fe335e') {
                              context.pushNamed(Routes.MARRIAGESUBCATEGORIES,
                                  extra: state.data![index]);
                            } else {
                              context.pushNamed(Routes.SUBCATEGORIES,
                                  extra: state.data![index]);
                            }
                          },
                          child: HomeMainCategoryBanner(
                            category: state.data![index],
                            imageHeight:
                                MediaQuery.sizeOf(context).height * 0.10,
                            onFavorite: () async {
                              ManageVibration.vibrate();
                              var result =
                                  await controller.toggleFavoriteMedicalService(
                                      state.data![index].id);
                              print("result$result");
                              return result;
                            },
                          ),
                        ),
                      ),
                    ),
                  );*/
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
      spacing: 4,
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
            ManageVibration.vibrate();
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
              ManageVibration.vibrate();
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
        ManageVibration.vibrate();
        onTab();
        if (routeName == Routes.MAINCATEGORIESCARDS) {
          context.pushNamed(routeName,
              extra:
                  MainCategoriesCardsParams(data: extra, isCustomPage: false));
        } else {
          context.pushNamed(routeName, extra: extra);
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
