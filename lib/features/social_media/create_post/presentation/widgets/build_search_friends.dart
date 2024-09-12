import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/entities/post_user_entity.dart';
import 'package:fourtyninehub/features/social_media/create_post/presentation/cubit/create_post_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BuildSearchFriends extends StatefulWidget {
  const BuildSearchFriends({
    super.key,
    required this.onSelectUser,
    required this.controller,
  });
  final Function(PostUserEntity) onSelectUser;
  final CreatePostCubit controller;
  @override
  State<BuildSearchFriends> createState() => _BuildSearchFriendsState();
}

class _BuildSearchFriendsState extends State<BuildSearchFriends> {
  final searchController = TextEditingController();

  @override
  void initState() {
    widget.controller.usersPagingController.itemList = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsetsDirectional.only(top: 20.0, end: 8, start: 8),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Row(
                children: [
                  InkWell(
                      onTap: () => context.pop(),
                      child: const Icon(Icons.arrow_back)),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: FormTextField(
                      hint: 'search ....',
                      height: kToolbarHeight * .7,
                      action: (v) async {
                        setState(() {});
                        widget.controller.usersPagingController.itemList = [];
                        // widget.controller.usersPagingController.refresh();
                        // widget.controller.loadUsers(v);

                        // widget.controller.usersPagingController.itemList = [];
                        await widget.controller.loadUsers(v);
                        setState(() {});
                      },
                      controller: searchController,
                      suffix: const Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.controller.usersPagingController.itemList != null &&
                widget.controller.usersPagingController.itemList!.isNotEmpty)
              PagedSliverList<int, PostUserEntity>(
                pagingController: widget.controller.usersPagingController,
                builderDelegate: PagedChildBuilderDelegate<PostUserEntity>(
                  noItemsFoundIndicatorBuilder: (context) {
                    return SizedBox.shrink();
                  },
                  itemBuilder: (context, item, index) {
                    return Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(widget
                                        .controller
                                        .usersPagingController
                                        .itemList?[index]
                                        .profilePicture ??
                                    ''),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Label(
                                text: widget.controller.usersPagingController
                                        .itemList?[index].fullName ??
                                    '',
                                style: Styles.headerText(),
                              ),
                            ],
                          ),
                          Checkbox(
                              value: widget.controller.usersPagingController
                                  .itemList?[index].isSelected,
                              onChanged: (v) {
                                widget.onSelectUser(widget.controller
                                    .usersPagingController.itemList![index]);
                                widget.controller.usersPagingController
                                        .itemList?[index].isSelected =
                                    !widget.controller.usersPagingController
                                        .itemList![index].isSelected!;
                                setState(() {});
                              }),
                        ],
                      ),
                    );
                  },
                  noMoreItemsIndicatorBuilder: (context) => Container(),
                  firstPageProgressIndicatorBuilder: (context) =>
                      const CupertinoActivityIndicator(),
                  newPageProgressIndicatorBuilder: (context) =>
                      const CupertinoActivityIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
