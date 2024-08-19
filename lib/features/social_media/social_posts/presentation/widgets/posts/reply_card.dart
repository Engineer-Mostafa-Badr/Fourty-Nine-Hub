import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/social_posts/domain/entities/comment_entity.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/build_reactions_buttons.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/usecases/twitter_report_usecase.dart';
import 'package:fourtyninehub/features/social_media/twitter/presentation/widgets/report_view.dart';
import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/styles.dart';

class ReplyCard extends StatefulWidget {
  final Color textColor;
  final CommentEntity reply;
  final Function(String) onReplyReact;
  final Function(String) onDeleteReply;
  final Function(TwitterReportParams) onReport;
  const ReplyCard({
    super.key,
    this.textColor = Colors.black,
    required this.reply,
    required this.onReplyReact,
    required this.onReport,
    required this.onDeleteReply,
  });

  @override
  State<ReplyCard> createState() => _ReplyCardState();
}

class _ReplyCardState extends State<ReplyCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ProfileImage(
              accountId: 0,
              withBorder: false,
              imageURL: widget.reply.user.image.isNotEmpty
                  ? widget.reply.user.image
                  : null,
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
                  widget.onDeleteReply(widget.reply.id);
                },
                child: Icon(
                  Icons.close,
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
            BuildReactionsButtons(post: widget.reply,
                from: 'comments',),
          ],
        ),
      ],
    );
  }
}
