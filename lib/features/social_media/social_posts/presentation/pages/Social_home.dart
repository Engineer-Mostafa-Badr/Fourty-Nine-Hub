import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/states/basic_state.dart';
import '../../../../authentication/domain/entities/user_entity.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../instagram/presentation/cubit/instagram_cubit.dart';
import '../../../instagram/presentation/pages/instgram_view.dart';
import '../../../twitter/presentation/twitter/presentation/pages/twitter_view.dart';
import '../widgets/facebook_widgets/build_facebook_body.dart';
import '../widgets/facebook_widgets/build_global_facebook_body.dart';
import '../../../stories/presentation/cubit/stories_cubit.dart';
import '../../../twitter/presentation/pages/twitter_view.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dialogs/please_login_dialog.dart';
import '../../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../../common/widgets/dynamic/drawer.dart';
import '../../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../widgets/posts/create_post_banner.dart';
import '../../../../../helpers/manage_vibration.dart' as manageVibration;

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
      params = SocialParams(
          userId: '',
          index: payload is Map ? payload['index'] : 0,
          hideAppBar: false);
    }
  }

  @override
  State<SocialHomeView> createState() => _SocialHomeViewState();
}

class _SocialHomeViewState extends State<SocialHomeView>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late ScrollController scrollController;
  late TabController _tabController;

  bool _showButtons = true;
  bool _isScrollingDown = false;
  bool isShowExplain = false;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    _tabController = TabController(
        length: 3, vsync: this, initialIndex: widget.params?.index ?? 0);

    // add listener to change tab and close keyboard
    _tabController.addListener(_onTabChanged);

    scrollController.addListener(_onScrollChanged);
  }

  void _onTabChanged() {
    FocusScope.of(context).unfocus();
  }

  void _onScrollChanged() {
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
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    scrollController.removeListener(_onScrollChanged);
    scrollController.dispose();
    super.dispose();
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
          if (isShowExplain) _buildExplanationBanner(),
          Expanded(
            child: DefaultTabController(
              length: 3,
              initialIndex: widget.params?.index ?? 0,
              child: Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                appBar:
                    widget.params?.hideAppBar == true ? null : _buildTabBar(),
                drawer: widget.params?.hideAppBar == true
                    ? null
                    : const DrawerWidget(),
                // bottomNavigationBar: widget.params?.hideAppBar == true
                //     ? null
                //     : BottomNavigator(
                //         scrollController: scrollController,
                //         isScrollingDown: _isScrollingDown,
                //         mainCategory: 2,
                //         index: 2,
                //       ),
                // floatingActionButton: _shouldShowFloatingButton()
                //     ? const FloatingButton(changeView: 2)
                //     : null,
                // floatingActionButtonLocation: _shouldShowFloatingButton()
                //     ? FloatingActionButtonLocation.centerDocked
                //     : null,
                body: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildFacebookTab(),
                    _buildInstagramTab(),
                    _buildTwitterTab(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationBanner() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () => context.push(Routes.GIFT),
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
            ],
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      padding: EdgeInsets.zero,
      labelStyle: const TextStyle(fontSize: 17),
      unselectedLabelColor: Colors.grey,
      dividerColor: Colors.transparent,
      indicatorColor:
          context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
      labelColor: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
      tabs: [
        _buildTab(
          icon: context.isDarkMode
              ? Assets.facebookAppBarIconDark
              : Assets.facebookAppBarIcon,
          label: context.isArabic ? 'فيس' : LocaleKeys.Face.localize,
        ),
        if (widget.params?.hideAppBar == false)
        _buildTab(
          icon: context.isDarkMode
              ? Assets.instagramAppBarIconDark
              : Assets.instagramAppBarIcon,
          label: LocaleKeys.Insta.localize,
        ),
        _buildTab(
          icon: context.isDarkMode
              ? Assets.twitterAppBarIconDark
              : Assets.twitterAppBarIcon,
          label: LocaleKeys.tweet.localize,
        ),
      ],
    );
  }

  Widget _buildTab({required String icon, required String label}) {
    return Tab(
      height: 78,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  icon,
                  height: 35,
                  width: 35,
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
      manageVibration.ManageVibration.vibrate();
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
            text: label,
            style: Styles.headerText(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.83,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacebookTab() {
    return BlocBuilder<UserCubit, BasicState<UserEntity>>(
      builder: (context, state) {
        return context.read<UserCubit>().isLoggedIn
            ? _buildLoggedInFacebookView()
            : _buildLoggedInFacebookView();
      },
    );
  }

  Widget _buildLoggedInFacebookView() {
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: FacebookBody(
          scrollController: scrollController,
        ),
      ),
    );
  }

  Widget _buildGuestFacebookView() {
    return NestedAppbar(
      scrollController: ScrollController(),
      appBars: [
        SliverAppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          floating: true,
          pinned: true,
          flexibleSpace: const CreatePostBanner(),
        ),
        SliverAppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          pinned: true,
          flexibleSpace: _buildNestedTabBar(),
        )
      ],
      body: FacebookGlobalBody(
        scrollController: scrollController,
      ),
    );
  }



  Widget _buildInstagramTab() {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<InstagramCubit>()..loadData(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<StoryCubit>(),
        ),
      ],
      child: NotificationListener<ScrollNotification>(
        onNotification: _handleScrollNotification,
        child: const InstagramView(),
      ),
    );
  }

  Widget _buildTwitterTab() {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: const Twitter11(),
    );
  }

  bool _handleScrollNotification(ScrollNotification scrollNotification) {
    if (scrollNotification is UserScrollNotification) {
      if (scrollNotification.direction == ScrollDirection.reverse &&
          _showButtons) {
        setState(() {
          _showButtons = false;
        });
      } else if (scrollNotification.direction == ScrollDirection.forward &&
          !_showButtons) {
        setState(() {
          _showButtons = true;
        });
      }
    }
    return false;
  }

  Widget _buildNestedTabBar() {
    final user = context.read<UserCubit>().state.data;
    return Container(
      padding: EdgeInsets.all(10.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(2, (i) => _buildNestedTabItem(i, user)),
      ),
    );
  }

  Widget _buildNestedTabItem(int index, UserEntity? user) {
    final isSelected = index == 0;
    return GestureDetector(
      onTap: () {
      manageVibration.ManageVibration.vibrate();
        if (index == 1) {
          context.read<UserCubit>().isLoggedIn
              ? context.push(Routes.OTHERSACCOUNT, extra: user?.id)
              : pleaseLoginDialog(context);
        }
      },
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 2,
                  ),
                ),
              )
            : null,
        child: Row(
          children: [
            Icon(
              index == 0 ? Icons.home : Icons.person,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
              size: 40.w,
            ),
            SizedBox(width: 8.w),
            Label(
              text: index == 0
                  ? LocaleKeys.home.localize
                  : LocaleKeys.profile.localize,
              style: Styles.headerText(
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.grey,
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _shouldShowFloatingButton() {
    return !_isScrollingDown && widget.params?.hideAppBar != true;
  }

  @override
  bool get wantKeepAlive => true;
}