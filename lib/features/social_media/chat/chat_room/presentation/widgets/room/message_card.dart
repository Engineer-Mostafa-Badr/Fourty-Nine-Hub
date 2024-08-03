import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/ReadMoreLabel.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';

class MessageCard extends StatelessWidget {
  final MessageEntity messageEntity;

  const MessageCard({super.key, required this.messageEntity});

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: width / 1.5,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
              color: AppColors.PRIMARY_COLOR,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReadMoreLabel(
                trimLines: 5,
                text: messageEntity.text!,
                style: Styles.mediumText(color: Colors.white),
                textAlign: TextAlign.left,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Label(
                      text: '12', style: Styles.smallText(color: Colors.white)),
                  const Sizer(),
                  const Icon(
                    FontAwesomeIcons.eye,
                    color: Colors.white,
                    size: 10,
                  ),
                  const Sizer(),
                  Label(
                      text: '3:16 PM',
                      style: Styles.smallText(color: Colors.white)),
                  const Sizer(),
                  const Icon(
                    FontAwesomeIcons.checkDouble,
                    color: Colors.white,
                    size: 10,
                  ),
                ],
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
    return GestureDetector(
      onLongPress: () {
        _showReplyDialog(context, messageEntity.text ?? '');
      },
      child: Row(
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
      ),
    );
  }

  void _showReplyDialog(BuildContext context, String lastMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            insetPadding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            backgroundColor: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    color: AppColors.PRIMARY_COLOR.withOpacity(.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Label(
                      text: "${lastMessage}",
                      style: Styles.headerText(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                    margin: const EdgeInsets.only(right: 50),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      color: AppColors.PRIMARY_COLOR.withOpacity(.8),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Label(
                                text: "Replay",
                                style: Styles.headerText(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const Icon(
                                Icons.replay,
                                size: 30,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Label(
                                text: "Delete",
                                style: Styles.headerText(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const Icon(
                                Icons.delete,
                                size: 30,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
