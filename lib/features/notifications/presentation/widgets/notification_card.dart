import 'package:flutter/material.dart';

import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/images/profile_image.dart';

import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/notifications/data/models/notification_model.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel item;
  const NotificationCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              const SizedBox(
                height: kToolbarHeight,
                width: kToolbarHeight,
                child: Stack(
                  children: [
                    Positioned(
                        top: 0,
                        left: 0,
                        child: ProfileImage(size: 25, accountId: 0)),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        radius: 12,
                        child: Icon(
                          Icons.comment,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Sizer(),
              Expanded(
                  child: Label(
                text: item.message,
                maxLines: 2,
              )),
            ],
          ),
          Label(
            text: '2 min',
            style: Styles.mediumText(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
