import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/text_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/comment_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/pages/post_details_page.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/comment_card.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/comment_replies.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_post_card.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_post_comments.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FaceBookPostDetails extends StatefulWidget {
  String? postId;
  CommentEntity? comment;
  bool? isReply;
  FaceBookPostDetails({super.key,payload}){
    if(payload is String){
      postId = payload;
    }else{
      postId = payload['postId'];
      if(payload['comment']!=null){
        comment =CommentModel.fromJson(payload['comment']);
        print("comment?.toJson${comment?.toJson()}");
      }
      if(payload['isReply'] == true){
        isReply = true;
      }else{
        isReply = false;
      }
    }
  }


  @override
  State<FaceBookPostDetails> createState() => _FaceBookPostDetailsState();
}

class _FaceBookPostDetailsState extends State<FaceBookPostDetails> {
  final commentTextController = TextEditingController();

  bool? loading;

  @override
  void initState() {
    context.read<SocialPostsCubit>().loadPostDetails(context, widget.postId??'',comment: widget.comment);
    if(widget.isReply == true){
      print("adnaslkdasldma");
      Future.delayed(const Duration(seconds: 1),()=>showReplies());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.data;


    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // toolbarHeight: 200.h,
        iconTheme: const IconThemeData(color: Colors.grey),
        title: Label(text: LocaleKeys.post.localize, style: Styles.mediumText()),
        leading: IconButton(
            onPressed: () => context.pop(), icon: const Icon(Icons.arrow_back)),
        centerTitle: true,
      ),
      body: BlocConsumer<SocialPostsCubit, SocialPostsState>(
          listener: (context, state) {},
          builder: (context, state) {
            final controller = context.read<SocialPostsCubit>();

            if (state.status == StateStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state.status == StateStatus.error ||
                state.postDetails == null) {
              return Center(
                child: Label(
                  text: getFailureMessage(
                    state.failure!,
                    context,
                  ),
                ),
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async => controller.onRefreshPostDetails(),
                      child: CustomScrollView(
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                FacebookPostCard(
                                  post: state.postDetails!,
                                  onReact: (params) async {
                                    var result = await controller
                                        .onReact(params: params, from: 'posts');
                                    return result;
                                  },
                                  deletePost: (postId)=>controller.deletePost(
                                      context: context, postId: postId),
                                  hidePost: (String postId) => controller.hidePost(
                                      context: context, postId: postId),
                                  showPostComments: (String v) {
                                    bottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        widget: BlocProvider.value(
                                          value: serviceLocator<SocialPostsCubit>()
                                            ..loadComments(
                                                context,
                                                v),
                                          child: FacebookPostComments(
                                            postId: v,
                                            onAddComment:
                                                (PostCommentParams params) {
                                              return controller.onPostComment(
                                                  params: params, from: 'feed');
                                            },
                                            onCommentReply:
                                                (ReplyOnCommentParams params) {
                                              return controller.replyOnComment(
                                                params: ReplyOnCommentParams(
                                                    postId: params.postId,
                                                    content: params.content,
                                                    commentId: params.commentId),
                                                from: 'feed',
                                              );
                                            },
                                            onDeleteComment: (String id) async {
                                              return await controller.deleteComment(
                                                  context: context,
                                                  commentId: id,
                                                  postId: state.postDetails?.id??'',
                                                  from: 'feed');
                                              // print(result);
                                            },
                                            onDeleteReply: (String id) async {
                                              return await controller.deleteComment(
                                                  context: context,
                                                  commentId: id,
                                                  postId: state.postDetails?.id??'',
                                                  from: 'feed');
                                            },
                                            from: 'feed',
                                            onEditComment:
                                                (PostCommentParams params) async {
                                              var result = await controller
                                                  .editComment(params: params);
                                              return result;
                                            },
                                          ),
                                        ));
                                  },
                                  showPostDetails: (PostEntity post) => bottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      widget: BlocProvider.value(
                                        value: serviceLocator<SocialPostsCubit>()
                                          ..loadPostDetails(
                                              context,
                                              state.postDetails?.isShared ==
                                                  true
                                                  ? state.postDetails?.mainPost?.id??''
                                                  : state.postDetails?.id??''),
                                        child: PostDetailsPage(
                                          comments: const [],
                                          postId: state.postDetails?.id??'',
                                          deletePost: (String postId) =>
                                              controller.deletePost(
                                                  context: context, postId: postId),
                                          hidePost: (String postId) =>
                                              controller.hidePost(
                                                  context: context, postId: postId),
                                          onAddComment:
                                              (PostCommentParams params) =>
                                              controller.onPostComment(
                                                  params: params,
                                                  from: 'details'),
                                          onReact: (params) => controller.onReact(
                                              params: params, from: 'posts'),
                                          showPostComments: (postId) {},
                                          showPostDetails: (PostEntity post) {},
                                          // post: controller.feedPagingController.itemList![index],

                                          onCommentReply:
                                              (ReplyOnCommentParams params) {
                                            return controller.replyOnComment(
                                              params: ReplyOnCommentParams(
                                                  postId: params.postId,
                                                  content: params.content,
                                                  commentId: params.commentId),
                                              from: 'details',
                                            );
                                          },
                                          onDeleteComment: (String id) async {
                                            return await controller.deleteComment(
                                                context: context,
                                                commentId: id,
                                                postId: state.postDetails?.id??'',
                                                from: 'feed');
                                            // print(result);
                                          },
                                          onDeleteReply: (String id) async {
                                            return await controller.deleteComment(
                                                context: context,
                                                commentId: id,
                                                postId:state.postDetails?.id??'',
                                                from: 'feed');
                                          },
                                          onEditComment:
                                              (PostCommentParams params) async {
                                            var result = await controller
                                                .editComment(params: params);
                                            return result;
                                          },
                                        ),
                                      )),
                                  onShare: (String id) {},
                                  from: 'details',
                                  isMyPost:
                                  user?.id == state.postDetails?.user.id,
                                  index: 0,
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                          PagedSliverList<int, CommentEntity>(
                            pagingController:
                            controller.commentsPagingController,
                            builderDelegate:
                            PagedChildBuilderDelegate<CommentEntity>(
                              noItemsFoundIndicatorBuilder: (context) {
                                return  Center(
                                  child: Text(
                                    LocaleKeys.noComments.localize,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                );
                              },
                              itemBuilder: (context, item, index) {
                                return _buildCommentCard(
                                    comment: controller.commentsPagingController
                                        .itemList![index],
                                    onCommentReply: (ReplyOnCommentParams params) {
                                      return controller.replyOnComment(
                                        params: ReplyOnCommentParams(
                                            postId: params.postId,
                                            content: params.content,
                                            commentId: params.commentId),
                                        from: 'feed',
                                      );
                                    },
                                    onDeleteComment: (String id) async {
                                       bool result = await controller.deleteComment(
                                          context: context,
                                          commentId: id,
                                          postId: state.postDetails?.id??'',
                                          from: 'feed');
                                       if(result == true){
                                         controller.commentsPagingController.itemList?.removeWhere((element) => element.id==id);
                                         setState(() {

                                         });
                                       }

                                      // print(result);
                                    },
                                    onDeleteReply: (String id) async {
                                      return await controller.deleteComment(
                                          context: context,
                                          commentId: id,
                                          postId: controller
                                              .feedPagingController
                                              .itemList![index]
                                              .id,
                                          from: 'feed');
                                    },
                                    onEditComment: (PostCommentParams params) async {
                                      var result = await controller
                                          .editComment(params: params);
                                      return result;
                                    });
                              },
                              noMoreItemsIndicatorBuilder: (context) =>
                                  Container(),
                              firstPageProgressIndicatorBuilder: (context) =>
                              const CupertinoActivityIndicator(),
                              newPageProgressIndicatorBuilder: (context) =>
                              const CupertinoActivityIndicator(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: kToolbarHeight,
                    decoration: const BoxDecoration(),
                    child: Row(children: [
                      ProfileImage(
                        size: 40.sp,
                        accountId: 0,
                        userId: state.postDetails?.user.id,
                        imageURL: user?.profilePicture,
                        fromProfile: true,
                      ),
                      const Sizer(),
                      Expanded(
                          child: TextFormField(
                            maxLines: null,
                            controller: commentTextController,
                            onChanged: (v) {
                              setState(() {});
                            },
                            style: Styles.headerText(fontSize: 26),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(5),
                              hintText: 'Type your comment ....',
                              hintStyle: Styles.mediumText(),
                            ),
                          )),
                      const Sizer(),
                      if(loading==true) CircularProgressIndicator(strokeWidth: 8.w,),
                      if (commentTextController.text.isNotEmpty&&(loading ==false||loading==null))
                        IconAppButton(
                          icon: Icons.send,
                          size: 20,
                          isCircle: true,
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            CommentEntity data = await controller.onPostComment(
                                params: PostCommentParams(
                                    postId: state.postDetails!.id,
                                    content: commentTextController.text), from: '');
                            setState(() {
                              loading = false;
                            });
                            final user = context.read<UserCubit>().state.data;
                            controller.commentsPagingController.itemList
                                ?.insert(
                              0,
                              CommentModel(
                                id: data.id,
                                content: commentTextController.text,
                                post: widget.postId??'',
                                createdAt: DateTime.now(),
                                loveCount: data.loveCount,
                                angryCount: data.angryCount,
                                likesCount: data.likesCount,
                                repliesCount: data.repliesCount,
                                sadCount: data.sadCount,
                                wowCount: data.wowCount,
                                isAngry: false,
                                isLikes: false,
                                isLove: false,
                                isSad: false,
                                isWow: false,
                                user: TwitterUserEntity(
                                  id: user!.id,
                                  firstName: user.firstName,
                                  lastName: user.lastName,
                                  createdAt: DateTime.now(),
                                  image: user.profilePicture ?? '',
                                  email: user.email ?? '',
                                  isDocumented: false,
                                ),
                              ),
                            );
                            // widget.post.commentsCount=(widget.post.commentsCount!+1);
                            state.postDetails?.commentsCount =
                            (state.postDetails!.commentsCount + 1);
                            commentTextController.clear();
                            FocusScope.of(context).unfocus();
                            setState(() {});
                          },
                        )
                    ]),
                  )
                ],
              );
            }
          }),
    );
  }

  showReplies(){
    return bottomSheet(
        context: context,
        isScrollControlled: true,
        widget: BlocProvider.value(
          value: serviceLocator<SocialPostsCubit>()
            ..loadReplies(context, widget.comment?.reply??'',comment: widget.comment),
          child: CommentReplies(
            replies: const [],
            postId: widget.postId??'',
            commentId: widget.comment?.reply??'',
            onAddReply: (ReplyOnCommentParams params) async {
              var result = await context.read<SocialPostsCubit>().replyOnComment(
                params: ReplyOnCommentParams(
                    postId: params.postId,
                    content: params.content,
                    commentId: params.commentId),
                from: 'feed',
              );
              setState(() {});
              return result;
            },
            onDeleteReply:(String id) async {
              return await context.read<SocialPostsCubit>().deleteComment(
                  context: context,
                  commentId: id,
                  postId: widget.postId??'',
                  from: 'details');
            },
            from: 'details',
            onEditComment: (PostCommentParams params) async {
              var result = await context.read<SocialPostsCubit>()
                  .editComment(params: params);
              return result;
            },
          ),
        ));
  }
  Widget _buildCommentCard(
      {required CommentEntity comment,
        required Function(ReplyOnCommentParams) onCommentReply,
        required Function(PostCommentParams params) onEditComment,
        required dynamic Function(String) onDeleteComment,
        required dynamic Function(String) onDeleteReply}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CommentCard(
            // onEditComment: (p0) {},
            comment: comment,
            onAddReply: (ReplyOnCommentParams params) async {
              var result = await onCommentReply(params);
              setState(() {});
              return result;
            },
            onDeleteComment: (String id) => onDeleteComment(id),
            onDeleteReply: (String id) => onDeleteReply(id),
            from: 'feed',
            onEditComment: (PostCommentParams params) =>
                onEditComment(params),
          ),
        ),
        if (comment.repliesCount != 0)
          Container(
              margin: const EdgeInsets.only(left: 30),
              child: TextAppButton(
                  label: 'show ${comment.repliesCount} replies',
                  onPressed: () {}))
      ],
    );
  }
}
