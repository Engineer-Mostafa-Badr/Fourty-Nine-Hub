import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/drawer.dart';
import 'package:fourtyninehub/common/widgets/stateless/appbar/home_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/loading/custom_loading.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/utils/handle_cashback.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_cubit.dart';
import 'package:fourtyninehub/features/custom_page/presentation/cubit/custom_page_states.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/edit_page.dart';
import 'package:fourtyninehub/features/custom_page/presentation/page/widget/service_page_preview_copy.dart';
import 'package:fourtyninehub/features/fourty_nine/presentation/controllers/main_categories_cubit/main_categories_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/instgram_view.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../social_media/social_posts/presentation/pages/social_home.dart';
import '../../../../social_media/stories/presentation/cubit/stories_cubit.dart';
import '../../../../social_media/twitter/presentation/twitter/presentation/pages/twitter_view.dart';

class PagePreview extends StatefulWidget {
  const PagePreview({super.key, this.state, this.isButtonsVisible = false});

  final bool? state;
  final bool isButtonsVisible;

  @override
  State<PagePreview> createState() => _PagePreviewState();
}

class _PagePreviewState extends State<PagePreview>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  bool _showButtons = true;

  @override
  initState() {
    serviceLocator<MainCategoriesCubit>().loadData(context);
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showButtons) {
          setState(() {
            _showButtons = false;
          });
        }
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showButtons) {
          setState(() {
            _showButtons = true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: WillPopScope(
        onWillPop: () async {
          if (widget.state ?? false) {
            SystemNavigator.pop();
            return false;
          }
          return true;
        },
        child: CustomScaffold(
          key: _scaffoldKey,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(90),
            child: HomeAppbar(
              isWithBackArrow: false,
              toolbarHeight: kTextTabBarHeight * 4.h,
              language: true,
              isMenu: true,
              leading: IconButton(
                icon: const Icon(Icons.menu), // The menu icon
                onPressed: () {
                  ManageVibration.vibrate();
                  HandleCashback.setCount('drawerCount', context);
                  _scaffoldKey.currentState?.openDrawer();
                },
              ),
              bottom: TabBar(
                dividerColor: Colors.transparent,
                indicator: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  // Light red background
                  borderRadius: BorderRadius.circular(8), // Rounded corners
                ),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.LIGHT_GRAY_COLOR2,
                ),
                tabs: [
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        LocaleKeys.social.tr(),
                      ),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        LocaleKeys.service.tr(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          drawer: const DrawerWidget(),
          body: Stack(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is UserScrollNotification) {
                    if (scrollNotification.direction ==
                            ScrollDirection.reverse &&
                        _showButtons) {
                      setState(() {
                        _showButtons = false;
                      });
                    } else if (scrollNotification.direction ==
                            ScrollDirection.forward &&
                        !_showButtons) {
                      setState(() {
                        _showButtons = true;
                      });
                    }
                  }
                  return false;
                },
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              serviceLocator<InstagramCubit>()..loadData(),
                        ),
                        BlocProvider(
                          create: (context) => serviceLocator<StoryCubit>(),
                        ),
                        BlocProvider(
                          create: (context) => serviceLocator<CustomPageCubit>()
                            ..fetchSocialPage(),
                        ),
                        // BlocProvider(
                        //   create: (context) => ThumbnailsCubit(serviceLocator()),
                        // ),
                      ],
                      child: BlocBuilder<InstagramCubit, InstagramState>(
                        builder: (BuildContext context, state) {
                          return BlocBuilder<CustomPageCubit, CustomPageState>(
                            builder: (BuildContext context, social) {
                              if (social.status == CustomPageStates.success) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: social.social?.face == true
                                      ? SocialHomeView(
                                          payload: SocialParams(
                                            userId: social.social?.userId ?? '',
                                            hideAppBar: true,
                                          ),
                                        )
                                      : social.social?.insta == true
                                          ? const InstagramView(
                                              hideAppBar: true,
                                            )
                                          : const Twitter11(),
                                );
                              } else {
                                return const CustomLoading();
                              }
                            },
                          );
                        },
                      ),
                    ),
                    ServicePagePreview(
                      noNavBar: widget.isButtonsVisible,
                    ),
                    // Container()
                  ],
                ),
              ),
              Visibility(
                  visible: widget.isButtonsVisible,
                  child: Positioned(
                    right: 0,
                    left: 0,
                    bottom: 5,
                    child: AnimatedSlide(
                      duration: const Duration(milliseconds: 300),
                      offset: _showButtons ? Offset.zero : const Offset(0, 2),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _showButtons ? 1.0 : 0.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: CustomElevatedButton(
                                  onPressed: () async {
                                    ManageVibration.vibrate();
                                    context
                                        .read<CustomPageCubit>()
                                        .updateActivate(true);
                                    GoRouter.of(context).push(Routes.HOME);

                                    // showAnimatedDialog(
                                    //   context,
                                    //   AlertDialog(
                                    //     backgroundColor:
                                    //         AppColors.getFindFillColor(context),
                                    //     content: Column(
                                    //       mainAxisSize: MainAxisSize.min,
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.center,
                                    //       children: [
                                    //         Label(
                                    //             text: context.isArabic
                                    //                 ? LocaleKeys
                                    //                     .restartToApply.localize
                                    //                 : 'Restart to Apply',
                                    //             style: Styles.headerText(
                                    //                 fontWeight:
                                    //                     FontWeight.w400)),
                                    //         const Sizer(),
                                    //         Row(
                                    //           children: [
                                    //             Expanded(
                                    //               child: AppButton(
                                    //                 onPressed: () {
                                    //                   ManageVibration.vibrate();
                                    //                   Navigator.pop(context);
                                    //                 },
                                    //                 label: LocaleKeys
                                    //                     .cancel.localize,
                                    //                 backColor:
                                    //                     AppColors.getRedColor(
                                    //                         context),
                                    //                 color: AppColors
                                    //                     .getReversedTextColor(
                                    //                         context),
                                    //               ),
                                    //             ),
                                    //             const Sizer(
                                    //               width: 16,
                                    //             ),
                                    //             Expanded(
                                    //               child: AppButton(
                                    //                 onPressed: () {
                                    //                   ManageVibration.vibrate();
                                    //                   context
                                    //                       .read<
                                    //                           CustomPageCubit>()
                                    //                       .updateActivate(true);
                                    //                   context.go(Routes.HOME);
                                    //                 },
                                    //                 label: LocaleKeys
                                    //                     .restart.localize,
                                    //                 backColor: AppColors
                                    //                     .getButtonPrimaryColor(
                                    //                         context),
                                    //                 color: AppColors
                                    //                     .getReversedTextColor(
                                    //                         context),
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  backgoundColor:
                                      AppColors.getButtonPrimaryColor(context),
                                  child: Center(
                                    child: Text(
                                      LocaleKeys.saveAndActivate.localize,
                                      style: Styles.smallText(
                                          color: AppColors.getReversedTextColor(
                                              context)),
                                    ),
                                  ),
                                ),
                              ),
                              Sizer(
                                width: 50,
                              ),
                              Expanded(
                                child: CustomElevatedButton(
                                  onPressed: () async {
                                    ManageVibration.vibrate();
                                    context
                                        .read<CustomPageCubit>()
                                        .updateActivate(true);
                                    GoRouter.of(context).push(Routes.HOME);
                                    // showAnimatedDialog(
                                    //   context,
                                    //   AlertDialog(
                                    //     backgroundColor:
                                    //         AppColors.getFindFillColor(context),
                                    //     content: Column(
                                    //       mainAxisSize: MainAxisSize.min,
                                    //       crossAxisAlignment:
                                    //           CrossAxisAlignment.center,
                                    //       children: [
                                    //         Label(
                                    //             text: context.isArabic
                                    //                 ? LocaleKeys
                                    //                     .restartToApply.localize
                                    //                 : 'Restart to Apply',
                                    //             style: Styles.headerText(
                                    //                 fontWeight:
                                    //                     FontWeight.w400)),
                                    //         const Sizer(),
                                    //         Row(
                                    //           children: [
                                    //             Expanded(
                                    //               child: AppButton(
                                    //                 onPressed: () {
                                    //                   ManageVibration.vibrate();
                                    //                   Navigator.pop(context);
                                    //                 },
                                    //                 label: LocaleKeys
                                    //                     .cancel.localize,
                                    //                 color: AppColors
                                    //                     .getReversedTextColor(
                                    //                         context),
                                    //                 backColor:
                                    //                     AppColors.getRedColor(
                                    //                         context),
                                    //               ),
                                    //             ),
                                    //             const Sizer(
                                    //               width: 16,
                                    //             ),
                                    //             Expanded(
                                    //               child: AppButton(
                                    //                 backColor: AppColors
                                    //                     .getButtonPrimaryColor(
                                    //                         context),
                                    //                 onPressed: () {
                                    //                   ManageVibration.vibrate();
                                    //                   context
                                    //                       .read<
                                    //                           CustomPageCubit>()
                                    //                       .updateActivate(true);
                                    //                   context.go(Routes.HOME);
                                    //                 },
                                    //                 color: AppColors
                                    //                     .getReversedTextColor(
                                    //                         context),
                                    //                 label: LocaleKeys
                                    //                     .restart.localize,
                                    //               ),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  backgoundColor:
                                      AppColors.getButtonPrimaryColor(context),
                                  child: Center(
                                    child: Text(
                                      LocaleKeys.saveWithOutActivate.localize,
                                      style: Styles.smallText(
                                          color: AppColors.getReversedTextColor(
                                              context)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
