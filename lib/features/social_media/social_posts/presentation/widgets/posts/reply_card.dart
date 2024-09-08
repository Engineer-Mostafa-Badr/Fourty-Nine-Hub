import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/form/text_fields/form_text_field.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/usecases/post_comment_usecase.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_reactions_buttons.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/user_image.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class ReplyCard extends StatefulWidget {
  final Color textColor;
  final CommentEntity reply;
  final Function(String) onReplyReact;
  final Function(String) onDeleteReply;
  final Function(PostCommentParams) onEditComment;
  final Function(TwitterReportParams) onReport;

  const ReplyCard({
    super.key,
    this.textColor = Colors.black,
    required this.reply,
    required this.onReplyReact,
    required this.onReport,
    required this.onDeleteReply,
    required this.onEditComment,
  });

  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  final editTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            UserProfileImage(
              accountId: 0,
              withBorder: false,
              imageURL: widget.reply.user.image.isNotEmpty
                  ? widget.reply.user.image
                  : null,
              userId: widget.reply.user.id,
            ),
            const Sizer(),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(
                    text: widget.reply.user.firstName,
                    style: Styles.mediumText(
                        fontWeight: FontWeight.bold, color: widget.textColor)),
                Label(
                    text: widget.reply.sinceTime,
                    style: Styles.mediumText(color: widget.textColor)),
              ],
            )),
            GestureDetector(
                onTap: () {
                  bottomSheet(
                      context: context,
                      widget: ReportView(
                        id: widget.reply.id,
                        categoryId: '66a3583454e6e337915514db',
                      ));
                },
                child: Icon(
                  Icons.more_vert,
                  color: widget.textColor,
                )),
            const Sizer(),
            GestureDetector(
                onTap: () {
                  widget.reply.edit = !widget.reply.edit!;
                  editTextController.text = widget.reply.content;
                  setState(() {});
                },
                child: Icon(
                  Icons.edit,
                  color: widget.textColor,
                  size: 20,
                )),
            const Sizer(),
            GestureDetector(
                onTap: () {
                  widget.onDeleteReply(widget.reply.id);
                },
                child: Icon(
                  Icons.close,
                  color: widget.textColor,
                )),
          ],
        ),
        const Sizer(),
        Text(
          widget.reply.content,
          style: Styles.mediumText(color: widget.textColor),
        ),
        if (widget.reply.edit == true)
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
                          postId: widget.reply.id,
                          content: editTextController.text));
                      if (result == true) {
                        widget.reply.content = editTextController.text;
                        widget.reply.edit = false;
                      }
                      setState(() {});
                    })
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BuildReactionsButtons(
              post: widget.reply,
              from: 'comments',
            ),
          ],
        ),
      ],
    );
  }
}
