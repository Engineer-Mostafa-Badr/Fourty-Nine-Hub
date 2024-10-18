// Nasr

import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/read_more_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/file_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/show_image_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/chat_room_widgets/recived_file.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/chat_room_widgets/send_file.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/widgets_contacts/send_contacts.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../widgets_contacts/recived_contacts.dart';

class MessageCard extends StatelessWidget {
  final MessageEntity messageEntity;
  final String anotherUserName;

  const MessageCard(
      {super.key, required this.messageEntity, required this.anotherUserName});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isArabic = LocaleKeys.more.tr() == "More";
    final chatRoomCubit = context.read<ChatRoomCubit>();

    return messageEntity.byMe
        ? messageEntity.sharedContacts.isNotEmpty
            ? SentContactsCard(messageEntity: messageEntity)
            : messageEntity.media.isEmpty
                ? _buildMineMessage(
                    width: width,
                    messageEntity: messageEntity,
                    context: context)
                : messageEntity.media[0].type == FileTypeEnum.document
                    ? SentFileCard(
                        messageEntity: messageEntity,
                      )
                    : messageEntity.media[0].type == FileTypeEnum.audio
                        ? VoiceMessageCard(
                            messageEntity: messageEntity,
                            isSend: true,
                          )
                        : _buildSendMediaCard(
                            isArabic: isArabic,
                            chatRoomCubit: chatRoomCubit,
                            context: context,
                            width: width,
                          )
        : messageEntity.sharedContacts.isNotEmpty
            ? ReceivedContactsCard(messageEntity: messageEntity)
            : messageEntity.media.isEmpty
                ? _buildOtherMessage(
                    width: width,
                    messageEntity: messageEntity,
                    context: context)
                : messageEntity.media[0].type == FileTypeEnum.document
                    ? ReceivedFileCard(
                        messageEntity: messageEntity,
                      )
                    : messageEntity.media[0].type == FileTypeEnum.audio
                        ? VoiceMessageCard(
                            messageEntity: messageEntity,
                            isSend: false,
                          )
                        : _buildReceiveMediaCard(
                            isArabic: isArabic,
                            chatRoomCubit: chatRoomCubit,
                            context: context,
                            width: width,
                          );
  }

  SwipeTo _buildSendMediaCard(
      {required bool isArabic,
      required ChatRoomCubit chatRoomCubit,
      required BuildContext context,
      required double width}) {
    return SwipeTo(
      onRightSwipe: !isArabic
          ? null
          : (details) {
              chatRoomCubit.selectMessageForReplaying(messageEntity);
            },
      onLeftSwipe: isArabic
          ? null
          : (details) {
              chatRoomCubit.selectMessageForReplaying(messageEntity);
            },
      child: Padding(
        padding: EdgeInsets.only(
          left: isArabic ? 60 : 8,
          top: 6,
          bottom: 6,
          right: isArabic ? 8 : 60,
        ),
        child: Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              messageEntity.hasReply
                  ? ReplySendMessageCard(
                      width: width, messageEntity: messageEntity)
                  : const SizedBox(),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.MESSAGE_COLOR,
                  borderRadius: BorderRadius.only(
                    topLeft: messageEntity.hasReply
                        ? const Radius.circular(0)
                        : const Radius.circular(12),
                    topRight: messageEntity.hasReply
                        ? const Radius.circular(0)
                        : const Radius.circular(12),
                    bottomLeft: isArabic
                        ? const Radius.circular(12)
                        : const Radius.circular(0),
                    bottomRight: isArabic
                        ? const Radius.circular(0)
                        : const Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 0.1,
                      blurRadius: 5,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: _buildMediaGridCard(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SwipeTo _buildReceiveMediaCard(
      {required bool isArabic,
      required ChatRoomCubit chatRoomCubit,
      required BuildContext context,
      required double width}) {
    return SwipeTo(
      onRightSwipe: !isArabic
          ? null
          : (details) {
              chatRoomCubit.selectMessageForReplaying(messageEntity);
            },
      onLeftSwipe: isArabic
          ? null
          : (details) {
              chatRoomCubit.selectMessageForReplaying(messageEntity);
            },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(
            width: 8,
          ),
          const CircleAvatar(
            radius: 15,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(UIConst.profilePlaceHolder),
          ),
          const Sizer(width: 5),
          Padding(
            padding: const EdgeInsets.only(
              // left: 8,
              top: 6,
              bottom: 6,
              // right: 60,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: messageEntity.hasReply
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  topRight: messageEntity.hasReply
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomLeft: isArabic
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: isArabic
                      ? const Radius.circular(12)
                      : const Radius.circular(0),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              width: MediaQuery.of(context).size.width * 0.72,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  messageEntity.hasReply
                      ? ReplyRecivedMessageCard(
                          width: width, messageEntity: messageEntity)
                      : const SizedBox(),
                  _buildMediaGridCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildMediaGridCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Conditional Layout for Images based on count
          if (messageEntity.media.length == 1)
            OneMediaCard(messageEntity: messageEntity),
          if (messageEntity.media.length == 2)
            TowMediaCard(messageEntity: messageEntity),
          if (messageEntity.media.length == 3)
            ThreeMediaCard(messageEntity: messageEntity),
          if (messageEntity.media.length >= 4)
            FourOrMoreMediaCard(messageEntity: messageEntity),
          const SizedBox(height: 6),
          ReadMoreLabel(
            // trimLines: 5,
            text: messageEntity.text,
            style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
            textAlign: TextAlign.left,
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Label(
                text: messageEntity.time,
                style: Styles.smallText(color: AppColors.PRIMARY_COLOR),
              ),
              const SizedBox(width: 4),
              Icon(
                _getMessageIcon(messageEntity),
                color: _getMessageIconColor(messageEntity),
                size: 12,
              ),
            ],
          ),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.end,
          //   children: [
          //     ConstrainedBox(
          //       constraints: BoxConstraints(
          //         maxWidth: MediaQuery.of(context).size.width * 0.6,
          //       ),
          //       child: Text(
          //         messageEntity.text,
          //         style: Styles.mediumText(
          //           color: AppColors.PRIMARY_COLOR,
          //         ),
          //         textAlign: TextAlign.left,
          //       ),
          //     ),
          //     const Spacer(),
          //     Label(
          //       text: messageEntity.time,
          //       style: Styles.smallText(color: AppColors.PRIMARY_COLOR),
          //     ),
          //     const SizedBox(width: 4),
          //     messageEntity.byMe
          //         ? Icon(
          //             _getMessageIcon(messageEntity),
          //             color: _getMessageIconColor(messageEntity),
          //             size: 12,
          //           )
          //         : const SizedBox(width: 4),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildMineMessage({
    required double width,
    required MessageEntity messageEntity,
    required BuildContext context,
  }) {
    final chatRoomCubit = context.read<ChatRoomCubit>();
    final isArabic = LocaleKeys.more.tr() == "More";
    return SwipeTo(
      onRightSwipe: !isArabic
          ? null
          : (details) {
              chatRoomCubit.selectMessageForReplaying(messageEntity);
            },
      onLeftSwipe: isArabic
          ? null
          : (details) {
              chatRoomCubit.selectMessageForReplaying(messageEntity);
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IntrinsicWidth(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width * 0.85),
                child: Column(
                  children: [
                    messageEntity.hasReply
                        ? ReplySendMessageCard(
                            width: width, messageEntity: messageEntity)
                        : const SizedBox(),
                    _buildSendTextMessage(messageEntity, isArabic),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildSendTextMessage(MessageEntity messageEntity, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(12),
      // margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.MESSAGE_COLOR,
        borderRadius: BorderRadius.only(
          topLeft: messageEntity.hasReply
              ? const Radius.circular(0)
              : const Radius.circular(12),
          topRight: messageEntity.hasReply
              ? const Radius.circular(0)
              : const Radius.circular(12),
          bottomLeft:
              isArabic ? const Radius.circular(12) : const Radius.circular(0),
          bottomRight:
              isArabic ? const Radius.circular(0) : const Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 4),
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
                    // trimLines: 5,
                    text: messageEntity.text,
                    style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
                    textAlign: TextAlign.left,
                  ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              Label(
                text: messageEntity.time,
                style: Styles.smallText(color: AppColors.PRIMARY_COLOR),
              ),
              const SizedBox(width: 4),
              Icon(
                _getMessageIcon(messageEntity),
                color: _getMessageIconColor(messageEntity),
                size: 12,
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getMessageIcon(MessageEntity messageEntity) {
    if (messageEntity.seen) {
      return FontAwesomeIcons.checkDouble;
    } else if (messageEntity.delivered) {
      return FontAwesomeIcons.checkDouble;
    } else {
      return FontAwesomeIcons.check;
    }
  }

  Color _getMessageIconColor(MessageEntity messageEntity) {
    if (messageEntity.seen) {
      return Colors.red;
    } else if (messageEntity.delivered) {
      return Colors.grey;
    } else {
      return Colors.grey;
    }
  }

  Widget _buildOtherMessage({
    required double width,
    required MessageEntity messageEntity,
    required BuildContext context,
  }) {
    final chatRoomCubit = context.read<ChatRoomCubit>();
    final isArabic = LocaleKeys.more.tr() == "More";
    return SwipeTo(
      onRightSwipe: !isArabic
          ? null
          : (details) {
              chatRoomCubit.selectMessageForReplaying(messageEntity);
            },
      onLeftSwipe: isArabic
          ? null
          : (details) {
              chatRoomCubit.selectMessageForReplaying(messageEntity);
            },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(UIConst.profilePlaceHolder),
            ),
            const Sizer(width: 5),
            IntrinsicWidth(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width * 0.65),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    messageEntity.hasReply
                        ? ReplyRecivedMessageCard(
                            width: width,
                            messageEntity: messageEntity,
                          )
                        : const SizedBox(),
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: messageEntity.hasReply
                              ? const Radius.circular(0)
                              : const Radius.circular(12),
                          topRight: messageEntity.hasReply
                              ? const Radius.circular(0)
                              : const Radius.circular(12),
                          bottomLeft: isArabic
                              ? const Radius.circular(0)
                              : const Radius.circular(12),
                          bottomRight: isArabic
                              ? const Radius.circular(12)
                              : const Radius.circular(0),
                        ),
                        boxShadow: const [
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
                              // trimLines: 5,
                              text: messageEntity.text,
                              style: Styles.mediumText(
                                color: AppColors.PRIMARY_COLOR,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Label(
                            text: messageEntity.time,
                            style: Styles.smallText(
                                color: AppColors.PRIMARY_COLOR),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VoiceMessageCard extends StatelessWidget {
  const VoiceMessageCard({
    super.key,
    required this.messageEntity,
    required this.isSend,
  });

  final MessageEntity messageEntity;
  final bool isSend;

  @override
  Widget build(BuildContext context) {
    final chatRoomCubit = context.read<ChatRoomCubit>();
    final isArabic = LocaleKeys.more.tr() == "More";
    return SwipeTo(
      onRightSwipe: !isArabic
          ? null
          : (details) {
              chatRoomCubit.selectMessageForReplaying(messageEntity);
            },
      onLeftSwipe: isArabic
          ? null
          : (details) {
              chatRoomCubit.selectMessageForReplaying(messageEntity);
            },
      child: Padding(
        padding: const EdgeInsets.only(
          right: 8,
          bottom: 6,
          top: 6,
          left: 8,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment:
              isSend ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            isSend
                ? const SizedBox()
                : const CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(UIConst.profilePlaceHolder),
                  ),
            isSend ? const SizedBox() : const Sizer(width: 5),
            Container(
              width: MediaQuery.of(context).size.width * 0.65,
              decoration: BoxDecoration(
                color: isSend
                    ? AppColors.MESSAGE_COLOR
                    : AppColors.BACKGROUND_COLOR,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  messageEntity.hasReply
                      ? isSend
                          ? ReplySendMessageCard(
                              width: MediaQuery.of(context).size.width * 0.65,
                              messageEntity: messageEntity)
                          : ReplyRecivedMessageCard(
                              messageEntity: messageEntity,
                              width: MediaQuery.of(context).size.width * 0.65,
                            )
                      : const SizedBox(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.65,
                    child: Stack(
                      children: [
                        VoiceMessageView(
                          activeSliderColor: AppColors.PRIMARY_COLOR,
                          circlesColor: AppColors.PRIMARY_COLOR,
                          notActiveSliderColor: isSend
                              ? AppColors.MESSAGE_COLOR
                              : AppColors.BACKGROUND_COLOR,
                          backgroundColor: isSend
                              ? AppColors.MESSAGE_COLOR
                              : AppColors.BACKGROUND_COLOR,
                          innerPadding: 12,
                          cornerRadius: 12,
                          // notActiveSliderColor:
                          //     AppColors.PRIMARY_COLOR.withOpacity(0.1),
                          // size: ,
                          controller: VoiceController(
                            audioSrc: messageEntity.media[0].url,
                            maxDuration: const Duration(minutes: 1000),
                            // cacheKey: messageEntity.media[0].url,
                            isFile: false,
                            onComplete: () {},
                            onPause: () {},
                            onPlaying: () {},
                            onError: (p0) {},
                          ),
                        ),
                        const Divider(
                          color: AppColors.LIGHT_GRAY_COLOR2,
                          height: 70,
                          indent: 70,
                          endIndent: 90,
                          // thickness: 2,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Label(
                          text: messageEntity.time,
                          style:
                              Styles.smallText(color: AppColors.PRIMARY_COLOR),
                        ),
                        isSend ? const SizedBox(width: 4) : const SizedBox(),
                        isSend
                            ? Icon(
                                _getMessageIcon(messageEntity),
                                color: _getMessageIconColor(messageEntity),
                                size: 12,
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getMessageIcon(MessageEntity messageEntity) {
    if (messageEntity.seen) {
      return FontAwesomeIcons.checkDouble;
    } else if (messageEntity.delivered) {
      return FontAwesomeIcons.checkDouble;
    } else {
      return FontAwesomeIcons.check;
    }
  }

  Color _getMessageIconColor(MessageEntity messageEntity) {
    if (messageEntity.seen) {
      return Colors.red;
    } else if (messageEntity.delivered) {
      return Colors.grey;
    } else {
      return Colors.grey;
    }
  }
}

class ReplyRecivedMessageCard extends StatelessWidget {
  const ReplyRecivedMessageCard({
    super.key,
    required this.width,
    required this.messageEntity,
  });
  final double width;
  final MessageEntity messageEntity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      height: 60,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      child: Container(
        margin: const EdgeInsets.only(
          top: 8,
          left: 8,
          right: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.DARK_GRAY_COLOR.withOpacity(0.4),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.all(0),
              padding: const EdgeInsets.all(0),
              width: 10,
              decoration: const BoxDecoration(
                color: AppColors.PRIMARY_COLOR,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(12),
                ),
              ),
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: width * 0.4,
                    ),
                    child: Text(
                      messageEntity.reply!.sender.name,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mediumText(
                          color: AppColors.PRIMARY_COLOR,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: width * 0.4,
                      maxHeight: 20,
                    ),
                    child: Text(
                      messageEntity.reply!.text == ""
                          ? messageEntity.reply!.media.isNotEmpty
                              ? messageEntity.reply!.media[0].type ==
                                      FileTypeEnum.image
                                  ? LocaleKeys.photo.tr()
                                  : messageEntity.reply!.media[0].fileName ??
                                      LocaleKeys.file.tr()
                              : messageEntity.reply!.text
                          : messageEntity.reply!.text,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mediumText(
                        color: AppColors.DARK_GRAY_COLOR,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            messageEntity.reply!.media.isNotEmpty
                ? messageEntity.reply!.media[0].type == FileTypeEnum.image
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: messageEntity.reply!.media.first.url,
                          fit: BoxFit.cover,
                          width: 50,
                          height: double.infinity,
                        ),
                      )
                    : const Icon(
                        Icons.insert_drive_file,
                        size: 30,
                        color: AppColors.GREY_DARK_COLOR,
                      )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class ReplySendMessageCard extends StatelessWidget {
  const ReplySendMessageCard({
    super.key,
    required this.width,
    required this.messageEntity,
  });

  final double width;
  final MessageEntity messageEntity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.MESSAGE_COLOR,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      height: 60,
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      child: Container(
        margin: const EdgeInsets.only(
          top: 8,
          left: 8,
          right: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.DARK_GRAY_COLOR.withOpacity(0.4),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 0),
              padding: const EdgeInsets.all(0),
              width: 10,
              decoration: const BoxDecoration(
                color: AppColors.PRIMARY_COLOR,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(12),
                  bottomLeft: Radius.circular(100),
                  bottomRight: Radius.circular(12),
                ),
              ),
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: width * 0.5,
                    ),
                    child: Text(
                      messageEntity.reply!.sender.name,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mediumText(
                          color: AppColors.PRIMARY_COLOR,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: width * 0.5,
                      maxHeight: 20,
                    ),
                    child: Text(
                      messageEntity.reply!.text == ""
                          ? messageEntity.reply!.media.isNotEmpty
                              ? messageEntity.reply!.media[0].type ==
                                      FileTypeEnum.image
                                  ? LocaleKeys.photo.tr()
                                  : messageEntity.reply!.media[0].fileName ??
                                      LocaleKeys.file.tr()
                              : messageEntity.reply!.text
                          : messageEntity.reply!.text,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mediumText(
                        color: AppColors.DARK_GRAY_COLOR,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            messageEntity.reply!.media.isNotEmpty
                ? messageEntity.reply!.media[0].type == FileTypeEnum.image
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: messageEntity.reply!.media.first.url,
                          fit: BoxFit.cover,
                          width: 50,
                          height: double.infinity,
                        ),
                      )
                    : const Icon(
                        Icons.insert_drive_file,
                        size: 40,
                        color: AppColors.GREY_DARK_COLOR,
                      )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class FourOrMoreMediaCard extends StatelessWidget {
  const FourOrMoreMediaCard({
    super.key,
    required this.messageEntity,
  });

  final MessageEntity messageEntity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 4.0,
            crossAxisSpacing: 4.0,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            if (index < 4) {
              if (messageEntity.media[index].type == FileTypeEnum.video) {
                return Expanded(
                  child: CustomVideoCard(
                    index: index,
                    messageEntity: messageEntity,
                    videoUrl: messageEntity.media[index].url,
                    height: null,
                  ),
                );
              } else {
                return CustomChachedNetworkImage(
                  messageEntity: messageEntity,
                  index: index,
                );
              }
            }
            return null;
          },
        ),
        if (messageEntity.media.length > 4)
          Positioned(
            bottom: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                context.push(Routes.SHOWIMAGEVIEW, extra: messageEntity);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    '+${messageEntity.media.length - 4}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class ThreeMediaCard extends StatelessWidget {
  const ThreeMediaCard({
    super.key,
    required this.messageEntity,
  });

  final MessageEntity messageEntity;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        messageEntity.media[0].type == FileTypeEnum.video
            ? CustomVideoCard(
                index: 0,
                messageEntity: messageEntity,
                videoUrl: messageEntity.media[0].url,
                height: MediaQuery.of(context).size.height * 0.2,
              )
            : CustomChachedNetworkImage(
                messageEntity: messageEntity,
                index: 0,
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
              ),
        Row(
          children: messageEntity.media.sublist(1).map((media) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: media.type == FileTypeEnum.video
                      ? CustomVideoCard(
                          messageEntity: messageEntity,
                          videoUrl: media.url,
                          index: messageEntity.media.indexOf(media),
                          height: MediaQuery.of(context).size.height * 0.2,
                        )
                      : CustomChachedNetworkImage(
                          messageEntity: messageEntity,
                          index: messageEntity.media.indexOf(media),
                          height: MediaQuery.of(context).size.height * 0.2,
                        ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class TowMediaCard extends StatelessWidget {
  const TowMediaCard({
    super.key,
    required this.messageEntity,
  });

  final MessageEntity messageEntity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: messageEntity.media.map((media) {
        if (media.type == FileTypeEnum.video) {
          return Expanded(
            child: CustomVideoCard(
              index: messageEntity.media.indexOf(media),
              messageEntity: messageEntity,
              videoUrl: media.url,
              height: MediaQuery.of(context).size.height * 0.3,
            ),
          );
        } else {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: CustomChachedNetworkImage(
                messageEntity: messageEntity,
                index: messageEntity.media.indexOf(media),
                height: MediaQuery.of(context).size.height * 0.3,
              ),
            ),
          );
        }
      }).toList(),
    );
  }
}

generateThumbnaill({required String videoUrl}) async {
  return await VideoThumbnail.thumbnailData(
    video: videoUrl,
  );
}

class OneMediaCard extends StatefulWidget {
  const OneMediaCard({
    super.key,
    required this.messageEntity,
  });

  final MessageEntity messageEntity;

  @override
  State<OneMediaCard> createState() => _OneMediaCardState();
}

class _OneMediaCardState extends State<OneMediaCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.messageEntity.media[0].type == FileTypeEnum.video) {
      return CustomVideoCard(
        index: 0,
        messageEntity: widget.messageEntity,
        videoUrl: widget.messageEntity.media[0].url,
        height: MediaQuery.of(context).size.height * 0.4,
      );
    } else {
      return CustomChachedNetworkImage(
        messageEntity: widget.messageEntity,
        index: 0,
        height: MediaQuery.of(context).size.height * 0.4,
        width: double.infinity,
      );
    }
  }
}

class CustomVideoCard extends StatelessWidget {
  const CustomVideoCard({
    super.key,
    required this.videoUrl,
    required this.messageEntity,
    required this.index,
    required this.height,
  });

  final String videoUrl;
  final MessageEntity messageEntity;
  final int index;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: generateThumbnaill(videoUrl: videoUrl),
        builder: (context, snapshot) {
          return InkWell(
            onTap: () {
              context.push(
                Routes.IMAGESPAGEVIEW,
                extra: ImagesPageViewParams(
                  messageEntity: messageEntity,
                  index: index,
                ),
              );
            },
            child: SizedBox(
              height: height,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: snapshot.hasData
                    ? Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Image.memory(
                              snapshot.data as Uint8List,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: CircleAvatar(
                              radius: 23,
                              backgroundColor: Colors.black.withOpacity(0.5),
                              child: const Icon(
                                Icons.play_arrow,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      )
                    : const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
              ),
            ),
          );
        });
  }
}

class CustomChachedNetworkImage extends StatefulWidget {
  const CustomChachedNetworkImage({
    super.key,
    required this.messageEntity,
    required this.index,
    this.width,
    this.height,
  });

  final MessageEntity messageEntity;

  final double? width;
  final double? height;
  final int index;

  @override
  State<CustomChachedNetworkImage> createState() =>
      _CustomChachedNetworkImageState();
}

class _CustomChachedNetworkImageState extends State<CustomChachedNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(
          Routes.IMAGESPAGEVIEW,
          extra: ImagesPageViewParams(
            messageEntity: widget.messageEntity,
            index: widget.index,
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: widget.messageEntity.media[widget.index].url,
          fit: BoxFit.cover,
          width: widget.width,
          height: widget.height,
          errorWidget: (context, url, error) {
            // log(url);
            // log(error.toString());
            // retryToGetImage();
            return const Icon(Icons.error);
          },
        ),
      ),
    );
  }
}
