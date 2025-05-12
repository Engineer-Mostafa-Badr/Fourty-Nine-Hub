import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/post_instagram_widget.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../domain/entities/profile_instagram_data_entity.dart';
import '../widgets/instagram_friends_categorise_widget.dart';
import '../widgets/instagram_user_follow_widget.dart';
import 'instagram_block_list_body.dart';
import 'instagram_followers_body.dart';
import 'instagram_friends_body.dart';

class FollowersScreenArguments {
  final int index;
  final ProfileInstagramDataEntity dataProfile;

  FollowersScreenArguments({
    required this.index,
    required this.dataProfile,
  });
}

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({super.key, required this.args});

  final FollowersScreenArguments args;

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Add a listener to load data when the tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _onTabChanged(_tabController.index);
      }
    });

    // Initially load data for the first tab (Friends)
    _onTabChanged(widget.args.index);
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the TabController
    super.dispose();
  }

  // Handle tab change and data loading
  void _onTabChanged(int index) {
    // final listsCubit = context.read<ListsCubit>();
    //
    // // Always reload the data for the current active tab
    // if (index == 0) {
    //   listsCubit.loadFriends(searchText); // Reload Friends tab
    // } else if (index == 1) {
    //   listsCubit.loadFollowers(searchText); // Reload Followers tab
    // } else if (index == 2) {
    //   listsCubit.loadRequests(searchText); // Reload Requests tab
    // } else if (index == 3) {
    //   listsCubit.loadBlocked(searchText); // Reload Blocked tab
    // }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: Label(
          text: LocaleKeys.followers.localize,
          style: Styles.headerText(),
        ),
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.arrow_back)),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabAlignment: TabAlignment.center,
          tabs: [
            Tab(
              text:
                  '${widget.args.dataProfile.friendsCount} ${LocaleKeys.friends.localize}',
            ),
            Tab(
              text:
                  '${widget.args.dataProfile.followersCount} ${LocaleKeys.followers.localize}',
            ),
            Tab(
              text:
                  '${widget.args.dataProfile.followingCount} ${LocaleKeys.following.localize}',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          InstagramFriendsBody(),
          InstagramFollowersBody(),
          InstagramBlockListBody(),
        ],
      ),
    );
  }
}
