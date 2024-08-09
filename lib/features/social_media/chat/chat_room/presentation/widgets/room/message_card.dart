import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/read_more_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/room/replay_message_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class MessageCard extends StatelessWidget {
  final MessageEntity messageEntity;
  final String anotherUserName;

  const MessageCard(
      {super.key, required this.messageEntity, required this.anotherUserName});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return messageEntity.byMe!
        ? _buildMineMessage(width: width, messageEntity: messageEntity)
        : _buildOtherMessage(
            width: width, messageEntity: messageEntity, context: context);
  }

  Widget _buildMineMessage({
    required double width,
    required MessageEntity messageEntity,
  }) {
    Widget messageWidget;

    final firstMessage = Container(
      padding: const EdgeInsets.only(left: 5, top: 5),
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: messageEntity.isDeleted!
          ? Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.not_interested,
                    color: Colors.black54,
                  ),
                ),
                Label(
                  text: "This message is deleted",
                  style: Styles.mediumText(color: Colors.black54),
                )
              ],
            )
          : ReadMoreLabel(
              trimLines: 5,
              text: messageEntity.text!,
              style: Styles.mediumText(color: Colors.black),
              textAlign: TextAlign.left,
            ),
    );

    if (!messageEntity.isReply!) {
      messageWidget = firstMessage;
    } else {
      messageWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(5),
                  topLeft: Radius.circular(5),
                )),
            // color: Colors.grey[400],
            child: ReplayMessageWidget(
              replyMessage: messageEntity.replyMessageId,
              anotherUserName: anotherUserName,
            ),
          ),
          firstMessage,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: width / 1.5,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: AppColors.GREY_LIGHT_COLOR,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10))),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              messageWidget,
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                  ),
                  color: Colors.white,
                ),
                child: messageEntity.isDeleted!
                    ? const SizedBox(
                        height: 5,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Label(
                              text: '12',
                              style: Styles.smallText(color: Colors.black)),
                          const Sizer(),
                          const Icon(
                            FontAwesomeIcons.eye,
                            color: Colors.black,
                            size: 10,
                          ),
                          const Sizer(),
                          Label(
                              text: '3:16 PM',
                              style: Styles.smallText(color: Colors.black)),
                          const Sizer(),
                          const Icon(
                            FontAwesomeIcons.checkDouble,
                            color: Colors.black,
                            size: 10,
                          ),
                        ],
                      ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOtherMessage({
    required double width,
    required MessageEntity messageEntity,
    required BuildContext context,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const CircleAvatar(
          radius: 15,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(UIConst.profilePlaceHolder),
        ),
        const Sizer(
          width: 5,
        ),
        Container(
          width: width / 1.5,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReadMoreLabel(
                trimLines: 5,
                text: messageEntity.text!,
                style: Styles.mediumText(),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
