import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../routes/routes.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => context.push(Routes.CHATROOM),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(UIConst.profilePlaceHolder),
            ),
            const Sizer(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(
                      text: 'Mohamed Gamal',
                      style: Styles.mediumText(fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          FontAwesomeIcons.checkDouble,
                          color: Colors.blue,
                          size: 10,
                        ),
                        Expanded(
                          child: Label(
                              text: 'تمام الله ينور يا احمد',
                              style: Styles.mediumText(color: Colors.grey)),
                        ),
                        const Icon(
                          Icons.volume_off,
                          color: Colors.grey,
                          size: 14,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Label(text: '5:57 PM', style: Styles.mediumText(color: Colors.grey))
          ],
        ),
      ),
    );
  }
}
