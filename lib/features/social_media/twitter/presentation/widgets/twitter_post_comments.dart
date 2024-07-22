import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/twitter_comment_card.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class TwitterPostComments extends StatefulWidget {
  final List<TwitterPostCommentEntity> comments;
  final String postId;
  final Function(PostCommentParams) onAddComment;
  final GestureTapCallback? onCommentReact;
  const TwitterPostComments(
      {super.key,
      required this.postId,
      required this.comments,
      required this.onAddComment, this.onCommentReact});

  @override
  State<TwitterPostComments> createState() => _TwitterPostCommentsState();
}

class _TwitterPostCommentsState extends State<TwitterPostComments> {
  final commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.grey),
        title: Label(
            text: '${widget.comments.length} Comments',
            style: Styles.mediumText()),
        leading: IconButton(
            onPressed: () => context.pop(), icon: const Icon(Icons.clear)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
                itemBuilder: (context, index) =>
                    _buildCommentCard(comment: widget.comments[index]),
                separatorBuilder: (context, index) => const Sizer(),
                itemCount: widget.comments.length),
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
                          hint: 'Type your comment ....',
                          height: kToolbarHeight * .7,
                          action: (v) {
                            setState(() {});
                          },
                          controller: commentTextController)),
                  const Sizer(),
                  if (commentTextController.text.isNotEmpty)
                    IconAppButton(
                        icon: Icons.send,
                        isCircle: true,
                        onPressed: () => onCommentAdded())
                ],
              )),
        ],
      ),
    );
  }

  void onCommentAdded() {
    widget.onAddComment(
      PostCommentParams(
          postId: widget.postId, content: commentTextController.text),
    );
    // widget.comments.add(CommentModel(
    //     id: 'id',
    //     content: commentTextController.text,
    //     post: widget.postId,
    //     createdAt: DateTime.now()));
    commentTextController.clear();
    setState(() {});
  }

  Widget _buildCommentCard({
    required TwitterPostCommentEntity comment,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TwitterCommentCard(
          comment: comment,
          onCommentReact: widget.onCommentReact,
          // onCommentReact: ()=>context.read<TwitterCubit>().onCommentReact(params: TwitterCommentReactParams(commentId: comment.id,react: 'love')),
        ),
        if (comment.repliesCount != 0)
          Container(
              margin: const EdgeInsets.only(left: 30),
              child: TextAppButton(
                  label: 'show ${comment.repliesCount} replies',
                  onPressed: () {})
              // : ListView.builder(
              //     itemCount: 3,
              //     shrinkWrap: true,
              //     physics: const NeverScrollableScrollPhysics(),
              //     itemBuilder: (context, index) => CommentCard()),
              )
      ],
    );
  }
}
