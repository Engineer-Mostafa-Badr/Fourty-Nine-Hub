import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/followers_cubit/follower_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/cubit/followers_cubit/followers_state.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/followers_view.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/following_view.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class ViewFollowersAndFollowing extends StatefulWidget {
  const ViewFollowersAndFollowing({super.key});

  @override
  State<ViewFollowersAndFollowing> createState() =>
      _ViewFollowersAndFollowingState();
}

class _ViewFollowersAndFollowingState extends State<ViewFollowersAndFollowing>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.data;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: BackAppBar(label: user!.email!.split('@')[0]),
        body: BlocProvider<FollowCubit>(
          create: (BuildContext context) => serviceLocator(),
          child: BlocConsumer<FollowCubit, FollowState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    isScrollable: false,
                    tabs: [
                      Tab(text: LocaleKeys.followers.localize),
                      Tab(text: LocaleKeys.following.localize),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TabBarView(
                        controller: _tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [FollowersView(), FollowingView()],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
