import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';
import 'package:fourtyninehub/features/account_taps/lists/presentation/cubit/lists_cubit.dart';
import 'package:fourtyninehub/features/account_taps/lists/presentation/widgets/list_item_card.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/accept_reject_friend_request_use_case.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../core/localization/locales.dart';
import '../../../../../res/style/styles.dart';

class ListsView extends StatefulWidget {
  const ListsView({super.key});

  @override
  State<ListsView> createState() => _ListsViewState();
}

class _ListsViewState extends State<ListsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Add a listener to load data when the tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _onTabChanged(_tabController.index);
      }
    });

    // Add listener to the search controller to update data on search input
    searchController.addListener(_onSearchChanged);

    // Initially load data for the first tab (Friends)
    _onTabChanged(0);
  }

  @override
  void dispose() {
    _tabController.dispose(); // Dispose of the TabController
    searchController.dispose(); // Dispose the search controller
    super.dispose();
  }

  // Handle tab change and data loading
  void _onTabChanged(int index) {
    final listsCubit = context.read<ListsCubit>();
    final searchText = searchController.text;

    // Always reload the data for the current active tab
    if (index == 0) {
      listsCubit.loadFriends(searchText); // Reload Friends tab
    } else if (index == 1) {
      listsCubit.loadFollowers(searchText); // Reload Followers tab
    } else if (index == 2) {
      listsCubit.loadRequests(searchText); // Reload Requests tab
    } else if (index == 3) {
      listsCubit.loadBlocked(searchText); // Reload Blocked tab
    }
  }

  // Handle search input change
  void _onSearchChanged() {
    final listsCubit = context.read<ListsCubit>();
    final searchText = searchController.text;

    // Load the data for the current active tab based on search input
    if (_tabController.index == 0) {
      listsCubit.loadFriends(searchText);
    } else if (_tabController.index == 1) {
      listsCubit.loadFollowers(searchText);
    } else if (_tabController.index == 2) {
      listsCubit.loadRequests(searchText);
    } else if (_tabController.index == 3) {
      listsCubit.loadBlocked(searchText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Label(
          text: LocaleKeys.lists.localize,
          style: Styles.headerText(),
        ),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabAlignment: TabAlignment.start,
          labelPadding: context.locale == Locales.english
              ? EdgeInsets.only(left: 30.w)
              : EdgeInsets.only(right: 30.w),
          labelStyle: Styles.mediumText(fontSize: 50.sp),
          tabs: [
            Tab(
              child: listItem(
                  label: LocaleKeys.friends.localize,
                  icon: Icons.handshake,
                  context: context,
                  type: ListTypes.friends),
            ),
            Tab(
              child: listItem(
                  label: LocaleKeys.followers.localize,
                  icon: Icons.group,
                  context: context,
                  type: ListTypes.followers),
            ),
            Tab(
              child: listItem(
                  label: LocaleKeys.requests.localize,
                  icon: Icons.h_mobiledata,
                  context: context,
                  type: ListTypes.requests),
            ),
            Tab(
              child: listItem(
                  label: LocaleKeys.blocked.localize,
                  icon: Icons.block,
                  context: context,
                  type: ListTypes.blocked),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFriendsTab(context),
          _buildFollowersTab(context),
          _buildRequestsTab(context),
          _buildBlockedTab(context),
        ],
      ),
    );
  }

  Widget _buildFriendsTab(BuildContext context) {
    return BlocConsumer<ListsCubit, ListsState>(
      listener: (context, state) {},
      builder: (context, state) {
        final controller = context.read<ListsCubit>();
        return Column(
          children: [
            _buildSortingWidget(
                context: context,
                controller: searchController,
                search: (v) {
                  if (state.selectedList == ListTypes.friends) {
                    controller.loadFriends(v);
                  } else if (state.selectedList == ListTypes.followers) {
                    controller.loadFollowers(v);
                  } else if (state.selectedList == ListTypes.blocked) {
                    controller.loadBlocked(v);
                  } else if (state.selectedList == ListTypes.requests) {
                    controller.loadRequests(v);
                  }
                }),
            Expanded(
              child: state.isLoading
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : _buildListUsersWidget(
                      controller: controller.friendsPagingController,
                      list: state.friends ?? [],
                      type: ListTypes.friends,
                      removeRequest: (params) {},
                      acceptRequest: (params) {},
                      unblockUser: (id) {},
                      deleteFriend: (id) async {
                        var result = await context
                            .read<ListsCubit>()
                            .deleteFriend(userId: id);
                        if (result == true) {
                          state.friends!.removeWhere((e) => e.id == id);
                          showSuccessMessage(
                              context, LocaleKeys.deleteSuccessfully.localize);
                          setState(() {});
                        }
                      },
                      unfollowUser: (id) {},
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFollowersTab(BuildContext context) {
    return BlocConsumer<ListsCubit, ListsState>(
      listener: (context, state) {},
      builder: (context, state) {
        final controller = context.read<ListsCubit>();
        return Column(
          children: [
            _buildSortingWidget(
                context: context,
                controller: searchController,
                search: (v) {
                  if (state.selectedList == ListTypes.friends) {
                    controller.loadFriends(v);
                  } else if (state.selectedList == ListTypes.followers) {
                    controller.loadFollowers(v);
                  } else if (state.selectedList == ListTypes.blocked) {
                    controller.loadBlocked(v);
                  } else if (state.selectedList == ListTypes.requests) {
                    controller.loadRequests(v);
                  }
                }),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : _buildListUsersWidget(
                      controller: controller.followersPagingController,
                      list: state.followers ?? [],
                      type: ListTypes.followers,
                      removeRequest: (params) {},
                      acceptRequest: (params) {},
                      unblockUser: (id) {},
                      deleteFriend: (id) async {},
                      unfollowUser: (id) async {
                        var result = await controller.unFollowRequest(
                            userId: id, context: context);
                        if (result == true) {
                          state.followers?.removeWhere((e) => e.id == id);
                          showSuccessMessage(context,
                              LocaleKeys.unFollowSuccessfully.localize);
                          setState(() {});
                        }
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRequestsTab(BuildContext context) {
    return BlocConsumer<ListsCubit, ListsState>(
      listener: (context, state) {},
      builder: (context, state) {
        final controller = context.read<ListsCubit>();

        return Column(
          children: [
            _buildSortingWidget(
                context: context,
                controller: searchController,
                search: (v) {
                  if (state.selectedList == ListTypes.friends) {
                    controller.loadFriends(v);
                  } else if (state.selectedList == ListTypes.followers) {
                    controller.loadFollowers(v);
                  } else if (state.selectedList == ListTypes.blocked) {
                    controller.loadBlocked(v);
                  } else if (state.selectedList == ListTypes.requests) {
                    controller.loadRequests(v);
                  }
                }),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : _buildListUsersWidget(
                      controller: controller.requestsPagingController,
                      list: state.requests ?? [],
                      type: ListTypes.requests,
                      removeRequest: (params) async {
                        var result =
                            await controller.acceptRejectFriend(params: params);
                        if (result == true) {
                          state.requests
                              ?.removeWhere((e) => e.id == params.userId);
                          showSuccessMessage(context,
                              LocaleKeys.removeRequestSuccessfully.localize);
                          setState(() {});
                        }
                      },
                      acceptRequest: (params) async {
                        var result =
                            await controller.acceptRejectFriend(params: params);
                        if (result == true) {
                          state.requests
                              ?.removeWhere((e) => e.id == params.userId);
                          showSuccessMessage(context,
                              LocaleKeys.acceptRequestSuccessfully.localize);
                          setState(() {});
                        }
                      },
                      unblockUser: (id) {},
                      deleteFriend: (id) {},
                      unfollowUser: (id) async {},
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBlockedTab(BuildContext context) {
    return BlocConsumer<ListsCubit, ListsState>(
      listener: (context, state) {},
      builder: (context, state) {
        final controller = context.read<ListsCubit>();
        return Column(
          children: [
            _buildSortingWidget(
                context: context,
                controller: searchController,
                search: (v) {
                  if (state.selectedList == ListTypes.friends) {
                    controller.loadFriends(v);
                  } else if (state.selectedList == ListTypes.followers) {
                    controller.loadFollowers(v);
                  } else if (state.selectedList == ListTypes.blocked) {
                    controller.loadBlocked(v);
                  } else if (state.selectedList == ListTypes.requests) {
                    controller.loadRequests(v);
                  }
                }),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : _buildListUsersWidget(
                      controller: controller.blockedPagingController,
                      list: state.blocked ?? [],
                      type: ListTypes.blocked,
                      removeRequest: (params) {},
                      acceptRequest: (params) {},
                      unblockUser: (id) async {
                        var result = await controller.blockUser(
                            userId: id, context: context);
                        if (result == true) {
                          state.blocked?.removeWhere((e) => e.id == id);
                          showSuccessMessage(context,
                              LocaleKeys.unBlockedSuccessfully.localize);
                          setState(() {});
                        }
                      },
                      deleteFriend: (id) {},
                      unfollowUser: (id) {},
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSortingWidget({
    required BuildContext context,
    required TextEditingController controller,
    required Function(String) search,
  }) {
    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: searchController,
              onChanged: (v) => search(v),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(5),
                hintStyle: Styles.mediumText(),
                hintText: LocaleKeys.searchWithName.localize,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListUsersWidget({
    required List<dynamic> list,
    required ListTypes type,
    required PagingController<int, UserFriendEntity> controller,
    required Function(AcceptRejectFriendRequestParams) removeRequest,
    required Function(AcceptRejectFriendRequestParams) acceptRequest,
    required Function(String) unblockUser,
    required Function(String) deleteFriend,
    required Function(String) unfollowUser,
  }) {
    if (list.isEmpty) {
      return Center(
        child: Text(
          '', // Adjust this to your localization key
          style: Styles.mediumText(),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: () async {
        return Future.sync(() => controller.refresh());
      },
      child: PagedListView.separated(
        pagingController: controller,
        separatorBuilder: (context, index) => const Divider(),
        builderDelegate: PagedChildBuilderDelegate<UserFriendEntity>(
          itemBuilder: (context, item, index) {
            return ListItemCard(
              type: type,
              user: item,
              removeRequest: removeRequest,
              acceptRequest: acceptRequest,
              unblockUser: unblockUser,
              deleteFriend: deleteFriend,
              unfollowUser: unfollowUser,
            );
          },
        ),
      ),
    );
  }

  Widget listItem({
    required String label,
    required IconData icon,
    required BuildContext context,
    required ListTypes type,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20.sp,
        ),
        Sizer(
          width: 10.w,
        ),
        Label(
          text: label,
          style: Styles.mediumText(),
        ),
      ],
    );
  }
}
