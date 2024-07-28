import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/PostOptions.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_comment_reply_entity.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';

import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';

import '../../../../../../res/style/styles.dart';

class TwitterReplyCard extends StatefulWidget {
  final Color textColor;
  final TwitterCommentReplyEntity reply;
  final GestureTapCallback? onCommentReact;

  const TwitterReplyCard(
      {super.key, this.textColor = Colors.black, required this.reply, this.onCommentReact,});

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
                    text: 'Farouk Shahin',
                    style: Styles.mediumText(
                        fontWeight: FontWeight.bold, color: widget.textColor)),
                Label(
                    text: widget.reply.sinceTime,
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
          text: widget.reply.content,
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
                text: "${widget.reply.love.length}",
                style: Styles.mediumText(color: widget.textColor,),),
          ],
        ),
      ],
    );
  }
}
