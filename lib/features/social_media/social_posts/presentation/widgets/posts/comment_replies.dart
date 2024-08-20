import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/comment_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/reply_card.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class CommentReplies extends StatefulWidget {
  final List<CommentEntity> replies;
  final String commentId;
  final String postId;
  final String from;
  final Function(ReplyOnCommentParams) onAddReply;
  final Function(String) onDeleteReply;
  const CommentReplies({
    super.key,
    required this.replies,
    required this.commentId,
    required this.postId,
    required this.onAddReply,
    required this.onDeleteReply,
    required this.from,
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
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.grey),
          title: Label(
              text:
                  '${controller.repliesPagingController.itemList?.length ?? 0} Replies',
              style: Styles.mediumText()),
          leading: IconButton(
              onPressed: () => context.pop(), icon: const Icon(Icons.clear)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: PagedListView<int, CommentEntity>(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                pagingController: controller.repliesPagingController,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                builderDelegate: PagedChildBuilderDelegate<CommentEntity>(
                    noItemsFoundIndicatorBuilder: (context) {
                      print(
                          controller.repliesPagingController.itemList?.length);
                      return const Padding(
                          padding: EdgeInsets.only(top: 200),
                          child: Center(
                            child: Text(
                              "No Replies",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    const ProfileImage(accountId: 0),
                    const Sizer(),
                    Expanded(
                        child: FormTextField(
                            hint: 'Type your reply ....',
                            // height: kToolbarHeight * .7,
                            action: (v) {
                              setState(() {});
                            },
                            controller: replyTextController)),
                    const Sizer(),
                    if (replyTextController.text.isNotEmpty)
                      IconAppButton(
                        icon: Icons.send,
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
                                isDocumented: false,
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
        ),
      ],
    );
  }
}
