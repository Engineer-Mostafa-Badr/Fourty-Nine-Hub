import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_facebook_body.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_global_facebook_body.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../../common/widgets/dynamic/drawer.dart';
import '../../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../../common/widgets/stateless/appbar/home_appbar.dart';
import '../../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../widgets/posts/create_post_banner.dart';

class SocialHomeView extends StatefulWidget {
  final String userId;
  const SocialHomeView({super.key, required this.userId});

  @override
  State<SocialHomeView> createState() => _SocialHomeViewState();
}

class _SocialHomeViewState extends State<SocialHomeView>
    with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  bool _isScrollingDown = false;

  @override
  void initState() {
    scrollController;
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!_isScrollingDown) {
          setState(() {
            _isScrollingDown = true;
          });
        }
      } else {
        if (_isScrollingDown) {
          setState(() {
            _isScrollingDown = false;
          });
        }
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: const HomeAppbar(
            isWithBackArrow: true,
          ),
          drawer: const DrawerWidget(),
          bottomNavigationBar: BottomNavigator(
            scrollController: scrollController,
            isScrollingDown: _isScrollingDown,
            mainCategory: 2,
            index: 2,
          ),
          floatingActionButton: _isScrollingDown
              ? null
              : const FloatingButton(
                  changeView: 2,
                ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: BlocBuilder<UserCubit, BasicState<UserEntity>>(
              builder: (context, state) {
            return context.read<UserCubit>().isLoggedIn
                ? NestedAppbar(
                    scrollController: ScrollController(),
                    appBars: [
                      SliverAppBar(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        automaticallyImplyLeading: false,
                        floating: true,
                        // pinned: true,
                        flexibleSpace: const CreatePostBanner(),
                      ),
                      SliverAppBar(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        automaticallyImplyLeading: false,
                        // floating: true,
                        pinned: true,
                        flexibleSpace: _buildTabBar(),
                      )
                    ],
                    body: FacebookBody(
                      scrollController: scrollController,
                    ))
                : NestedAppbar(
                scrollController: ScrollController(),
                appBars: [
                  SliverAppBar(
                    backgroundColor:
                    Theme.of(context).scaffoldBackgroundColor,
                    automaticallyImplyLeading: false,
                    floating: true,
                    // pinned: true,
                    flexibleSpace: const CreatePostBanner(),
                  ),
                  SliverAppBar(
                    backgroundColor:
                    Theme.of(context).scaffoldBackgroundColor,
                    automaticallyImplyLeading: false,
                    // floating: true,
                    pinned: true,
                    flexibleSpace: _buildTabBar(),
                  )
                ],
                body: FacebookGlobalBody(
                  scrollController: scrollController,
                ));
          })),
    );
  }

  Widget _buildTabBar() {
    final user = context.read<UserCubit>().state.data;
    return Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            2,
            (i) => GestureDetector(
              onTap: () {
                if (i == 1) {
                  context.read<UserCubit>().isLoggedIn?context.push(Routes.OTHERSACCOUNT, extra: user?.id):context.push(Routes.LOGIN);
                }
              },
              child: Container(
                  decoration: i == 0
                      ? const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: AppColors.PRIMARY_COLOR, width: 2)))
                      : null,
                  child: Icon(
                    i == 0 ? Icons.home : Icons.person,
                    color:
                        i == 0 ? AppColors.PRIMARY_COLOR : Colors.grey,
                  )),
            ),
          ),
        ));
  }
}
