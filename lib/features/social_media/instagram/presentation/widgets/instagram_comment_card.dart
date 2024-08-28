import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/instagram/presentation/widgets/instagram_comment_replies.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/add_reply_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class InstagramCommentCard extends StatefulWidget {
  final Color textColor;
  final CommentEntity comment;
  final Function(ReplyOnCommentParams) onAddReply;

  final Function(PostCommentParams) onEditComment;
  final Function(String) onDeleteComment;

  final Function(String) onDeleteReply;
  const InstagramCommentCard({
    super.key,
    this.textColor = Colors.black,
    required this.comment,
    required this.onEditComment,
    required this.onDeleteComment,
    required this.onDeleteReply,
    required this.onAddReply,
  });

  @override
  State<InstagramCommentCard> createState() => _InstagramCommentCardState();
}

class _InstagramCommentCardState extends State<InstagramCommentCard> {
  final editTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserCubit>().state.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ProfileImage(
              accountId: 0,
              withBorder: false,
              imageURL: widget.comment.user.image.isNotEmpty
                  ? widget.comment.user.image
                  : null,
            ),
            const Sizer(),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                    text: widget.comment.user.firstName,
                    style: Styles.mediumText(
                        fontWeight: FontWeight.bold, color: widget.textColor)),
                Label(
                    text: widget.comment.sinceTime,
                    style: Styles.mediumText(color: widget.textColor)),
              ],
            )),
            IconButton(
                onPressed: () {
                  bottomSheet(
                      context: context,
                      widget: ReportView(
                        id: widget.comment.id,
                        categoryId: '66a3583454e6e337915514db',
                      ));
                },
                icon: Icon(
                  Icons.more_vert,
                  color: widget.textColor,
                )),
            if (user?.id == widget.comment.user.id) ...[
              // const Sizer(),
              GestureDetector(
                  onTap: () {
                    widget.comment.edit = !widget.comment.edit!;
                    editTextController.text = widget.comment.content;
                    setState(() {});
                  },
                  child: Icon(
                    Icons.edit,
                    color: widget.textColor,
                    size: 20,
                  )),
              const Sizer()
            ],
            GestureDetector(
                onTap: () {
                  widget.onDeleteComment(widget.comment.id);
                },
                child: Icon(
                  Icons.close,
                  color: widget.textColor,
                  size: 20,
                ))
          ],
        ),
        const Sizer(),
        Label(
          textAlign: TextAlign.start,
          text: widget.comment.content,
          style: Styles.mediumText(color: widget.textColor),
        ),
        if (widget.comment.edit == true)
          Row(
            children: [
              Expanded(
                  child: FormTextField(
                      hint: 'Type your comment ....',
                      action: (v) {
                        setState(() {});
                      },
                      controller: editTextController)),
              const Sizer(),
              if (editTextController.text.isNotEmpty)
                IconAppButton(
                  icon: Icons.send,
                  isCircle: true,
                  onPressed: () async {
                    var result = await widget.onEditComment(PostCommentParams(
                        postId: widget.comment.id,
                        content: editTextController.text));
                    if (result == true) {
                      widget.comment.content = editTextController.text;
                      widget.comment.edit = false;
                    }
                    setState(() {});
                  },
                ),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                if (widget.comment.isLove == true) {
                  // widget.onCommentReact();
                  widget.comment.isLove = false;
                  widget.comment.loveCount = (widget.comment.loveCount! - 1);
                  setState(() {});
                } else {
                  print("object");
                  // widget.onCommentReact();
                  widget.comment.isLove = true;
                  widget.comment.loveCount = widget.comment.loveCount! + 1;
                  setState(() {});
                }
              },
              child: Icon(
                widget.comment.isLove == false
                    ? Icons.favorite_border
                    : Icons.favorite,
                color:
                    widget.comment.isLove == false ? Colors.grey : Colors.red,
              ),
            ),
            Label(text: '${widget.comment.loveCount}'),
            const Sizer(),
            TextAppButton(
                style: Styles.mediumText(),
                label: 'Reply',
                onPressed: () {
                  bottomSheet(
                      context: context,
                      isScrollControlled: true,
                      widget: InstagramCommentReplies(
                        postId: widget.comment.post,
                        commentId: widget.comment.id,
                        onAddReply: (ReplyOnCommentParams params) =>
                            widget.onAddReply(params),
                        onEditComment: (PostCommentParams params) =>
                            widget.onEditComment(params),
                        onDeleteReply: (String id) => widget.onDeleteReply(id),
                      ));
                })
          ],
        ),
      ],
    );
  }
}
