import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/user_profile_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/account/user_post_card.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_post_comments.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SocialPostsCubit>(
      create: (_)=>serviceLocator()..loadUserPosts(widget.userData.id),
      child: BlocConsumer<SocialPostsCubit, SocialPostsState>(listener: (context, state) {
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
          child:PagedListView<int, PostEntity>(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            pagingController: controller.userPostsPagingController,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            builderDelegate: PagedChildBuilderDelegate<PostEntity>(
                noItemsFoundIndicatorBuilder: (context) {
                  print(controller.userPostsPagingController.itemList?.length);
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
                  final post = controller.userPostsPagingController.itemList![index];
                  showReacts=false;
                  return state.status == StateStatus.success? UserPostCard(
                    // showReacts: showReacts,
                    post: post,
                    onReact: (params)async{},
                    deletePost: (String postId) async{
                      await controller
                        .deletePost(context: context, postId: postId);
                      controller.userPostsPagingController.itemList?.removeWhere((element) => element.id==postId);
                      setState(() {

                      });
                    },
                    hidePost: (String postId) async{
                      await controller.hidePost(
                        context: context, postId: postId);
                      controller.userPostsPagingController.itemList?.removeWhere((element) => element.id==postId);
                      setState(() {

                      });
                    },
                    showPostDetails: (params){

                    },
                    showPostComments: (params){
                      bottomSheet(
                          context: context,
                          isScrollControlled: true,
                          widget: BlocProvider.value(
                            value: serviceLocator<SocialPostsCubit>()..loadComments(context, controller.userPostsPagingController
                                .itemList![index].id),
                            child: FacebookPostComments(
                              postId: controller.userPostsPagingController
                                  .itemList![index].id,
                              onAddComment:
                                  (PostCommentParams params) async{
                                var result = await controller.onPostComment(
                                    params: params, from: 'feed');
                                var currentPost=controller.userPostsPagingController.itemList?.firstWhere((element) => element.id==params.postId);
                                currentPost?.commentsCount=(currentPost.commentsCount!+1);
                                return result;
                              }, onCommentReply: (ReplyOnCommentParams params) async{
                              var result = await controller.replyOnComment(
                                params:ReplyOnCommentParams(
                                    postId: params.postId, content: params.content,commentId: params.commentId), from: 'feed',
                              );
                              var currentPost=controller.userPostsPagingController.itemList?.firstWhere((element) => element.id==params.postId);
                              currentPost?.commentsCount=(currentPost.commentsCount!+1);
                              return result;
                            }, onDeleteComment: (String id)async {
                              var currentPost=controller.userPostsPagingController.itemList?[index];
                              var result =  await controller.deleteComment(
                                  context: context,
                                  commentId: id, postId: controller.userPostsPagingController
                                  .itemList![index].id, from: 'feed');
                              currentPost?.commentsCount=(currentPost.commentsCount!-1);
                              setState(() {});
                              return result;
                              }, onDeleteReply: (String id) async{
                              var currentPost=controller.userPostsPagingController.itemList?[index];
                              var result= await controller.deleteComment(
                                  context: context,
                                  commentId: id, postId: controller.userPostsPagingController
                                  .itemList![index].id, from: 'feed');
                              currentPost?.commentsCount=(currentPost.commentsCount!-1);
                              setState(() {});
                              return result;
                            }, from: 'feed',),
                          ));
                    },
                    onShare: (String id) {},
                    from: 'posts',
                    isMyPost:
                    user?.id == state.postDetails?.user.id, index: 0,
                    onSelectReact: (int i) {
                  },
                  ):Center(
                    child: Label(text: getFailureMessage(
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
        );
      }),
    );
  }
}
