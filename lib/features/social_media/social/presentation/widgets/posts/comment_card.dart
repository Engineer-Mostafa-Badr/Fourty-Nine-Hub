import 'package:flutter/material.dart';

import '../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/buttons/text_button.dart';
import '../../../../../../common/widgets/stateless/images/profile_image.dart';
import '../../../../../../common/widgets/stateless/labels/ReadMoreLabel.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../res/style/styles.dart';
import 'PostOptions.dart';

class CommentCard extends StatelessWidget{
  @override
  Widget build(BuildContext context) { return Column(
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
                    style: Styles.mediumText(fontWeight: FontWeight.bold)),
                Label(text: '9  min', style: Styles.mediumText()),
              ],
            )),
            IconButton(
                onPressed: () {
                  bottomSheet(context: context, widget: const PostOptions());
                },
                icon: const Icon(Icons.more_vert)),
          ],
        ),
        const Sizer(),
        const ReadMoreLabel(text: UIConst.placeholderText),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.favorite_border),
            Label(text: '1,024', style: Styles.mediumText()),
            const Sizer(),
            TextAppButton(
                style: Styles.mediumText(), label: 'Reply', onPressed: () {})
          ],
        ),
      ],
    );
 
  }

}