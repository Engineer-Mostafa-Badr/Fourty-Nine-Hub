import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/pages/instgram_view.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_facebook_body.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_global_facebook_body.dart';
import 'package:fourtyninehub/features/social_media/stories/presentation/cubit/stories_cubit.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/pages/twitter_view.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../../common/widgets/dynamic/drawer.dart';
import '../../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../widgets/posts/create_post_banner.dart';

class SocialParams {
  final String userId;
  final bool? hideAppBar;
  final int? index;

  SocialParams({
    required this.userId,
    this.hideAppBar = false,
    this.index = 0,
  });
}

class SocialHomeView extends StatefulWidget {
  SocialParams? params;

  SocialHomeView({super.key, payload}) {
    if (payload is SocialParams) {
      params = payload;
    } else {
      params =
          SocialParams(userId: '', index: payload['index'], hideAppBar: false);
    }
  }

  @override
  State<SocialHomeView> createState() => _SocialHomeViewState();
}

class _SocialHomeViewState extends State<SocialHomeView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ScrollController scrollController = ScrollController();
  bool _showButtons = true;
  bool _isScrollingDown = false;
  bool isShowExplain = false;

  // TabController? controller = TabController(length: length, vsync: vsync)
  @override
  void initState() {
    scrollController;
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!_isScrollingDown) {
          setState(() {
            _isScrollingDown = true;
            _showButtons = false;
          });
        }
      } else {
        if (_isScrollingDown) {
          setState(() {
            _isScrollingDown = false;
            _showButtons = true;
          });
        }
      }});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: widget.params?.hideAppBar == false
          ? const PreferredSize(
              preferredSize: Size.fromHeight(30),
              child: HomeAppbar(isWithBackArrow: true),
            )
          : null,
      body: Column(
        children: [
          if (isShowExplain)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () {
                  context.push(Routes.GIFT);
                },
                child: Label(
                  text: LocaleKeys.socialExplain.localize,
                  style: Styles.headerText(
                    color: AppColors.getRedColor(context),
                    shadows: const [
                      Shadow(
                        color: Colors.black12,
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                      Shadow(
                        color: Colors.black12,
                        offset: Offset(0, 4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                ),
              ),
            ),
          Expanded(
            child: DefaultTabController(
              length: 3,
              initialIndex: widget.params?.index ?? 0,
              child: Scaffold(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  appBar: widget.params?.hideAppBar == true
                      ? null
                      : TabBar(
                          padding: EdgeInsets.zero,
                          labelStyle: const TextStyle(fontSize: 17),
                          unselectedLabelColor: Colors.grey,
                          dividerColor: Colors.transparent,
                          indicatorColor: context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR,
                          labelColor: context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR,
                          tabs: [
                            Tab(
                              height: 78,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset(
                                          context.isDarkMode
                                              ? Assets.facebookAppBarIconDark
                                              : Assets.facebookAppBarIcon,
                                          height: 35,
                                          width: 35,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isShowExplain = !isShowExplain;
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            Assets.idea,
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Label(
                                    text:context.isArabic?'فيس بوك': LocaleKeys.Face.localize,
                                    style: Styles.headerText(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      height: 1.83,
                                    ),
                                  ),
                                ],
                              ),
                              // icon: Stack(
                              //   children: [
                              //     Padding(
                              //       padding: const EdgeInsets.all(8.0),
                              //       child: SvgPicture.asset(
                              //         Assets.facebookAppBarIcon,
                              //         height: 35,
                              //         width: 35,
                              //       ),
                              //     ),
                              //     Positioned(
                              //       top: 0,
                              //       right: 0,
                              //       child: InkWell(
                              //         onTap: () {
                              //           setState(() {
                              //             isShowExplain = !isShowExplain;
                              //           });
                              //         },
                              //         child: SvgPicture.asset(
                              //           Assets.idea,
                              //           height: 20,
                              //           width: 20,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // height: 78,
                              // text: LocaleKeys.Face.localize,
                            ),
                            Tab(
                              // icon: Stack(
                              //   children: [
                              //     Padding(
                              //       padding: const EdgeInsets.all(8.0),
                              //       child: SvgPicture.asset(
                              //         Assets.instagramAppBarIcon,
                              //         height: 35,
                              //         width: 35,
                              //       ),
                              //     ),
                              //     Positioned(
                              //       top: 0,
                              //       right: 0,
                              //       child: InkWell(
                              //         onTap: () {
                              //           setState(() {
                              //             isShowExplain = !isShowExplain;
                              //           });
                              //         },
                              //         child: SvgPicture.asset(
                              //           Assets.idea,
                              //           height: 20,
                              //           width: 20,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),

                              height: 78,
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset(
                                          context.isDarkMode
                                              ? Assets.instagramAppBarIconDark
                                              : Assets.instagramAppBarIcon,
                                          height: 35,
                                          width: 35,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isShowExplain = !isShowExplain;
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            Assets.idea,
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Label(
                                    text: LocaleKeys.Insta.localize,
                                    style: Styles.headerText(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      height: 1.83,
                                    ),
                                  ),
                                ],
                              ),
                              // text: LocaleKeys.Insta.localize,
                            ),
                            Tab(
                              height: 78,
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset(
                                          context.isDarkMode
                                              ? Assets.twitterAppBarIconDark
                                              : Assets.twitterAppBarIcon,
                                          height: 35,
                                          width: 35,
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isShowExplain = !isShowExplain;
                                            });
                                          },
                                          child: SvgPicture.asset(
                                            Assets.idea,
                                            height: 20,
                                            width: 20,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Label(
                                    text: LocaleKeys.tweet.localize,
                                    style: Styles.headerText(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700,
                                      height: 1.83,
                                    ),
                                  ),
                                ],
                              ),
                              // icon: Stack(
                              //   children: [
                              //     Padding(
                              //       padding: const EdgeInsets.all(8.0),
                              //       child: SvgPicture.asset(
                              //         Assets.twitterAppBarIcon,
                              //         height: 35,
                              //         width: 35,
                              //       ),
                              //     ),
                              //     Positioned(
                              //       top: 0,
                              //       right: 0,
                              //       child: InkWell(
                              //         onTap: () {
                              //           setState(() {
                              //             isShowExplain = !isShowExplain;
                              //           });
                              //         },
                              //         child: SvgPicture.asset(
                              //           Assets.idea,
                              //           height: 20,
                              //           width: 20,
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // text: LocaleKeys.tweet.localize,
                            ),
                          ],
                        ),
                  drawer: widget.params?.hideAppBar == true
                      ? null
                      : const DrawerWidget(),
                  bottomNavigationBar: widget.params?.hideAppBar == true
                      ? null
                      : BottomNavigator(
                          scrollController: scrollController,
                          isScrollingDown: _isScrollingDown,
                          mainCategory: 2,
                          index: 2,
                        ),
                  floatingActionButton:
                      _isScrollingDown || widget.params?.hideAppBar == true
                          ? null
                          : const FloatingButton(
                              changeView: 2,
                            ),
                  floatingActionButtonLocation:
                      _isScrollingDown || widget.params?.hideAppBar == true
                          ? null
                          : FloatingActionButtonLocation.centerDocked,
                  body: TabBarView(
                    children: [
                      BlocBuilder<UserCubit, BasicState<UserEntity>>(
                          builder: (context, state) {
                        return context.read<UserCubit>().isLoggedIn
                            ? Scaffold(
                                body: NotificationListener<ScrollNotification>(
                                  onNotification: (scrollNotification) {
                                    if (scrollNotification is UserScrollNotification) {
                                      if (scrollNotification.direction == ScrollDirection.reverse && _showButtons) {
                                        setState(() {
                                          _showButtons = false;
                                        });
                                      } else if (scrollNotification.direction == ScrollDirection.forward && !_showButtons) {
                                        setState(() {
                                          _showButtons = true;
                                        });
                                      }
                                    }
                                    return false;
                                  },
                                  child: FacebookBody(
                                  scrollController: scrollController,
                                                                ),
                                ))
                            : NestedAppbar(
                                scrollController: ScrollController(),
                                appBars: [
                                  SliverAppBar(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    automaticallyImplyLeading: false,
                                    floating: true,
                                    pinned: true,
                                    flexibleSpace: const CreatePostBanner(),
                                  ),
                                  SliverAppBar(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    automaticallyImplyLeading: false,
                                    // floating: true,
                                    pinned: true,
                                    flexibleSpace: _buildTabBar(),
                                  )
                                ],
                                body: FacebookGlobalBody(
                                  scrollController: scrollController,
                                ));
                      }),
                      MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) =>
                                serviceLocator<InstagramCubit>()..loadData(),
                          ),
                          BlocProvider(
                            create: (context) => serviceLocator<StoryCubit>(),
                          ),
                        ],
                        child: NotificationListener<ScrollNotification>(
                            onNotification: (scrollNotification) {
                              if (scrollNotification is UserScrollNotification) {
                                if (scrollNotification.direction == ScrollDirection.reverse && _showButtons) {
                                  setState(() {
                                    _showButtons = false;
                                  });
                                } else if (scrollNotification.direction == ScrollDirection.forward && !_showButtons) {
                                  setState(() {
                                    _showButtons = true;
                                  });
                                }
                              }
                              return false;
                            },child: const InstagramView()),
                      ),
                      NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {
                            if (scrollNotification is UserScrollNotification) {
                              if (scrollNotification.direction == ScrollDirection.reverse && _showButtons) {
                                setState(() {
                                  _showButtons = false;
                                });
                              } else if (scrollNotification.direction == ScrollDirection.forward && !_showButtons) {
                                setState(() {
                                  _showButtons = true;
                                });
                              }
                            }
                            return false;
                          },child: const TwitterView()),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    final user = context.read<UserCubit>().state.data;
    return Container(
        padding: EdgeInsets.all(10.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            2,
            (i) => GestureDetector(
              onTap: () {
                if (i == 1) {
                  context.read<UserCubit>().isLoggedIn
                      ? context.push(Routes.OTHERSACCOUNT, extra: user?.id)
                      : pleaseLoginDialog(context);
                  // context.push(Routes.LOGIN);
                }
              },
              child: Container(
                  decoration: i == 0
                      ? BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 2)))
                      : null,
                  child: Row(
                    children: [
                      Icon(
                        i == 0 ? Icons.home : Icons.person,
                        color: i == 0
                            ? Theme.of(context).primaryColor
                            : Colors.grey,
                        size: 40.w,
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      Label(
                        text: i == 0
                            ? LocaleKeys.home.localize
                            : LocaleKeys.profile.localize,
                        style: Styles.headerText(
                            color: i == 0
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                            fontSize: 30),
                      )
                    ],
                  )),
            ),
          ),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
