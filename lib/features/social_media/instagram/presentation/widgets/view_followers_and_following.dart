import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../common/widgets/stateful/banners/back_appbar.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../cubit/followers_cubit/follower_cubit.dart';
import '../cubit/followers_cubit/followers_state.dart';
import 'followers_view.dart';
import 'following_view.dart';
import '../../../../../service_locator/service_locator.dart';

import '../../../../../core/widget/custom_scaffold.dart';

class ViewFollowersAndFollowing extends StatefulWidget {
  const ViewFollowersAndFollowing(
      {super.key, required this.otherId, required this.email});
  final String otherId;
  final String email;

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
      child: CustomScaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: BackAppBar(
              label: widget.email == 'Hidden' ? '' : widget.email.split('@')[0]),
        ),
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
                        children: [
                          FollowersView(
                            otherId: widget.otherId,
                          ),
                          FollowingView(
                            otherId: widget.otherId,
                          )
                        ],
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
