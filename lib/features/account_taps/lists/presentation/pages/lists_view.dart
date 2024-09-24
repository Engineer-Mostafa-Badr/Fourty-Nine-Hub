import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateful/banners/back_appbar.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/account_taps/lists/domain/entities/user_friend_entity.dart';
import 'package:fourtyninehub/features/account_taps/lists/presentation/cubit/lists_cubit.dart';
import 'package:fourtyninehub/features/account_taps/lists/presentation/widgets/list_item_card.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/accept_reject_friend_request_use_case.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ListsView extends StatefulWidget {
  const ListsView({super.key});

  @override
  State<ListsView> createState() => _ListsViewState();
}

class _ListsViewState extends State<ListsView> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BackAppBar(
          centerTitle: false,
          label: LocaleKeys.lists.localize,
        ),
        body: BlocConsumer<ListsCubit, ListsState>(
            listener: (context, state) {},
            builder: (context, state) {
              final controller = context.read<ListsCubit>();
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    height: kToolbarHeight * 1,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        listItem(
                            label: LocaleKeys.friends.localize,
                            icon: Icons.handshake,
                            context: context,
                            type: ListTypes.friends),
                        listItem(
                            label: LocaleKeys.followers.localize,
                            icon: Icons.group,
                            context: context,
                            type: ListTypes.followers),
                        listItem(
                            label: LocaleKeys.requests.localize,
                            icon: Icons.h_mobiledata,
                            context: context,
                            type: ListTypes.requests),
                        listItem(
                            label: LocaleKeys.blocked.localize,
                            icon: Icons.block,
                            context: context,
                            type: ListTypes.blocked),
                      ],
                    ),
                  ),
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
                          : state.selectedList == ListTypes.friends
                              ? _buildListUsersWidget(
                                  controller:
                                      controller.friendsPagingController,
                                  list: state.friends ?? [],
                                  type: ListTypes.friends,
                                  removeRequest:
                                      (AcceptRejectFriendRequestParams
                                          params) {},
                                  acceptRequest:
                                      (AcceptRejectFriendRequestParams
                                          params) {},
                                  unblockUser: (String id) {},
                                  deleteFriend: (String id) async {
                                    var result = await controller.deleteFriend(
                                        userId: id);
                                    if (result == true) {
                                      state.friends?.removeWhere(
                                          (element) => element.id == id);
                                      showSuccessMessage(
                                          context,
                                          LocaleKeys
                                              .unBlockedSuccessfully.localize);
                                      setState(() {});
                                    }
                                  },
                                  unfollowUser: (String id) {})
                              : state.selectedList == ListTypes.followers
                                  ? _buildListUsersWidget(
                                      controller:
                                          controller.followersPagingController,
                                      list: state.followers ?? [],
                                      type: ListTypes.followers,
                                      removeRequest:
                                          (AcceptRejectFriendRequestParams
                                              params) {},
                                      acceptRequest:
                                          (AcceptRejectFriendRequestParams
                                              params) {},
                                      unblockUser: (String id) {},
                                      deleteFriend: (String id) async {},
                                      unfollowUser: (String id) async {
                                        var result =
                                            await controller.unFollowRequest(
                                                userId: id, context: context);
                                        if (result == true) {
                                          state.friends?.removeWhere(
                                              (element) => element.id == id);
                                          showSuccessMessage(
                                              context,
                                              LocaleKeys.unFollowSuccessfully
                                                  .localize);
                                          setState(() {});
                                        }
                                      })
                                  : state.selectedList == ListTypes.requests
                                      ? _buildListUsersWidget(
                                          controller: controller
                                              .requestsPagingController,
                                          list: state.requests ?? [],
                                          type: ListTypes.requests,
                                          removeRequest:
                                              (AcceptRejectFriendRequestParams
                                                  params) async {
                                            var result = await controller
                                                .acceptRejectFriend(
                                                    params: params);
                                            if (result == true) {
                                              state.requests?.removeWhere(
                                                  (element) =>
                                                      element.id ==
                                                      params.userId);
                                              showSuccessMessage(
                                                  context,
                                                  LocaleKeys
                                                      .removeRequestSuccessfully
                                                      .localize);
                                              setState(() {});
                                            }
                                          },
                                          acceptRequest:
                                              (AcceptRejectFriendRequestParams
                                                  params) async {
                                            var result = await controller
                                                .acceptRejectFriend(
                                                    params: params);
                                            if (result == true) {
                                              state.requests?.removeWhere(
                                                  (element) =>
                                                      element.id ==
                                                      params.userId);
                                              showSuccessMessage(
                                                  context,
                                                  LocaleKeys
                                                      .acceptRequestSuccessfully
                                                      .localize);
                                              setState(() {});
                                            }
                                          },
                                          unblockUser: (String id) {},
                                          deleteFriend: (String id) {},
                                          unfollowUser: (String id) async {})
                                      : _buildListUsersWidget(
                                          controller: controller
                                              .blockedPagingController,
                                          list: state.blocked ?? [],
                                          type: ListTypes.blocked,
                                          removeRequest:
                                              (AcceptRejectFriendRequestParams
                                                  params) {},
                                          acceptRequest:
                                              (AcceptRejectFriendRequestParams
                                                  params) {},
                                          unblockUser: (String id) async {
                                            var result =
                                                await controller.blockUser(
                                                    userId: id,
                                                    context: context);
                                            if (result == true) {
                                              state.blocked?.removeWhere(
                                                  (element) =>
                                                      element.id == id);
                                              showSuccessMessage(
                                                  context,
                                                  LocaleKeys
                                                      .unBlockedSuccessfully
                                                      .localize);
                                              setState(() {});
                                            }
                                          },
                                          deleteFriend: (String id) {},
                                          unfollowUser: (String id) {}))
                ],
              );
            }));
  }

  Widget _buildSortingWidget(
      {required BuildContext context,
      required TextEditingController controller,
      required Function(String) search}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: searchController,
              onChanged: (v) {
                search(v);
              },
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(5),
                  hintStyle: Styles.mediumText(),
                  hintText: LocaleKeys.searchWithName.localize),
            ),
          )
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
    return PagedListView(
      pagingController: controller,
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      builderDelegate: PagedChildBuilderDelegate<UserFriendEntity>(
          noItemsFoundIndicatorBuilder: (context) {
            print(controller.itemList?.length);
            return Padding(
                padding: const EdgeInsets.only(top: 200),
                child: Center(
                  child: Text(
                    "No Users",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.sp,
                    ),
                  ),
                ));
          },
          itemBuilder: (context, item, index) {
            return ListItemCard(
              user: item,
              type: type,
              removeRequest: (AcceptRejectFriendRequestParams params) =>
                  removeRequest(params),
              acceptRequest: (AcceptRejectFriendRequestParams params) =>
                  acceptRequest(params),
              deleteFriend: (id) => deleteFriend(id),
              unblockUser: (id) => unblockUser(id),
              unfollowUser: (id) => unfollowUser(id),
            );
          },
          noMoreItemsIndicatorBuilder: (context) => Container(),
          firstPageProgressIndicatorBuilder: (context) => Container(
              margin: const EdgeInsets.only(top: 150),
              child: const CupertinoActivityIndicator()),
          newPageProgressIndicatorBuilder: (context) =>
              const CupertinoActivityIndicator()),
    );
  }

  Widget listItem({
    required String label,
    required IconData icon,
    required BuildContext context,
    required ListTypes type,
  }) {
    final controller = context.read<ListsCubit>();
    return BlocBuilder<ListsCubit, ListsState>(builder: (context, state) {
      bool selected = state.selectedList == type;
      return InkWell(
        onTap: () => controller.changeListType(type: type),
        child: Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: selected
                  ? AppColors.PRIMARY_COLOR
                  : AppColors.LIGHT_GRAY_COLOR,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: selected ? Colors.white : Colors.black,
                ),
                Sizer(
                  width: 5,
                ),
                Label(
                  text: label,
                  style: Styles.mediumText(
                      color: selected ? Colors.white : Colors.black),
                ),
              ],
            )),
      );
    });
  }
}
