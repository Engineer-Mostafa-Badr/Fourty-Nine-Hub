import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/PostOptions.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';

import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';

import '../../../../../../res/style/styles.dart';

class TwitterCommentCard extends StatefulWidget {
  final Color textColor;
  final TwitterPostCommentEntity comment;
  final GestureTapCallback? onCommentReact;
  final Function onCommentReply;
  const TwitterCommentCard(
      {super.key, this.textColor = Colors.black, required this.comment, this.onCommentReact, required this.onCommentReply});

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
                    text: widget.comment.user,
                    style: Styles.mediumText(
                        fontWeight: FontWeight.bold, color: widget.textColor)),
                Label(
                    text: widget.comment.sinceTime,
                    style: Styles.mediumText(color: widget.textColor)),
              ],
            )),
            IconButton(
                onPressed: () {
                  bottomSheet(context: context, widget: const PostOptions());
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
              onTap: widget.onCommentReact,
              child: Icon(
                Icons.favorite_border,
                color: widget.textColor,
              ),
            ),
            Label(
                text: widget.comment.loveCount.toString(),
                style: Styles.mediumText(color: widget.textColor)),
            const Sizer(),
            TextAppButton(
                style: Styles.mediumText(), label: 'Reply', onPressed: widget.onCommentReply)
          ],
        ),
      ],
    );
  }
}
