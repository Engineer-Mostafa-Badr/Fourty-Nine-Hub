import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class ReplayMessageWidget extends StatelessWidget {
  final MessageEntity messageEntity;
  final VoidCallback? onCancelReplay;

  const ReplayMessageWidget(
      {required this.messageEntity, this.onCancelReplay, super.key});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 4,
            color: AppColors.PRIMARY_COLOR,
          ),
          Expanded(child: buildReplayMessage()),
        ],
      );

  Widget buildReplayMessage() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Label(
                text: messageEntity.chatId ?? '',
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
            text: messageEntity.text ?? '',
          ),
        ],
      );
}
