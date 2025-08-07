import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../common/widgets/stateless/labels/read_more_label.dart';
import '../../domain/entities/message_entity.dart';
import '../../../chat_view/presentation/chat_cubit/chats_cubit.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../res/style/const.dart';
import '../../../../../../res/style/styles.dart';

class MessageCard extends StatelessWidget {
  final MessageEntity messageEntity;
  final String anotherUserName;

  const MessageCard(
      {super.key, required this.messageEntity, required this.anotherUserName});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return messageEntity.byMe
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
        IntrinsicWidth(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: width * 0.9),
            child: Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                // color: AppColors.MESSAGE_COLOR,
                color: AppColors.MESSAGE_COLOR,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: messageEntity.isDeleted
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
                              ),
                            ],
                          )
                        : ReadMoreLabel(
                            trimLines: 5,
                            text: messageEntity.text,
                            style: Styles.mediumText(
                                color: AppColors.PRIMARY_COLOR),
                            textAlign: TextAlign.left,
                          ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      Label(
                        text: '$messageEntity',
                        style: Styles.smallText(color: AppColors.PRIMARY_COLOR),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        messageEntity.seen
                            ? FontAwesomeIcons.checkDouble
                            : messageEntity.delivered
                                ? FontAwesomeIcons.checkDouble
                                : FontAwesomeIcons.check,
                        color: Colors.red,
                        size: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
        CircleAvatar(
          radius: 15,
          backgroundColor: Colors.white,
          backgroundImage: NetworkImage(
              context.read<ChatsCubit>().selectedChat.isAdmin == "admin"
                  ? context.read<ChatsCubit>().selectedChat.avatar
                  : UIConst.profilePlaceHolder),
        ),
        const Sizer(width: 5),
        IntrinsicWidth(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: ReadMoreLabel(
                    trimLines: 5,
                    text: messageEntity.text,
                    style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(width: 8),
                Row(
                  children: [
                    Label(
                      text: '$messageEntity',
                      style: Styles.smallText(color: AppColors.PRIMARY_COLOR),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      messageEntity.seen
                          ? FontAwesomeIcons.checkDouble
                          : messageEntity.delivered
                              ? FontAwesomeIcons.checkDouble
                              : FontAwesomeIcons.check,
                      color: Colors.red,
                      size: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
