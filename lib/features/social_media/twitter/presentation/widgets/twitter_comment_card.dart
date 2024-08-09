import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class TwitterCommentCard extends StatefulWidget {
  final Color textColor;
  final TwitterPostCommentEntity comment;
  final Function onCommentReact;
  final Function onCommentReply;
  final Function(TwitterReportParams) onReport;
  const TwitterCommentCard(
      {super.key,
      this.textColor = Colors.black,
      required this.comment,
      required this.onCommentReact,
      required this.onCommentReply,
      required this.onReport});

  @override
  State<TwitterCommentCard> createState() => _TwitterCommentCardState();
}

class _TwitterCommentCardState extends State<TwitterCommentCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            widget.comment.user.image==''? const ProfileImage(
              accountId: 0,
              withBorder: false,
            ):ProfileImage(
              accountId: 0,
              imageURL: widget.comment.user.image,
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
                        id: widget.comment.id, categoryId: '',
                      ));
                },
                icon: Icon(
                  Icons.more_vert,
                  color: widget.textColor,
                )),
          ],
        ),
        const Sizer(),
        Label(
          textAlign: TextAlign.start,
          text: widget.comment.content,
          style: Styles.mediumText(color: widget.textColor),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                if (widget.comment.isReact == true) {
                  widget.onCommentReact();
                  widget.comment.loveCount = (widget.comment.loveCount! - 1);
                  setState(() {});
                } else {
                  widget.onCommentReact();
                  widget.comment.loveCount = widget.comment.loveCount! + 1;
                  setState(() {});
                }
              },
              child: Icon(
                widget.comment.isReact == false
                    ? Icons.favorite_border
                    : Icons.favorite,
                color:
                    widget.comment.isReact == false ? Colors.grey : Colors.red,
              ),
            ),
            Label(
                text: widget.comment.loveCount.toString(),
                style: Styles.mediumText(color: widget.textColor)),
            const Sizer(),
            TextAppButton(
                style: Styles.mediumText(),
                label: 'Reply',
                onPressed: widget.onCommentReply)
          ],
        ),
      ],
    );
  }
}
