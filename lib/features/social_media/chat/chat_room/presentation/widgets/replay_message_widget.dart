import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class ReplayMessageWidget extends StatelessWidget {
  final MessageEntity? messageEntity;
  final ReplyMessage? replyMessage;
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
            const SizedBox(
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
          const SizedBox(
            height: 8,
          ),
          Label(
            text: messageEntity?.text ?? replyMessage?.text ?? '',
          ),
        ],
      );
}
