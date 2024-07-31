import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class TwitterReplyCard extends StatefulWidget {
  final Color textColor;
  final TwitterCommentReplyEntity reply;
  final Function(String) onReplyReact;
  final Function(TwitterReportParams) onReport;
  const TwitterReplyCard({
    super.key,
    this.textColor = Colors.black,
    required this.reply,
    required this.onReplyReact,
    required this.onReport,
  });

  @override
  State<TwitterReplyCard> createState() => _TwitterReplyCardState();
}

class _TwitterReplyCardState extends State<TwitterReplyCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const ProfileImage(
              accountId: 0,
              withBorder: false,
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
            IconButton(
                onPressed: () {
                  bottomSheet(
                      context: context,
                      widget: ReportView(
                        id: widget.reply.id,

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
          text: widget.reply.content,
          style: Styles.mediumText(color: widget.textColor),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                if (widget.reply.isReact == true) {
                  widget.onReplyReact(widget.reply.id);
                  widget.reply.loveCount = (widget.reply.loveCount! - 1);
                  setState(() {});
                } else {
                  widget.onReplyReact(widget.reply.id);
                  widget.reply.loveCount = (widget.reply.loveCount! + 1);
                  setState(() {});
                }
              },
              child: Icon(
                widget.reply.isReact == false
                    ? Icons.favorite_border
                    : Icons.favorite,
                color: widget.reply.isReact == false ? Colors.grey : Colors.red,
              ),
            ),
            Label(
              text: "${widget.reply.loveCount}",
              style: Styles.mediumText(
                color: widget.textColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
