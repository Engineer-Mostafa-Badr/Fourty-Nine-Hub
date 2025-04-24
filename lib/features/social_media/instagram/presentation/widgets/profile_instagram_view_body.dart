import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/profile_instagram_data_entity.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/profile_instagram_cubit/profile_instagram_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/birthday_section.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/buttons_profile_instagram_section.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/discover_people_profile_instagram_list_view_item.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/header_profile_instagram.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/post_instagram_widget.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/subtitle_and_name_under_header_instagram.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/top_navigation_bar_profile_instagram.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/helpers/media_helper.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class ProfileInstagramViewBody extends StatefulWidget {
  const ProfileInstagramViewBody({super.key});

  @override
  State<ProfileInstagramViewBody> createState() =>
      _ProfileInstagramViewBodyState();
}

class _ProfileInstagramViewBodyState extends State<ProfileInstagramViewBody>
    with TickerProviderStateMixin {
  late TabController tabController;
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
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: HeaderProfileInstagram(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 12,
          ),
        ),
        const SliverToBoxAdapter(
          child: SubTitleAndNameUnderHeaderInstagram(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 17,
          ),
        ),
        const SliverToBoxAdapter(
          child: ButtonsProfileInstagramSection(),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Label(
                  text: LocaleKeys.discoverPeople.localize,
                  style: Styles.mediumText(),
                ),
                Label(
                  text: LocaleKeys.seeAll.localize,
                  style: Styles.mediumText(
                    color: const Color(0xFFFF3308),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: BlocBuilder<ProfileInstagramCubit, ProfileInstagramState>(
            builder: (context, state) {
              return SizedBox(
                height: state.suggestFollowsData!.suggestions.isEmpty
                    ? 0
                    : MediaQuery.of(context).size.height * 0.2,
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
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 38,
          ),
        ),
        const SliverToBoxAdapter(
          child: BirthdaySection(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 34,
          ),
        ),
        SliverToBoxAdapter(
          child: TopNavigationBarProfileInstagarm(
              tabController: tabController,
              onTap: (index) {
                setState(() {
                  tabController.index = index;
                });
              }),
        ),
        if (tabController.index == 0)
          BlocBuilder<ProfileInstagramCubit, ProfileInstagramState>(
            builder: (context, state) {
              final List<InstagramProfilePostEntity> myPosts =
                  state.profileData!.postsEntity;
              if (myPosts.isEmpty) {
                return SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: Label(
                      text: LocaleKeys.youDontHavePosts.localize,
                      style: Styles.headerText(),
                    ),
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
        if (tabController.index == 1)
          BlocBuilder<ProfileInstagramCubit, ProfileInstagramState>(
            builder: (context, state) {
              if (state.reelsData!.reels.isEmpty) {
                return SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: Label(
                      text: LocaleKeys.youDontHaveReels.localize,
                      style: Styles.headerText(),
                    ),
                  ),
                );
              }
              return SliverGrid.builder(
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
        if (tabController.index == 2)
          SliverGrid.builder(
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
          ),
      ],
    );
  }
}
