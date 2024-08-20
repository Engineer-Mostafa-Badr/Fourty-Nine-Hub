import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/account/user_post_card.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class UserPosts extends StatefulWidget {
  const UserPosts({super.key, required this.userData});
  final UserProfileEntity userData;
  @override
  State<UserPosts> createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  bool showReacts = false;

  closeReacts() {
    setState(() {
      showReacts = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SocialPostsCubit>(
      create: (_) => serviceLocator()..loadUserPosts(widget.userData.id),
      child: BlocConsumer<SocialPostsCubit, SocialPostsState>(
          listener: (context, state) {
        if (state.status == StateStatus.error) {
          showErrorMessage(
            context,
            getFailureMessage(
              state.failure ?? const UnknownFailure(),
              context,
            ),
          );
        }
      }, builder: (context, state) {
        final controller = context.read<SocialPostsCubit>();
        return RefreshIndicator(
          onRefresh: () async => controller.refreshUserPosts(),
          child: GestureDetector(
            onTap: () {
              closeReacts();
            },
            child: PagedListView<int, PostEntity>(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
              pagingController: controller.userPostsPagingController,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              builderDelegate: PagedChildBuilderDelegate<PostEntity>(
                  noItemsFoundIndicatorBuilder: (context) {
                    print(
                        controller.userPostsPagingController.itemList?.length);
                    return const Padding(
                        padding: EdgeInsets.only(top: 200),
                        child: Center(
                          child: Text(
                            "No Posts",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                          ),
                        ));
                  },
                  itemBuilder: (context, item, index) {
                    final user = context.read<UserCubit>().state.data;
                    final post =
                        controller.userPostsPagingController.itemList![index];
                    showReacts = false;
                    return state.status == StateStatus.success
                        ? UserPostCard(
                            // showReacts: showReacts,
                            post: post,
                            onReact: (params) async {
                              // var result = await widget.onReact(params);
                              // changeReaction(state.postDetails, params.react);
                              // setState(() {
                              //
                              // });
                              // return result;
                            },
                            deletePost: (params) {},
                            hidePost: (params) {},
                            showPostDetails: (params) {},
                            showPostComments: (params) {},
                            onShare: (String id) {},
                            from: 'posts',
                            isMyPost: user?.id == state.postDetails?.user.id,
                            index: 0,
                            onSelectReact: (int i) {
                              print(controller.reacts[i].react);
                              closeReacts();
                            },
                          )
                        : Center(
                            child: Label(
                                text: getFailureMessage(
                              state.failure ?? const UnknownFailure(),
                              context,
                            )),
                          );
                  },
                  noMoreItemsIndicatorBuilder: (context) => Container(),
                  firstPageProgressIndicatorBuilder: (context) => Container(
                      margin: const EdgeInsets.only(top: 150),
                      child: const CupertinoActivityIndicator()),
                  newPageProgressIndicatorBuilder: (context) =>
                      const CupertinoActivityIndicator()),
            ),
          ),
        );
      }),
    );
  }
}
