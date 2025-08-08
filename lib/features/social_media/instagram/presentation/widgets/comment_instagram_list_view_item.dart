import 'package:flutter/material.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/utils/format_numbers.dart';
import '../../domain/entities/comment_instagram_entity.dart';
import 'post_instagram_widget.dart';
import '../../../social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../helpers/manage_vibration.dart';

class CommentInstagramListViewItem extends StatelessWidget {
  const CommentInstagramListViewItem({
    super.key,
    required this.commentInstagram,
  });

  final CommentInstagramEntity commentInstagram;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ImageFromInternet(
          image: testImage,
          height: 46,
          width: 46,
          isCircle: true,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Label(
                    text: commentInstagram.username,
                    style: Styles.headerText(
                      fontSize: 32,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Label(
                    text: FormatDate()
                        .getRelativeTime(context, commentInstagram.createdAt),
                    style: Styles.headerText(
                      fontSize: 32,
                      color: Colors.black.withValues(alpha: 102),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 3,
              ),
              Label(
                text: commentInstagram.content,
                style: Styles.headerText(
                  fontSize: 28,
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              InkWell(
                onTap: () {

      ManageVibration.vibrate();
                },
                child: Label(
                  text: LocaleKeys.reply.localize,
                  style: Styles.headerText(
                    fontSize: 32,
                    color: Colors.black.withValues(alpha: 102),
                  ),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {

      ManageVibration.vibrate();
          },
        ),
      ],
    );
  }
}