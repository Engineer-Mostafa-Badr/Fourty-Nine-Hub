import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/reply_message_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              color: AppColors.PRIMARY_COLOR,
            ),
            SizedBox(
              width: 8,
            ),
            Expanded(child: buildReplayMessage()),
          ],
        ),
      );

  Widget buildReplayMessage() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Label(
                text: anotherUserName ?? '',
              ),
              if (onCancelReplay != null)
                GestureDetector(
                  onTap: onCancelReplay,
                  child: const Icon(
                    Icons.close,
                    size: 16,
                  ),
                ),
            ],
          ),
          SizedBox(
            height: 8.h,
          ),
          Label(
            text: messageEntity?.text ?? replyMessage?.text ?? '',
          ),
        ],
      );
}
