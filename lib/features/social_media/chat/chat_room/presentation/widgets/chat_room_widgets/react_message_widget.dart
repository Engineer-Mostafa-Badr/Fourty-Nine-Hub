import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/res/style/styles.dart';

import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../res/style/app_colors.dart';

List<String> reacts = ['👍', '❤', '😢', '😡', '😮'];

class ReactMessageWidget extends StatelessWidget {
  const ReactMessageWidget({
    super.key,
    required this.child,
    required this.messageEntity,
    required this.width,
  });

  final Widget child;
  final MessageEntity messageEntity;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (messageEntity.isSelected)
          PositionedDirectional(
            start: messageEntity.byMe ? 1 : null,
            end: messageEntity.byMe ? null : 1,
            top: 0,
            child: Container(
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? AppColors.QUANTITY_COLOR
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.QUANTITY_COLOR,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              constraints: BoxConstraints(maxWidth: width * 0.55),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  reacts.length,
                  (index) => Label(
                    text: reacts[index],
                    style: Styles.headerText(),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
