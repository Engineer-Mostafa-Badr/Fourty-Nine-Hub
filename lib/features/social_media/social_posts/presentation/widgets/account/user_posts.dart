import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/enums/base_status_enum.dart';
import '../../../../../../core/error/failure.dart';
import '../../../../../../core/messages/messages.dart';
import '../../../domain/entities/user_profile_entity.dart';
import '../../cubit/social_posts_cubit.dart';
import '../../../../../../service_locator/service_locator.dart';

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
      create: (_) => serviceLocator(),
        // ..loadUserPosts(widget.userData.id),
      child: BlocConsumer<SocialPostsCubit, SocialPostsState>(
          listener: (context, state) {
        if (state.status == StateStatus.error) {
          showErrorMessage(
            context,
            getFailureMessage(
              state.failure ?? UnknownFailure(''),
              context,
            ),
          );
        }
      }, builder: (context, state) {
        final controller = context.read<SocialPostsCubit>();
        return SliverToBoxAdapter(child: Container());
        // return PagedSliverList<int, PostEntity>(
        //   pagingController: controller.userPostsPagingController,
        //   builderDelegate: PagedChildBuilderDelegate<PostEntity>(
        //       noItemsFoundIndicatorBuilder: (context) {
        //         print(controller.userPostsPagingController.itemList?.length);
        //         return Padding(
        //             padding: EdgeInsets.only(top: 100.h),
        //             child: Center(
        //               child: Text(
        //                 LocaleKeys.noPosts.localize,
        //                 style: Styles.headerText(),
        //               ),
        //             ));
        //       },
        //       itemBuilder: (context, item, index) {
        //         final user = context.read<UserCubit>().state.data;
        //         final post =
        //             controller.userPostsPagingController.itemList![index];
        //         showReacts = false;
        //         return state.status == StateStatus.success
        //             ? Padding(
        //                 padding: EdgeInsets.only(top: 30.h),
        //                 child: UserPostCard(
        //                   // showReacts: showReacts,
        //                   post: post,
        //                   onReact: (params) async {},
        //                   deletePost: (String postId) async {
        //                     await controller.deletePost(
        //                         context: context, postId: postId);
        //                     controller.userPostsPagingController.itemList
        //                         ?.removeWhere(
        //                             (element) => element.id == postId);
        //                     setState(() {});
        //                   },
        //                   hidePost: (String postId) async {
        //                     await controller.hidePost(
        //                         context: context, postId: postId);
        //                     controller.userPostsPagingController.itemList
        //                         ?.removeWhere(
        //                             (element) => element.id == postId);
        //                     setState(() {});
        //                   },
        //                   showPostDetails: (params) {},
        //                   showPostComments: (params) {
        //                     bottomSheet(
        //                         context: context,
        //                         isScrollControlled: true,
        //                         widget: BlocProvider.value(
        //                           value: serviceLocator<SocialPostsCubit>()
        //                             ..loadComments(
        //                                 context,
        //                                 controller.userPostsPagingController
        //                                     .itemList![index].id),
        //                           child: FacebookPostComments(
        //                             postId: controller.userPostsPagingController
        //                                 .itemList![index].id,
        //                             onAddComment:
        //                                 (PostCommentParams params) async {
        //                               var result =
        //                                   await controller.onPostComment(
        //                                       params: params,
        //                                       from: 'userPosts');
        //                               var currentPost = controller
        //                                   .userPostsPagingController.itemList
        //                                   ?.firstWhere((element) =>
        //                                       element.id == params.postId);
        //                               currentPost?.commentsCount =
        //                                   (currentPost.commentsCount + 1);
        //                               return result;
        //                             },
        //                             onCommentReply:
        //                                 (ReplyOnCommentParams params) async {
        //                               var result =
        //                                   await controller.replyOnComment(
        //                                 params: ReplyOnCommentParams(
        //                                     postId: params.postId,
        //                                     content: params.content,
        //                                     commentId: params.commentId),
        //                                 from: 'feed',
        //                               );
        //                               var currentPost = controller
        //                                   .userPostsPagingController.itemList
        //                                   ?.firstWhere((element) =>
        //                                       element.id == params.postId);
        //                               currentPost?.commentsCount =
        //                                   (currentPost.commentsCount + 1);
        //                               return result;
        //                             },
        //                             onDeleteComment: (String id) async {
        //                               var currentPost = controller
        //                                   .userPostsPagingController
        //                                   .itemList?[index];
        //                               var result =
        //                                   await controller.deleteComment(
        //                                       context: context,
        //                                       commentId: id,
        //                                       postId: controller
        //                                           .userPostsPagingController
        //                                           .itemList![index]
        //                                           .id,
        //                                       from: 'feed');
        //                               currentPost?.commentsCount =
        //                                   (currentPost.commentsCount - 1);
        //                               setState(() {});
        //                               return result;
        //                             },
        //                             onDeleteReply: (String id) async {
        //                               var currentPost = controller
        //                                   .userPostsPagingController
        //                                   .itemList?[index];
        //                               var result =
        //                                   await controller.deleteComment(
        //                                       context: context,
        //                                       commentId: id,
        //                                       postId: controller
        //                                           .userPostsPagingController
        //                                           .itemList![index]
        //                                           .id,
        //                                       from: 'feed');
        //                               currentPost?.commentsCount =
        //                                   (currentPost.commentsCount - 1);
        //                               setState(() {});
        //                               return result;
        //                             },
        //                             from: 'feed',
        //                             onEditComment:
        //                                 (PostCommentParams params) async {
        //                               var result = await controller.editComment(
        //                                   params: params);
        //                               return result;
        //                             },
        //                           ),
        //                         ));
        //                   },
        //                   onShare: (String id) {},
        //                   from: 'posts',
        //                   isMyPost: user?.id == state.postDetails?.user.id,
        //                   index: 0,
        //                   onSelectReact: (int i) {},
        //                 ),
        //               )
        //             : Center(
        //                 child: Label(
        //                     text: getFailureMessage(
        //                   state.failure ?? UnknownFailure(''),
        //                   context,
        //                 )),
        //               );
        //       },
        //       noMoreItemsIndicatorBuilder: (context) => Container(),
        //       firstPageProgressIndicatorBuilder: (context) => Container(
        //           margin: const EdgeInsets.only(top: 150),
        //           child: const CupertinoActivityIndicator()),
        //       newPageProgressIndicatorBuilder: (context) =>
        //           const CupertinoActivityIndicator()),
        // );
      }),
    );
  }
}
