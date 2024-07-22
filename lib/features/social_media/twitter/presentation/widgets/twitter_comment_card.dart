import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/posts/PostOptions.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_comment_entity.dart';

import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/ReadMoreLabel.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';

import '../../../../../../res/style/styles.dart';

class TwitterCommentCard extends StatelessWidget {
  final Color textColor;
  final TwitterPostCommentEntity comment;
  final GestureTapCallback? onCommentReact;
  const TwitterCommentCard(
      {super.key, this.textColor = Colors.black, required this.comment, this.onCommentReact});

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
                        fontWeight: FontWeight.bold, color: textColor)),
                Label(
                    text: comment.sinceTime,
                    style: Styles.mediumText(color: textColor)),
              ],
            )),
            IconButton(
                onPressed: () {
                  bottomSheet(context: context, widget: const PostOptions());
                },
                icon: Icon(
                  Icons.more_vert,
                  color: textColor,
                )),
          ],
        ),
        const Sizer(),
        Label(
          textAlign: TextAlign.start,
          text: comment.content,
          style: Styles.mediumText(color: textColor),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: onCommentReact,
              child: Icon(
                Icons.favorite_border,
                color: textColor,
              ),
            ),
            Label(
                text: comment.loveCount.toString(),
                style: Styles.mediumText(color: textColor)),
            const Sizer(),
            TextAppButton(
                style: Styles.mediumText(), label: 'Reply', onPressed: () {})
          ],
        ),
      ],
    );
  }
}
