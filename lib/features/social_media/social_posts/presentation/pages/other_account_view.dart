import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';
import 'package:fourtyninehub/features/authentication/domain/entities/user_entity.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/account/user_tweets.dart';
import '../../../../../common/widgets/dynamic/bottom_navigator.dart';
import '../../../../../common/widgets/dynamic/drawer.dart';
import '../../../../../common/widgets/dynamic/floating_button.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/appbar/nested_appbar.dart';
import '../../../../../common/widgets/stateless/buttons/app_button.dart';

import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/style/const.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import '../../../../../res/style/app_colors.dart';
import '../widgets/account/media_section.dart';
import '../widgets/account/posts_section.dart';

class OtherAccountView extends StatelessWidget {
  const OtherAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        // backgroundColor: Colors.,
        // appBar: const HomeAppbar(),
        drawer: const DrawerWidget(),
        bottomNavigationBar: const BottomNavigator(
          mainCategory: 0,
          index: 2,
        ),
        floatingActionButton: const FloatingButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: NestedAppbar(
          appBars: [
            SliverAppBar(
              floating: true,
              expandedHeight: kToolbarHeight * 5,
              automaticallyImplyLeading: false,
              flexibleSpace: _buildAccountCounter(context: context),
              iconTheme: const IconThemeData(color: Colors.white),
              leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.arrow_back)),
              actions: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                PopupMenuButton(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text("Media, links, and docs"),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text("Search"),
                      ),
                      PopupMenuItem<int>(
                        value: 2,
                        child: Text("Mute notifications"),
                      ),
                      PopupMenuItem<int>(
                        value: 3,
                        child: Text("Delete Chat"),
                      ),
                      PopupMenuItem<int>(
                        value: 4,
                        child: Text("Report"),
                      ),
                      PopupMenuItem<int>(
                        value: 5,
                        child: Text("Block"),
                      ),
                    ];
                  },
                ),
              ],
            ),
            SliverAppBar(
              automaticallyImplyLeading: false,
              floating: false,
              pinned: true,
              title: TabBar(
                  labelStyle: Styles.mediumText(),
                  isScrollable: true,
                  tabs: const [
                    Tab(
                      text: 'Posts',
                    ),
                    Tab(
                      text: 'Tweets',
                    ),
                    Tab(
                      text: 'Reels',
                    ),
                    Tab(
                      text: 'Media',
                    ),
                  ]),
            ),
          ],
          body: _buildAccountPages(),
        ),
      ),
    );
  }

  Widget _buildAccountCounter({
    required BuildContext context,
  }) {
    final user = context.read<UserCubit>().state.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Stack(
          children: [
            Positioned.fill(
                child: Column(
              children: [
                Expanded(
                    flex: 3,
                    child: Image.network(
                      UIConst.socialImagePlaceHolder,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      PopupMenuButton(
                          icon: Container(
                            width: kToolbarHeight * 1.5,
                            height: kToolbarHeight * .7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.SECONDARY_COLOR,
                            ),
                            child: Center(
                                child: Label(
                              text: 'Chat',
                              style: Styles.mediumText(color: Colors.white),
                            )),
                          ),
                          itemBuilder: (context) {
                            return const [
                              PopupMenuItem<int>(
                                value: 0,
                                child: Text("Normal"),
                              ),
                              PopupMenuItem<int>(
                                value: 1,
                                child: Text("Anonymous"),
                              ),
                            ];
                          },
                          onSelected: (value) {
                            context.push(Routes.CHAT);
                          }),
                      const Sizer(),
                      AppButton(
                          height: kToolbarHeight * .5,
                          width: kToolbarHeight * 1.5,
                          label: 'Follow',
                          onPressed: () {})
                    ],
                  ),
                )),
              ],
            )),
            Positioned(
                bottom: 20,
                left: 10,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.SECONDARY_COLOR,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(user!.profilePicture??''),
                  ),
                ))
          ],
        )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Label(
                      text: "${user.firstName} ${user.lastName}",
                      style: Styles.headerText(fontWeight: FontWeight.w600)),
                  const Sizer(
                    width: 5,
                  ),
                  const Icon(
                    Icons.verified,
                    size: 20,
                    color: AppColors.SECONDARY_COLOR,
                  )
                ],
              ),
              Label(
                  text: '@${user.email?.split('@')[0]}',
                  style: Styles.mediumText(color: Colors.grey)),
              const Sizer(),
              Row(
                children: [
                  _buildCounter(
                    value: '${user.friendsCount} ',
                    label: 'Friends',
                  ),
                  const Sizer(),
                  _buildCounter(
                    value: '${user.followersCount} ',
                    label: 'Follower',
                  ),
                  const Sizer(),
                  _buildCounter(
                    value: '${user.followingCount} ',
                    label: 'Following',
                  ),
                ],
              ),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(UIConst.profilePlaceHolder),
                  ),
                  const CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(UIConst.profilePlaceHolder),
                  ),
                  const CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(UIConst.profilePlaceHolder),
                  ),
                  Label(text: 'Shared followers', style: Styles.smallText())
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCounter({required String value, required String label}) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: value,
          style: Styles.mediumText(
              color: Colors.black, fontWeight: FontWeight.w500)),
      TextSpan(
          text: label,
          style: Styles.mediumText(
            color: Colors.grey,
          )),
    ]));
  }

  Widget _buildAccountPages() {
    return TabBarView(children: [
      const PostsSection(),
      BlocBuilder<UserCubit, BasicState<UserEntity>>(
          builder: (context, state) {
            UserEntity? userData = state.data;
            return context.read<UserCubit>().isLoggedIn
                ? UserTweets(userData: userData!)
                : Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () => context.push(Routes.LOGIN),
                        child: Label(
                            text: 'Login',
                            style: Styles.headerText(color: Colors.blue))),
                    Label(
                        text: ', To continue in using chat services',
                        style: Styles.headerText()),
                  ],
                ));
          }),

      // const HighLightsSection(),

      Center(
        child: Label(text: 'Not Designed yet!', style: Styles.mediumText()),
      ),
      const MediaSection(),
    ]);
  }
}
