import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class CallingCard extends StatelessWidget {
  final bool isVideo;
  const CallingCard({super.key, required this.isVideo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => context.push(Routes.CHATROOM),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(UIConst.profilePlaceHolder),
            ),
            Sizer(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(
                      text: 'Mohamed Gamal',
                      style: Styles.mediumText(fontWeight: FontWeight.bold)),
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.call_received,
                          color: Colors.red,
                          size: 10,
                        ),
                        Sizer(),
                        Expanded(
                          child: Label(
                              text: 'May 21,6:50 PM',
                              style: Styles.mediumText(color: Colors.grey)),
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
