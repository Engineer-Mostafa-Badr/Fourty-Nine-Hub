import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/post_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/facebook_post_card.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../res/style/styles.dart';
import '../../data/models/comment_model.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/usecases/post_comment_usecase.dart';
import '../../domain/usecases/post_react_usecase.dart';
import '../widgets/posts/comment_card.dart';

class PostDetailsPage extends StatefulWidget {
  // final PostEntity post;
  final List<CommentEntity> comments;
  final String postId;
  final Function(PostCommentParams) onAddComment;
  final Function(PostReactParams) onReact;
  final Function(String) showPostComments;
  final Function(PostEntity) showPostDetails;
  final Function(PostCommentParams) onEditComment;
  final Function(String) deletePost;
  final Function(String) hidePost;
  final Function(ReplyOnCommentParams) onCommentReply;
  final Function(String) onDeleteComment;
  final Function(String) onDeleteReply;
  const PostDetailsPage({
    super.key,
    required this.postId,
    required this.onAddComment,
    required this.onReact,
    required this.showPostComments,
    required this.showPostDetails,
    required this.comments,
    required this.deletePost,
    required this.hidePost,
    required this.onCommentReply,
    required this.onDeleteComment,
    required this.onDeleteReply,
    required this.onEditComment,
  });

  @override
  State<PostDetailsPage> createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  final commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.data;
    return CustomScaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 200.h,
        iconTheme: const IconThemeData(color: Colors.grey),
        title: Label(text: 'Post', style: Styles.mediumText()),
        leading: IconButton(
            onPressed: () => context.pop(), icon: const Icon(Icons.clear)),
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
                                    var result = await widget.onReact(params);
                                    return result;
                                  },
                                  deletePost: widget.deletePost,
                                  hidePost: widget.hidePost,
                                  showPostDetails: widget.showPostDetails,
                                  showPostComments: widget.showPostComments,
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
                                return Center(
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
                                    onCommentReply:
                                        (ReplyOnCommentParams params) async {
                                      var result =
                                          await widget.onCommentReply(params);

                                      state.postDetails?.commentsCount =
                                          (state.postDetails!.commentsCount +
                                              1);
                                      setState(() {});
                                      return result;
                                    },
                                    onDeleteComment: (String id) async {
                                      var result =
                                          await widget.onDeleteComment(id);
                                      state.postDetails?.commentsCount =
                                          (state.postDetails!.commentsCount -
                                              1);
                                      controller
                                          .commentsPagingController.itemList
                                          ?.removeWhere(
                                              (element) => element.id == id);

                                      setState(() {});
                                      return result;
                                    },
                                    onDeleteReply: (String id) async {
                                      var result =
                                          await widget.onDeleteReply(id);
                                      state.postDetails?.commentsCount =
                                          (state.postDetails!.commentsCount -
                                              1);
                                      controller
                                          .repliesPagingController.itemList
                                          ?.removeWhere(
                                              (element) => element.id == id);
                                      setState(() {});
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
                        userId: state.postDetails?.user.id??'',
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
                      if (commentTextController.text.isNotEmpty)
                        IconAppButton(
                          icon: Icons.send,
                          size: 20,
                          isCircle: true,
                          onPressed: () async {
                            CommentEntity data = await widget.onAddComment(
                              PostCommentParams(
                                  postId: state.postDetails!.id,
                                  content: commentTextController.text),
                            );
                            final user = context.read<UserCubit>().state.data;
                            controller.commentsPagingController.itemList
                                ?.insert(
                              0,
                              CommentModel(
                                id: data.id,
                                content: commentTextController.text,
                                post: widget.postId,
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

  Widget _buildCommentCard(
      {required CommentEntity comment,
      required Function(ReplyOnCommentParams) onCommentReply,
      required dynamic Function(String) onDeleteComment,
      required dynamic Function(String) onDeleteReply}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommentCard(
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
              widget.onEditComment(params),
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
