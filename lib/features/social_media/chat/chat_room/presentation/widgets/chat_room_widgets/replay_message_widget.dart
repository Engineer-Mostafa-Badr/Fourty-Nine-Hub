import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/reply_message_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class ReplayMessageWidget extends StatelessWidget {
  final MessageEntity? messageEntity;
  final ReplyMessageEntity? replyMessage;
  final VoidCallback? onCancelReplay;
  final String? anotherUserName;

  const ReplayMessageWidget(
      {this.messageEntity,
      this.replyMessage,
      required this.anotherUserName,
      this.onCancelReplay,
      super.key});

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: anotherUserName == 'You'
                    ? AppColors.PRIMARY_COLOR
                    : AppColors.SECONDARY_COLOR,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(child: buildReplayMessage(context)),
          ],
        ),
      );

  Widget buildReplayMessage(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Label(
                text: anotherUserName ?? '',
                color: anotherUserName == 'You'
                    ? AppColors.PRIMARY_COLOR
                    : AppColors.SECONDARY_COLOR,
                // style: S,
              ),
              if (onCancelReplay != null)
                GestureDetector(
                  onTap: onCancelReplay,
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: context.isDarkMode ? Colors.black : Colors.white,
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 8.h,
          ),
          Label(
            text: messageEntity?.text ?? replyMessage?.text ?? '',
            color: Colors.black,
          ),
        ],
      );
}
