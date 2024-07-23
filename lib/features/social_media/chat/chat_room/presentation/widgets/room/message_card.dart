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
        ? _buildMineMessage(width: width,messageEntity: messageEntity)
        : _buildOtherMessage(width: width,messageEntity: messageEntity);
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
            children: [
              ReadMoreLabel(
                trimLines: 5,
                text: messageEntity.text!,
                style: Styles.mediumText(color: Colors.white),
                textAlign: TextAlign.left,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
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

  Widget _buildOtherMessage({required double width,required MessageEntity messageEntity,}) {
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
