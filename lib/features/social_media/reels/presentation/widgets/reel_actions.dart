import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/styles.dart';
import '../../../social/presentation/widgets/posts/post_comments.dart';
import '../../data/models/reel_model.dart';

class ReelActions extends StatelessWidget {
  final ReelModel item;
  const ReelActions({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconAppButton(
          icon: Icons.favorite_border,
          onPressed: () {},
          size: 24,
          color: Colors.white,
        ),
        Label(
            text: item.numberOfLikes.toString(),
            style: Styles.mediumText(color: Colors.white)),
        const Sizer(),
        IconAppButton(
          icon: Icons.comment,
          onPressed: () =>
              bottomSheet(context: context, widget: const PostComments()),
          size: 24,
          color: Colors.white,
        ),
        Label(
            text: item.numberOfComments.toString(),
            style: Styles.mediumText(color: Colors.white)),
        const Sizer(),
        IconAppButton(
          icon: Icons.bookmark_outline,
          onPressed: () {},
          size: 24,
          color: Colors.white,
        ),
        Label(
            text: item.numberOfSaves.toString(),
            style: Styles.mediumText(color: Colors.white)),
        const Sizer(),
        IconAppButton(
          icon: FontAwesomeIcons.share,
          onPressed: () {},
          size: 24,
          color: Colors.white,
        ),
        Label(
            text: item.numberOfExplores.toString(),
            style: Styles.mediumText(color: Colors.white)),
        const Sizer(),
        InkWell(
          onTap: () {
            context.push(Routes.MUSICREELS);
          },
          child: CircleAvatar(
            backgroundColor: Colors.blueGrey,
            child: Image.asset(
              Assets.coin,
              height: 20,
            ),
          ),
        ),
        const Sizer(),
      ],
    );
  }
}
