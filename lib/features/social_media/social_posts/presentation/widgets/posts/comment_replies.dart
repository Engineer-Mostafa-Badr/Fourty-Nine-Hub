import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/comment_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/reply_card.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/widget/custom_scaffold.dart';
import '../../../../../../res/style/styles.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentReplies extends StatefulWidget {
  final List<CommentEntity> replies;
  final String commentId;
  final String postId;
  final String from;
  final Function(ReplyOnCommentParams) onAddReply;
  final Function(String) onDeleteReply;
  final Function(PostCommentParams) onEditComment;
  const CommentReplies({
    super.key,
    required this.replies,
    required this.commentId,
    required this.postId,
    required this.onAddReply,
    required this.onDeleteReply,
    required this.from,
    required this.onEditComment,
  });

  @override
  State<CommentReplies> createState() => _CommentRepliesState();
}

class _CommentRepliesState extends State<CommentReplies> {
  final replyTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialPostsCubit, SocialPostsState>(
        builder: (context, state) {
      final controller = context.read<SocialPostsCubit>();
      final user = context.read<UserCubit>().state.data;
      return CustomScaffold(
        appBar: AppBar(
          elevation: 0,
          toolbarHeight: 200.h,
          iconTheme: const IconThemeData(color: Colors.grey),
          title: Label(
              text:
                  '${controller.repliesPagingController.itemList?.length ?? 0} ${LocaleKeys.replies.localize}',
              style: Styles.mediumText()),
          leading: IconButton(
              onPressed: () => context.pop(), icon: const Icon(Icons.clear)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: PagedListView<int, CommentEntity>(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 5),
                pagingController: controller.repliesPagingController,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                builderDelegate: PagedChildBuilderDelegate<CommentEntity>(
                    noItemsFoundIndicatorBuilder: (context) {
                      print(
                          controller.repliesPagingController.itemList?.length);
                      return Padding(
                          padding: const EdgeInsets.only(top: 200),
                          child: Center(
                            child: Text(
                              LocaleKeys.noReplied.localize,
                              style: Styles.mediumText(),
                            ),
                          ));
                    },
                    itemBuilder: (context, item, index) {
                      return _buildCommentCard(
                          reply: controller
                              .repliesPagingController.itemList![index],
                          onDeleteReply: (String id) async {
                            var result = await widget.onDeleteReply(id);
                            if (result == true) {
                              controller.repliesPagingController.itemList
                                  ?.removeWhere((element) => element.id == id);
                              setState(() {});
                            }
                          });
                    },
                    noMoreItemsIndicatorBuilder: (context) => Container(),
                    firstPageProgressIndicatorBuilder: (context) => Container(
                        margin: const EdgeInsets.only(top: 150),
                        child: const CupertinoActivityIndicator()),
                    newPageProgressIndicatorBuilder: (context) =>
                        const CupertinoActivityIndicator()),
              ),
            ),
            Container(
                height: kToolbarHeight,
                decoration: const BoxDecoration(),
                child: Row(
                  children: [
                    ProfileImage(
                      accountId: 0,
                      fromProfile: true,
                      imageURL: user?.profilePicture,
                      userId: '',
                    ),
                    const Sizer(),
                    Expanded(
                        child: TextFormField(
                      maxLines: null,
                      controller: replyTextController,
                      onChanged: (v) {
                        setState(() {});
                      },
                      style: Styles.headerText(fontSize: 26),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(5),
                        hintText: '${LocaleKeys.typeYourReply.localize} ....',
                        hintStyle: Styles.mediumText(),
                      ),
                    )),
                    const Sizer(),
                    if (replyTextController.text.isNotEmpty)
                      IconAppButton(
                        icon: Icons.send,
                        size: 20,
                        isCircle: true,
                        onPressed: () async {
                          CommentEntity data = await widget.onAddReply(
                              ReplyOnCommentParams(
                                  postId: widget.postId,
                                  content: replyTextController.text,
                                  commentId: widget.commentId));
                          final user = context.read<UserCubit>().state.data;
                          print("add");
                          controller.repliesPagingController.itemList?.insert(
                            0,
                            CommentModel(
                              id: data.id,
                              content: replyTextController.text,
                              post: widget.postId,
                              createdAt: DateTime.now(),
                              loveCount: data.loveCount,
                              angryCount: data.angryCount,
                              likesCount: data.likesCount,
                              repliesCount: data.repliesCount,
                              sadCount: data.sadCount,
                              wowCount: data.wowCount,
                              totalCount: data.totalCount,
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
                                isDocumented: false, hasStory: false,
                              ),
                            ),
                          );
                          print("add");
                          replyTextController.clear();
                          FocusScope.of(context).unfocus();
                          setState(() {});
                        },
                      )
                  ],
                )),
          ],
        ),
      );
    });
  }

  Widget _buildCommentCard(
      {required CommentEntity reply, required Function(String) onDeleteReply}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReplyCard(
          reply: reply,
          onReplyReact: (String id) {
            // widget.onReplyReact(id);
            // reply.isReact = !reply.isReact!;
          },
          onReport: (TwitterReportParams params) {
            // widget.onReport(params);
          },
          onDeleteReply: (String id) => onDeleteReply(id),
          onEditComment: (PostCommentParams params) =>
              widget.onEditComment(params),
        ),
      ],
    );
  }
}
