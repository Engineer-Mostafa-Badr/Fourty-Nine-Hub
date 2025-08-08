import 'package:flutter/material.dart';
import '../../../../../../common/widgets/dialogs/soon_dialog.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../res/style/styles.dart';

class CallingCard extends StatelessWidget {
  final bool isVideo;

  const CallingCard({super.key, required this.isVideo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => soonDialog(context),
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
                    style: Styles.mediumText(
                        fontWeight: FontWeight.bold,
                        color:
                            context.isDarkMode ? Colors.white : Colors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.call_received,
                          color: Colors.red,
                          size: 10,
                        ),
                        const Sizer(),
                        Expanded(
                          child: Label(
                              text: 'May 21,6:50 PM',
                              style: Styles.smallText(color: Colors.grey)),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Icon(isVideo ? Icons.video_call : Icons.call),
          ],
        ),
      ),
    );
  }
}
