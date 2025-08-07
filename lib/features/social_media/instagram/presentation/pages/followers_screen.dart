import 'package:flutter/material.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/style/styles.dart';
import '../../domain/entities/profile_instagram_data_entity.dart';
import 'instagram_block_list_body.dart';
import 'instagram_followers_body.dart';
import 'instagram_friends_body.dart';
import '../../../../../helpers/manage_vibration.dart';

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
      ManageVibration.vibrate();
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
                  '${widget.args.dataProfile.followingCount} ${LocaleKeys.blocked.localize}',
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