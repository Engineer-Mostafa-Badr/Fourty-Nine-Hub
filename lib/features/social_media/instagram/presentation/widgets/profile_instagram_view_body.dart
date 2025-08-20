import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../domain/entities/profile_instagram_data_entity.dart';
import '../cubit/profile_instagram_cubit/profile_instagram_cubit.dart';
import 'birthday_section.dart';
import 'buttons_profile_instagram_section.dart';
import 'discover_people_profile_instagram_list_view_item.dart';
import 'header_profile_instagram.dart';
import 'post_instagram_widget.dart';
import 'subtitle_and_name_under_header_instagram.dart';
import 'top_navigation_bar_profile_instagram.dart';
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../../helpers/media_helper.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import 'follow_button_instagram.dart';
import '../../../../../helpers/manage_vibration.dart';

class ProfileInstagramViewBody extends StatefulWidget {
  const ProfileInstagramViewBody({super.key});

  @override
  State<ProfileInstagramViewBody> createState() =>
      _ProfileInstagramViewBodyState();
}

class _ProfileInstagramViewBodyState extends State<ProfileInstagramViewBody>
    with TickerProviderStateMixin {
  late TabController tabController;
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingIcon = false;
  // int _currentIndex = 0;

  // final List<Widget> _tabs = [
  //   const Placeholder(),
  //   const Placeholder(),
  //   const Placeholder(),
  // ];
  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 3,
      vsync: this,
    );
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }
  void _handleScroll() {
    // Calculate when header is fully hidden (400 - 56 = 344)
    const double headerHideThreshold = 400;
    final bool isHeaderHidden = _scrollController.offset >= headerHideThreshold;

    if (isHeaderHidden != _showFloatingIcon) {
      setState(() {
        print('isHeaderHidden $isHeaderHidden');
        _showFloatingIcon = isHeaderHidden;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      controller: _scrollController,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          BlocBuilder<ProfileInstagramCubit, ProfileInstagramState>(
            builder: (context, state) {
    return SliverAppBar(
            pinned: true,
            title: Row(
              children: [
                Label(
                  text:
                  '${state.profileData!.firstName} ${state.profileData!.lastName}',
                  style: Styles.headerText(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Spacer(),
                if (_showFloatingIcon)
                  FollowButtonInstagram(
                    isReel: false,
                    isFollow: false,
                    onPressed: () {

      ManageVibration.vibrate();
                    },
                  ),
              ],
            ),
            leading: IconButton(
              onPressed: () {
      ManageVibration.vibrate();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
            ),
          );
  },
),
          SliverAppBar(
            expandedHeight: 400,
            pinned: false,
            leading: SizedBox(),
            flexibleSpace: FlexibleSpaceBar(
              background: _instagramProfileHeader(),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            // floating: true,
            delegate: _SliverAppBarDelegate(
              child: TopNavigationBarProfileInstagarm(
                tabController: tabController,
                onTap: (index) {
                  setState(() {
                    tabController.index = index;
                  });
                },
              ),
            ),
          ),
        ];
      },
      body: TabBarView(
        controller: tabController,
        children: [
          _buildPostsTab(),
          _buildReelsTab(),
          _buildTaggedTab(),
          /*// if (tabController.index == 0)
            BlocBuilder<ProfileInstagramCubit, ProfileInstagramState>(
              builder: (context, state) {
                final List<InstagramProfilePostEntity> myPosts =
                    state.profileData!.postsEntity;
                if (myPosts.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: Label(
                      text: LocaleKeys.youDontHavePosts.localize,
                      style: Styles.headerText(),
                    ),
                  );
                }
                return SliverGrid.builder(
                  itemCount: myPosts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0,
                    childAspectRatio: 125 / 158,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
      ManageVibration.vibrate();
                        context.pushNamed(
                          Routes.SINGLEPOSTINSTAGRAM,
                          extra: myPosts[index],
                        );
                      },
                      child: (MediaHelper.getMediaTypeFromExtension(
                                  myPosts[index].mediaUrls.first)) ==
                              MediaType.image
                          ? ImageFromInternet(
                              image: myPosts[index].mediaUrls[0],
                              fit: BoxFit.cover,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black.withValues(alpha: 0.5),
                              ),
                              child: VideoPlayer(
                                VideoPlayerController.networkUrl(
                                  Uri.parse(myPosts[index].mediaUrls[0]),
                                ),
                              ),
                            ),
                    );
                  },
                );
              },
            ),
          // if (tabController.index == 1)
            BlocBuilder<ProfileInstagramCubit, ProfileInstagramState>(
              builder: (context, state) {
                if (state.reelsData!.reels.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: Label(
                      text: LocaleKeys.youDontHaveReels.localize,
                      style: Styles.headerText(),
                    ),
                  );
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2.0,
                    mainAxisSpacing: 2.0,
                    childAspectRatio: 125 / 158,
                  ),
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        const ImageFromInternet(
                          image: testImage,
                          fit: BoxFit.fill,
                        ),
                        PositionedDirectional(
                          start: 8,
                          bottom: 8,
                          child: Row(
                            children: [
                              Label(
                                text: '2,567',
                                style: Styles.mediumText(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(
                                width: 2,
                              ),
                              const Icon(
                                Icons.visibility_rounded,
                                color: Colors.white,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          // if (tabController.index == 2)
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2.0,
                mainAxisSpacing: 2.0,
                childAspectRatio: 125 / 158,
              ),
              itemBuilder: (context, index) {
                return const ImageFromInternet(
                  image: testImage,
                  fit: BoxFit.fill,
                );
              },
            ),*/
        ],
      ),
    );
  }

  _instagramProfileHeader() {
    return Column(
      children: [
        HeaderProfileInstagram(),
        SizedBox(
          height: 12,
        ),
        SubTitleAndNameUnderHeaderInstagram(),
        SizedBox(
          height: 17,
        ),
        ButtonsProfileInstagramSection(),
        BlocBuilder<ProfileInstagramCubit, ProfileInstagramState>(
          builder: (context, state) {
            return state.suggestFollowsData!.suggestions.isEmpty
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Label(
                          text: LocaleKeys.discoverPeople.localize,
                          style: Styles.mediumText(),
                        ),
                        InkWell(
                          onTap: () {

      ManageVibration.vibrate();
                          },
                          child: Label(
                            text: LocaleKeys.seeAll.localize,
                            style: Styles.mediumText(
                              color: context.isDarkMode
                                  ? const Color(0xffFF4622)
                                  : const Color(0xFFFF3308),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ),
        BlocBuilder<ProfileInstagramCubit, ProfileInstagramState>(
          builder: (context, state) {
            return SizedBox(
              height: state.suggestFollowsData!.suggestions.isEmpty
                  ? 0
                  : MediaQuery.of(context).size.height * 0.23,
              child: ListView.separated(
                itemCount: state.suggestFollowsData!.suggestions.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsetsDirectional.only(
                      start: index == 0 ? 10 : 0,
                      end: index == 10 ? 10 : 0,
                    ),
                    child: DiscoverPeopleProfileInstagramListViewItem(
                      suggest: state.suggestFollowsData!.suggestions[index],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  width: 16,
                ),
              ),
            );
          },
        ),
        SizedBox(
          height: 38,
        ),
        BirthdaySection(),
        SizedBox(
          height: 34,
        ),
      ],
    );
  }

  _buildPostsTab() {
    return BlocBuilder<ProfileInstagramCubit, ProfileInstagramState>(
      builder: (context, state) {
        final List<InstagramProfilePostEntity> myPosts =
            state.profileData!.postsEntity;
        if (myPosts.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            child: Label(
              text: LocaleKeys.youDontHavePosts.localize,
              style: Styles.headerText(),
            ),
          );
        }
        return GridView.builder(
          itemCount: myPosts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0,
            childAspectRatio: 125 / 158,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
      ManageVibration.vibrate();
                context.pushNamed(
                  Routes.SINGLEPOSTINSTAGRAM,
                  extra: myPosts[index].id,
                );
              },
              child: (MediaHelper.getMediaTypeFromExtension(
                  myPosts[index].mediaUrls.first)) ==
                  MediaType.image
                  ? ImageFromInternet(
                image: myPosts[index].mediaUrls[0],
                fit: BoxFit.cover,
              )
                  : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withValues(alpha: 0.5),
                ),
                child: VideoPlayer(
                  VideoPlayerController.networkUrl(
                    Uri.parse(myPosts[index].mediaUrls[0]),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  _buildReelsTab() {
    return BlocBuilder<ProfileInstagramCubit, ProfileInstagramState>(
      builder: (context, state) {
        if (state.reelsData!.reels.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(24),
            alignment: Alignment.center,
            child: Label(
              text: LocaleKeys.youDontHaveReels.localize,
              style: Styles.headerText(),
            ),
          );
        }
        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 2.0,
            childAspectRatio: 125 / 158,
          ),
          itemBuilder: (context, index) {
            return Stack(
              children: [
                const ImageFromInternet(
                  image: testImage,
                  fit: BoxFit.fill,
                ),
                PositionedDirectional(
                  start: 8,
                  bottom: 8,
                  child: Row(
                    children: [
                      Label(
                        text: '2,567',
                        style: Styles.mediumText(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      const Icon(
                        Icons.visibility_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  _buildTaggedTab() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
        childAspectRatio: 125 / 158,
      ),
      itemBuilder: (context, index) {
        return const ImageFromInternet(
          image: testImage,
          fit: BoxFit.fill,
        );
      },
    );
  }

}
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverAppBarDelegate({required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return child != oldDelegate.child;
  }
}