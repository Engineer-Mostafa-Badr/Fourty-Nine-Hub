import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/data/models/comment_model.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/cubit/social_posts_cubit.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_user_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';
import '../../../domain/entities/comment_entity.dart';
import '../../../domain/usecases/post_comment_usecase.dart';
import 'comment_card.dart';

class FacebookPostComments extends StatefulWidget {
  // final List<CommentEntity> comments;
  final String postId;
  final String from;
  final Function(PostCommentParams) onAddComment;
  final Function(ReplyOnCommentParams) onCommentReply;
  final Function(PostCommentParams) onEditComment;
  final Function(String) onDeleteComment;
  final Function(String) onDeleteReply;
  const FacebookPostComments(
      {super.key,
      required this.postId,
      // required this.comments,
      required this.onAddComment,
      required this.onCommentReply,
      required this.onDeleteComment,
      required this.onDeleteReply,
      required this.from,
      required this.onEditComment});

  @override
  State<FacebookPostComments> createState() => _FacebookPostCommentsState();
}

class _FacebookPostCommentsState extends State<FacebookPostComments> {
  final commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialPostsCubit, SocialPostsState>(
        builder: (context, state) {
      final controller = context.read<SocialPostsCubit>();
      final user = context.read<UserCubit>().state.data;
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: 200.h,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.grey),
          title: Label(
              text:
                  '${controller.commentsPagingController.itemList?.length ?? 0} ${LocaleKeys.comments.localize}',
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
                pagingController: controller.commentsPagingController,
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                builderDelegate: PagedChildBuilderDelegate<CommentEntity>(
                    noItemsFoundIndicatorBuilder: (context) {
                      print(
                          controller.commentsPagingController.itemList?.length);
                      return Padding(
                          padding: const EdgeInsets.only(top: 200),
                          child: Center(
                            child: Text(
                              LocaleKeys.noComments.localize,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ));
                    },
                    itemBuilder: (context, item, index) {
                      return _buildCommentCard(
                        comment: controller
                            .commentsPagingController.itemList![index],
                        onDeleteComment: (String id) async {
                          var result = await widget.onDeleteComment(id);
                          if (result == true) {
                            controller.commentsPagingController.itemList
                                ?.removeWhere((e) => e.id == id);
                            setState(() {});
                          }
                        },
                        onDeleteReply: (String id) => widget.onDeleteReply(id),
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
                        controller: commentTextController,
                        onChanged: (v) {
                          setState(() {});
                        },
                        style: Styles.headerText(fontSize: 26),
                        decoration: InputDecoration(
                          //  fillColor: Colors.white,
                          contentPadding: const EdgeInsets.all(5),
                          hintText:
                              '${LocaleKeys.typeYourComment.localize} ....',
                          hintStyle: Styles.mediumText(),
                        ),
                      ),
                    ),
                    const Sizer(),
                    if (commentTextController.text.isNotEmpty)
                      IconAppButton(
                          icon: Icons.send,
                          size: 20,
                          isCircle: true,
                          onPressed: () async {
                            CommentEntity data = await widget.onAddComment(
                                PostCommentParams(
                                    postId: widget.postId,
                                    content: commentTextController.text));
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
                            commentTextController.clear();
                            FocusScope.of(context).unfocus();
                            setState(() {});
                          })
                  ],
                )),
          ],
        ),
      );
    });
  }

  Widget _buildCommentCard(
      {required CommentEntity comment,
      required Function(String) onDeleteComment,
      required Function(String) onDeleteReply}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommentCard(
          comment: comment,
          onAddReply: (ReplyOnCommentParams params) =>
              widget.onCommentReply(params),
          onDeleteComment: (String id) => onDeleteComment(id),
          onDeleteReply: (String id) => onDeleteReply(id),
          from: widget.from,
          onEditComment: (PostCommentParams params) =>
              widget.onEditComment(params),
        ),
        if (comment.repliesCount != 0)
          Container(
              margin: const EdgeInsets.only(left: 30),
              child: TextAppButton(
                  label:
                      '${LocaleKeys.show.localize} ${comment.repliesCount} ${LocaleKeys.replies.localize}',
                  onPressed: () {}))
      ],
    );
  }
}
