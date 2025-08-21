// Nasr

// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:flutter_video_thumbnail_plus/flutter_video_thumbnail_plus.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/read_more_label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/file_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/widget/custom_circular_progress_indicator.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/show_image_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/chat_room_widgets/react_message_widget.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/chat_room_widgets/recived_file.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/chat_room_widgets/send_file.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/widgets_contacts/send_contacts.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../../../../../../../core/utils/custom_show_dialog.dart';
import '../../../../../../../res/assets/assets.dart';
import '../widgets_contacts/recived_contacts.dart';

class MessageCard extends StatelessWidget {
  final MessageEntity messageEntity;
  final String anotherUserName;

  const MessageCard(
      {super.key, required this.messageEntity, required this.anotherUserName});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isArabic = LocaleKeys.more.localize == "More";
    final chatRoomCubit = context.read<ChatRoomCubit>();
    if (messageEntity.byMe) {
      if (messageEntity.isOneTimeViewMessage) {
        return _buildSendOneTimeViewMessage(
          width: width,
          messageEntity: messageEntity,
          context: context,
        );
      }

      if (messageEntity.sharedContacts.isNotEmpty) {
        return SentContactsCard(messageEntity: messageEntity);
      }

      if (messageEntity.media.isEmpty) {
        return _buildMineMessage(
          width: width,
          messageEntity: messageEntity,
          context: context,
        );
      }

      final mediaType = messageEntity.media[0].type;

      if (mediaType == FileTypeEnum.document) {
        return SentFileCard(messageEntity: messageEntity);
      } else if (mediaType == FileTypeEnum.audio) {
        return VoiceMessageCard(
          messageEntity: messageEntity,
          isSend: true,
        );
      } else {
        return _buildSendMediaCard(
          isArabic: isArabic,
          chatRoomCubit: chatRoomCubit,
          context: context,
          width: width,
        );
      }
    } else {
      if (messageEntity.isOneTimeViewMessage) {
        return _buildReceiveOneTimeViewMessage(
          width: width,
          messageEntity: messageEntity,
          context: context,
        );
      }

      if (messageEntity.sharedContacts.isNotEmpty) {
        return ReceivedContactsCard(messageEntity: messageEntity);
      }

      if (messageEntity.media.isEmpty) {
        return _buildOtherMessage(
          width: width,
          messageEntity: messageEntity,
          context: context,
        );
      }

      final mediaType = messageEntity.media[0].type;

      if (mediaType == FileTypeEnum.document) {
        return ReceivedFileCard(messageEntity: messageEntity);
      } else if (mediaType == FileTypeEnum.audio) {
        return VoiceMessageCard(
          messageEntity: messageEntity,
          isSend: false,
        );
      } else {
        return _buildReceiveMediaCard(
          isArabic: isArabic,
          chatRoomCubit: chatRoomCubit,
          context: context,
          width: width,
        );
      }
    }
    /*return messageEntity.byMe
        ? messageEntity.isOneTimeViewMessage
            ? _buildSendOneTimeViewMessage(
                width: width,
                messageEntity: messageEntity,
                context: context,
              )
            : messageEntity.sharedContacts.isNotEmpty
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
        : messageEntity.isOneTimeViewMessage
            ? _buildReceiveOneTimeViewMessage(
                width: width,
                messageEntity: messageEntity,
                context: context,
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
                              );*/
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
      child: InkWell(
        onTap: () {
          ManageVibration.vibrate();
          log("message sender id : ${messageEntity.sender.id}");
          if (messageEntity.isSelected) {
            context
                .read<ChatRoomCubit>()
                .removeMessageFromSelectedMessages(message: messageEntity);
          } else {
            if (context.read<ChatRoomCubit>().selectedMessages.isNotEmpty) {
              context
                  .read<ChatRoomCubit>()
                  .addMessageToSelectedMessages(message: messageEntity);
            }
          }
        },
        onLongPress: () {
          if (!messageEntity.isSelected) {
            log("messageEntity.isSelected: ${messageEntity.isSelected}");
            context
                .read<ChatRoomCubit>()
                .addMessageToSelectedMessages(message: messageEntity);
          } else {
            context
                .read<ChatRoomCubit>()
                .removeMessageFromSelectedMessages(message: messageEntity);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: messageEntity.isSelected
                ? AppColors.DARK_GRAY_COLOR.withValues(alpha: 0.5)
                : Colors.transparent,
            // borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: isArabic ? 60 : 8,
              top: 6,
              bottom: 6,
              right: isArabic ? 8 : 60,
            ),
            child: ReactMessageWidget(
              messageEntity: messageEntity,
              width: width,
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    messageEntity.hasReply
                        ? ReplySendMessageCard(
                            width: width,
                            messageEntity: messageEntity,
                          )
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
                            color: Colors.black.withValues(alpha: 0.1),
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
      child: InkWell(
        onTap: () {
          ManageVibration.vibrate();
          log("message sender id : ${messageEntity.sender.id}");
          if (messageEntity.isSelected) {
            context
                .read<ChatRoomCubit>()
                .removeMessageFromSelectedMessages(message: messageEntity);
          } else {
            if (context.read<ChatRoomCubit>().selectedMessages.isNotEmpty) {
              context
                  .read<ChatRoomCubit>()
                  .addMessageToSelectedMessages(message: messageEntity);
            }
          }
        },
        onLongPress: () {
          if (!messageEntity.isSelected) {
            log("messageEntity.isSelected: ${messageEntity.isSelected}");
            context
                .read<ChatRoomCubit>()
                .addMessageToSelectedMessages(message: messageEntity);
          } else {
            context
                .read<ChatRoomCubit>()
                .removeMessageFromSelectedMessages(message: messageEntity);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: messageEntity.isSelected
                ? AppColors.DARK_GRAY_COLOR.withValues(alpha: 0.5)
                : Colors.transparent,
            // borderRadius: BorderRadius.circular(8),
          ),
          child: ReactMessageWidget(
            messageEntity: messageEntity,
            width: width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(
                  width: 8,
                ),
                CircleAvatar(
                  radius: 15,
                  backgroundColor: context.isDarkMode
                      ? AppColors.QUANTITY_COLOR
                      : Colors.white,
                  backgroundImage: NetworkImage(
                      context.read<ChatsCubit>().selectedChat.isAdmin == "admin"
                          ? context.read<ChatsCubit>().selectedChat.avatar
                          : UIConst.profilePlaceHolder),
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
                      color: context.isDarkMode
                          ? AppColors.QUANTITY_COLOR
                          : Colors.white,
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
                      boxShadow: [
                        BoxShadow(
                          color: context.isDarkMode
                              ? AppColors.BACKGROUND_COLOR
                                  .withValues(alpha: 0.05)
                              : Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
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
          ),
        ),
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
            style: Styles.mediumText(
              color: messageEntity.byMe
                  ? context.isDarkMode
                      ? Colors.black
                      : Colors.black
                  : context.isDarkMode
                      ? AppColors.BACKGROUND_COLOR
                      : AppColors.LIGHT_GRAY_COLOR2,
            ),
            textAlign: TextAlign.left,
          ),
          const SizedBox(width: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Label(
                text: messageEntity.time,
                style: Styles.smallText(
                  color: messageEntity.byMe
                      ? context.isDarkMode
                          ? Colors.black
                          : Colors.black
                      : context.isDarkMode
                          ? AppColors.BACKGROUND_COLOR
                          : AppColors.LIGHT_GRAY_COLOR2,
                ),
              ),
              const SizedBox(width: 4),
              if (messageEntity.byMe)
                Image.asset(
                  _getMessageIcon(messageEntity),
                  width: 20,
                ),
            ],
          ),
        ],
      ),
    );
  }

  void showAlert(BuildContext context, MessageEntity messageEntity,
      ChatRoomCubit chatRoomCubit) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocProvider.value(
          value: chatRoomCubit,
          child: Builder(builder: (context) {
            return BlocBuilder<ChatRoomCubit, ChatRoomState>(
              builder: (context, state) {
                return showAnimatedDialog(
                    context,
                    AlertDialog(
                      title: const Text("Show Deleted Message"),
                      content: Text(chatRoomCubit.deletedMessage?.text ??
                          LocaleKeys.loading.localize),
                      actions: [
                        TextButton(
                          onPressed: () {
                            ManageVibration.vibrate();
                            Navigator.of(context).pop();
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ));
                // return AlertDialog(
                //   title: const Text("Show Deleted Message"),
                //   content:
                //       Text(chatRoomCubit.deletedMessage?.text ?? "Loading..."),
                //   actions: [
                //     TextButton(
                //       onPressed: () {
                ManageVibration.vibrate();
                //         Navigator.of(context).pop();
                //       },
                //       child: const Text("OK"),
                //     ),
                //   ],
                // );
              },
            );
          }),
        );
      },
    );
  }

  Widget _buildMineMessage({
    required double width,
    required MessageEntity messageEntity,
    required BuildContext context,
  }) {
    final chatRoomCubit = context.read<ChatRoomCubit>();
    final isArabic = LocaleKeys.more.localize == "More";
    return InkWell(
      onDoubleTap: () async {
        await chatRoomCubit.showDeletedMessage(message: messageEntity);
        showAlert(context, messageEntity, chatRoomCubit);
      },
      onTap: () {
        ManageVibration.vibrate();
        log("message sender id : ${messageEntity.sender.id}");
        if (messageEntity.isSelected) {
          context
              .read<ChatRoomCubit>()
              .removeMessageFromSelectedMessages(message: messageEntity);
        } else {
          if (context.read<ChatRoomCubit>().selectedMessages.isNotEmpty) {
            context
                .read<ChatRoomCubit>()
                .addMessageToSelectedMessages(message: messageEntity);
          }
        }
      },
      onLongPress: () {
        if (!messageEntity.isSelected) {
          log("messageEntity.isSelected: ${messageEntity.isSelected}");
          context
              .read<ChatRoomCubit>()
              .addMessageToSelectedMessages(message: messageEntity);
        } else {
          context
              .read<ChatRoomCubit>()
              .removeMessageFromSelectedMessages(message: messageEntity);
        }
      },
      child: SwipeTo(
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
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: messageEntity.isSelected
                  ? AppColors.DARK_GRAY_COLOR.withValues(alpha: 0.5)
                  : Colors.transparent,
              // borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ReactMessageWidget(
                messageEntity: messageEntity,
                width: width,
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
                            _buildSendTextMessage(
                                context, messageEntity, isArabic),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSendOneTimeViewMessage({
    required double width,
    required MessageEntity messageEntity,
    required BuildContext context,
  }) {
    final chatRoomCubit = context.read<ChatRoomCubit>();
    final isArabic = LocaleKeys.more.localize == "More";
    return BlocBuilder<ChatRoomCubit, ChatRoomState>(
      builder: (context, state) {
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
                        BlocBuilder<ChatRoomCubit, ChatRoomState>(
                          builder: (context, state) {
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
                                  bottomLeft: isArabic
                                      ? const Radius.circular(12)
                                      : const Radius.circular(0),
                                  bottomRight: isArabic
                                      ? const Radius.circular(0)
                                      : const Radius.circular(12),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.black26.withValues(alpha: 0.2),
                                    blurRadius: 4,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                                text: context.isArabic
                                                    ? "الرسالة محذوفة"
                                                    : "Deleted Message",
                                                style: Styles.mediumText(
                                                    color: Colors.black54),
                                              ),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                child: Icon(
                                                  Icons.looks_one_outlined,
                                                  color: context.isDarkMode
                                                      ? Colors.white
                                                      : Colors.black,
                                                  // color: AppColors
                                                  //     .PRIMARY_COLOR
                                                  //     .withValues(alpha: 0.5),
                                                ),
                                              ),
                                              Stack(
                                                children: [
                                                  messageEntity
                                                          .isOneTimeSeenMessage
                                                      ? ReadMoreLabel(
                                                          // trimLines: 5,
                                                          text: LocaleKeys
                                                              .opened.localize,
                                                          style:
                                                              Styles.mediumText(
                                                            color: context
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                            // color: AppColors
                                                            //     .PRIMARY_COLOR,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),

                                                          textAlign:
                                                              TextAlign.left,
                                                        )
                                                      : ReadMoreLabel(
                                                          // trimLines: 5,
                                                          text: messageEntity
                                                                  .media.isEmpty
                                                              ? context.isArabic
                                                                  ? "نص"
                                                                  : "Text"
                                                              : messageEntity
                                                                          .media[
                                                                              0]
                                                                          .type ==
                                                                      FileTypeEnum
                                                                          .image
                                                                  ? LocaleKeys
                                                                      .photo
                                                                      .localize
                                                                  : messageEntity
                                                                              .media[
                                                                                  0]
                                                                              .type ==
                                                                          FileTypeEnum
                                                                              .video
                                                                      ? LocaleKeys
                                                                          .video
                                                                          .localize
                                                                      : messageEntity.media[0].type ==
                                                                              FileTypeEnum
                                                                                  .audio
                                                                          ? LocaleKeys
                                                                              .audio
                                                                              .localize
                                                                          : LocaleKeys
                                                                              .file
                                                                              .localize,
                                                          style:
                                                              Styles.mediumText(
                                                            color: context
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                            // color: AppColors
                                                            //     .PRIMARY_COLOR,
                                                          ),

                                                          textAlign:
                                                              TextAlign.left,
                                                        ),
                                                ],
                                              ),
                                            ],
                                          ),
                                  ),
                                  const SizedBox(width: 8),
                                  Row(
                                    children: [
                                      Label(
                                        text: messageEntity.time,
                                        style: Styles.smallText(
                                          color: context.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      if (messageEntity.byMe)
                                        Image.asset(
                                          _getMessageIcon(messageEntity),
                                          width: 20,
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReceiveOneTimeViewMessage({
    required double width,
    required MessageEntity messageEntity,
    required BuildContext context,
  }) {
    final chatRoomCubit = context.read<ChatRoomCubit>();
    final isArabic = LocaleKeys.more.localize == "More";
    return BlocBuilder<ChatRoomCubit, ChatRoomState>(
      builder: (context, state) {
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
                CircleAvatar(
                  radius: 15,
                  backgroundColor: context.isDarkMode
                      ? AppColors.QUANTITY_COLOR
                      : Colors.white,
                  backgroundImage: NetworkImage(
                      context.read<ChatsCubit>().selectedChat.isAdmin == "admin"
                          ? context.read<ChatsCubit>().selectedChat.avatar
                          : UIConst.profilePlaceHolder),
                ),
                const Sizer(width: 5),
                messageEntity.isDeleted
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
                            text: context.isArabic
                                ? "الرسالة محذوفة"
                                : "Deleted Message",
                            style: Styles.mediumText(
                                color: Colors.black54.withValues(alpha: 0.5)),
                          ),
                        ],
                      )
                    : BlocBuilder<ChatRoomCubit, ChatRoomState>(
                        builder: (context, state) {
                        return IntrinsicWidth(
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
                                InkWell(
                                  onTap: () async {
                                    ManageVibration.vibrate();
                                    if ((!messageEntity.isOneTimeSeenMessage) &&
                                        (messageEntity.media.isEmpty)) {
                                      await chatRoomCubit.getOneTimeViewMessage(
                                        message: messageEntity,
                                      );
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return BlocProvider.value(
                                            value: chatRoomCubit,
                                            child: Builder(builder: (context) {
                                              return BlocBuilder<ChatRoomCubit,
                                                  ChatRoomState>(
                                                builder: (context, state) {
                                                  return showAnimatedDialog(
                                                    context,
                                                    AlertDialog(
                                                      title: Text(
                                                          context.isArabic
                                                              ? "رسالة نصية"
                                                              : "Text Message"),
                                                      content: Text(
                                                          messageEntity.text),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            ManageVibration
                                                                .vibrate();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              const Text("OK"),
                                                        ),
                                                      ],
                                                    ),
                                                  );

                                                  // return AlertDialog(
                                                  //   title: Text(context.isArabic
                                                  //       ? "رسالة نصية"
                                                  //       : "Text Message"),
                                                  //   content: Text(
                                                  //       messageEntity.text ??
                                                  //           "Loading..."),
                                                  //   actions: [
                                                  //     TextButton(
                                                  //       onPressed: () {
                                                  ManageVibration.vibrate();
                                                  //         Navigator.of(context)
                                                  //             .pop();
                                                  //       },
                                                  //       child: const Text("OK"),
                                                  //     ),
                                                  //   ],
                                                  // );
                                                },
                                              );
                                            }),
                                          );
                                        },
                                      );
                                    } else {
                                      if ((!messageEntity
                                              .isOneTimeSeenMessage) &&
                                          (messageEntity.media[0].type ==
                                                  FileTypeEnum.image ||
                                              messageEntity.media[0].type ==
                                                  FileTypeEnum.video)) {
                                        await chatRoomCubit
                                            .getOneTimeViewMessage(
                                          message: messageEntity,
                                        );
                                        context.push(
                                          Routes.IMAGESPAGEVIEW,
                                          extra: ImagesPageViewParams(
                                            messageEntity: messageEntity,
                                            index: 0,
                                          ),
                                        );
                                      } else if ((!messageEntity
                                              .isOneTimeSeenMessage) &&
                                          (messageEntity.media[0].type ==
                                              FileTypeEnum.audio)) {
                                        await chatRoomCubit
                                            .getOneTimeViewMessage(
                                          message: messageEntity,
                                        );
                                        context.push(
                                          Routes.ONETIMEVOICEMESSAGE,
                                          extra: messageEntity,
                                        );
                                      } else if ((!messageEntity
                                              .isOneTimeSeenMessage) &&
                                          (messageEntity.media[0].type ==
                                              FileTypeEnum.document)) {
                                        await chatRoomCubit
                                            .getOneTimeViewMessage(
                                          message: messageEntity,
                                        );
                                        await downloadAndOpenFile(
                                          fileUrl: messageEntity.media[0].url,
                                        );
                                      }
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    margin: const EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      color: context.isDarkMode
                                          ? AppColors.QUANTITY_COLOR
                                          : Colors.white,
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
                                      boxShadow: [
                                        BoxShadow(
                                          color: context.isDarkMode
                                              ? AppColors.BACKGROUND_COLOR
                                                  .withValues(alpha: 0.05)
                                              : Colors.black12,
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Icon(
                                            Icons.looks_one_outlined,
                                            color: context.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                        Expanded(
                                          child: messageEntity
                                                  .isOneTimeSeenMessage
                                              ? ReadMoreLabel(
                                                  // trimLines: 5,
                                                  text: LocaleKeys
                                                      .opened.localize,
                                                  style: Styles.mediumText(
                                                    color: context.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                    // : AppColors
                                                    //     .PRIMARY_COLOR,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                )
                                              : ReadMoreLabel(
                                                  // trimLines: 5,
                                                  text: messageEntity
                                                          .media.isEmpty
                                                      ? context.isArabic
                                                          ? "نص"
                                                          : "Text"
                                                      : messageEntity.media[0]
                                                                  .type ==
                                                              FileTypeEnum.image
                                                          ? LocaleKeys
                                                              .photo.localize
                                                          : messageEntity
                                                                      .media[0]
                                                                      .type ==
                                                                  FileTypeEnum
                                                                      .video
                                                              ? LocaleKeys.video
                                                                  .localize
                                                              : messageEntity
                                                                          .media[
                                                                              0]
                                                                          .type ==
                                                                      FileTypeEnum
                                                                          .audio
                                                                  ? LocaleKeys
                                                                      .audio
                                                                      .localize
                                                                  : LocaleKeys
                                                                      .file
                                                                      .localize,
                                                  style: Styles.mediumText(
                                                    color: context.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                    // : AppColors
                                                    //     .PRIMARY_COLOR,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                        ),
                                        const SizedBox(width: 8),
                                        Label(
                                          text: messageEntity.time,
                                          style: Styles.smallText(
                                            color: context.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
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
                      }),
              ],
            ),
          ),
        );
      },
    );
  }

  Container _buildSendTextMessage(
      BuildContext context, MessageEntity messageEntity, bool isArabic) {
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
            color: Colors.black26.withValues(alpha: 0.2),
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
                        text: isArabic ? "الرسالة محذوفة" : "Deleted Message",
                        style: Styles.mediumText(color: Colors.black54),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (messageEntity.isForwarded)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.reply,
                                color: Colors.grey,
                                size: 18,
                              ),
                              Label(
                                text: LocaleKeys.forwarded.localize,
                                style: Styles.smallText(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ReadMoreLabel(
                        // trimLines: 5,
                        text: messageEntity.text,
                        style: Styles.mediumText(
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
          ),
          const SizedBox(width: 8),
          Row(
            children: [
              Label(
                text: messageEntity.time,
                style: Styles.smallText(
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 4),
              if (messageEntity.byMe)
                Image.asset(
                  _getMessageIcon(messageEntity),
                  width: 20,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOtherMessage({
    required double width,
    required MessageEntity messageEntity,
    required BuildContext context,
  }) {
    final chatRoomCubit = context.read<ChatRoomCubit>();
    final isArabic = LocaleKeys.more.localize == "More";
    return InkWell(
      onTap: () {
        ManageVibration.vibrate();
        log("message sender id : ${messageEntity.sender.id}");
        if (messageEntity.isSelected) {
          context
              .read<ChatRoomCubit>()
              .removeMessageFromSelectedMessages(message: messageEntity);
        } else {
          if (context.read<ChatRoomCubit>().selectedMessages.isNotEmpty) {
            context
                .read<ChatRoomCubit>()
                .addMessageToSelectedMessages(message: messageEntity);
          }
        }
      },
      onLongPress: () {
        if (!messageEntity.isSelected) {
          log("messageEntity.isSelected: ${messageEntity.isSelected}");
          context
              .read<ChatRoomCubit>()
              .addMessageToSelectedMessages(message: messageEntity);
        } else {
          context
              .read<ChatRoomCubit>()
              .removeMessageFromSelectedMessages(message: messageEntity);
        }
      },
      child: SwipeTo(
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
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: messageEntity.isSelected
                  ? AppColors.DARK_GRAY_COLOR.withValues(alpha: 0.5)
                  : Colors.transparent,
              // borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ReactMessageWidget(
                messageEntity: messageEntity,
                width: width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: context.isDarkMode
                          ? AppColors.QUANTITY_COLOR
                          : Colors.white,
                      backgroundImage: NetworkImage(
                          context.read<ChatsCubit>().selectedChat.isAdmin ==
                                  "admin"
                              ? context.read<ChatsCubit>().selectedChat.avatar
                              : UIConst.profilePlaceHolder),
                    ),
                    const Sizer(width: 5),
                    IntrinsicWidth(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: width * 0.7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            messageEntity.hasReply
                                ? ReplyRecivedMessageCard(
                                    width: width,
                                    messageEntity: messageEntity,
                                  )
                                : const SizedBox(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.all(0),
                                  decoration: BoxDecoration(
                                    color: context.isDarkMode
                                        ? AppColors.QUANTITY_COLOR
                                        : Colors.white,
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
                                    boxShadow: [
                                      BoxShadow(
                                        color: context.isDarkMode
                                            ? AppColors.BACKGROUND_COLOR
                                                .withValues(alpha: 0.05)
                                            : Colors.black12,
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: messageEntity.isDeleted
                                            ? Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(4),
                                                    child: Icon(
                                                      Icons.not_interested,
                                                      color: Colors.black54
                                                          .withValues(
                                                              alpha: 0.5),
                                                      // size: 16,
                                                    ),
                                                  ),
                                                  Label(
                                                    text: context.isArabic
                                                        ? "الرسالة محذوفة"
                                                        : "Deleted Message",
                                                    style: Styles.mediumText(
                                                        color: Colors.black54
                                                            .withValues(
                                                                alpha: 0.5)),
                                                  ),
                                                ],
                                              )
                                            : Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  messageEntity.isForwarded
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  bottom: 12),
                                                          child: SizedBox(
                                                            height: 20,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                const Icon(
                                                                  Icons.reply,
                                                                  color: Colors
                                                                      .grey,
                                                                ),
                                                                Label(
                                                                  text: LocaleKeys
                                                                      .forwarded
                                                                      .localize,
                                                                  style: Styles
                                                                      .mediumText(
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      : const SizedBox(),
                                                  ReadMoreLabel(
                                                    // trimLines: 5,
                                                    text: messageEntity.text,
                                                    style: Styles.mediumText(
                                                      color: context.isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                      // : AppColors
                                                      //     .PRIMARY_COLOR,
                                                    ),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                ],
                                              ),
                                      ),
                                      const SizedBox(width: 8),
                                      Label(
                                        text: messageEntity.time,
                                        style: Styles.smallText(
                                          color: context.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VoiceMessageCard extends StatefulWidget {
  VoiceMessageCard({
    super.key,
    required this.messageEntity,
    required this.isSend,
  });

  final MessageEntity messageEntity;
  final bool isSend;
  bool isListening = true;

  @override
  State<VoiceMessageCard> createState() => _VoiceMessageCardState();
}

class _VoiceMessageCardState extends State<VoiceMessageCard> {
  late ValueNotifier<bool> isListeningNotifier;

  @override
  void initState() {
    super.initState();
    isListeningNotifier = ValueNotifier<bool>(false);
  }

  @override
  void dispose() {
    isListeningNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatRoomCubit = context.read<ChatRoomCubit>();
    final isArabic = LocaleKeys.more.localize == "More";
    return InkWell(
      onTap: () {
        ManageVibration.vibrate();
        if (widget.messageEntity.isSelected) {
          context
              .read<ChatRoomCubit>()
              .removeMessageFromSelectedMessages(message: widget.messageEntity);
        } else {
          if (context.read<ChatRoomCubit>().selectedMessages.isNotEmpty) {
            context
                .read<ChatRoomCubit>()
                .addMessageToSelectedMessages(message: widget.messageEntity);
          }
        }
      },
      onLongPress: () {
        if (!widget.messageEntity.isSelected) {
          context
              .read<ChatRoomCubit>()
              .addMessageToSelectedMessages(message: widget.messageEntity);
        } else {
          context
              .read<ChatRoomCubit>()
              .removeMessageFromSelectedMessages(message: widget.messageEntity);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: widget.messageEntity.isSelected
              ? AppColors.DARK_GRAY_COLOR.withValues(alpha: 0.5)
              : Colors.transparent,
          // borderRadius: BorderRadius.circular(8),
        ),
        child: SwipeTo(
          onRightSwipe: !isArabic
              ? null
              : (details) {
                  chatRoomCubit.selectMessageForReplaying(widget.messageEntity);
                },
          onLeftSwipe: isArabic
              ? null
              : (details) {
                  chatRoomCubit.selectMessageForReplaying(widget.messageEntity);
                },
          child: Padding(
            padding: const EdgeInsets.only(
              right: 8,
              bottom: 6,
              top: 6,
              left: 8,
            ),
            child: ReactMessageWidget(
              messageEntity: widget.messageEntity,
              width: double.infinity,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: widget.isSend
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  if (!widget.isSend)
                    CircleAvatar(
                      radius: 15,
                      backgroundColor: context.isDarkMode
                          ? AppColors.QUANTITY_COLOR
                          : Colors.white,
                      backgroundImage: NetworkImage(
                          context.read<ChatsCubit>().selectedChat.isAdmin ==
                                  "admin"
                              ? context.read<ChatsCubit>().selectedChat.avatar
                              : UIConst.profilePlaceHolder),
                    ),
                  if (widget.isSend) const Sizer(width: 5),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      color: widget.isSend
                          ? AppColors.MESSAGE_COLOR
                          : context.isDarkMode
                              ? AppColors.QUANTITY_COLOR
                              : AppColors.BACKGROUND_COLOR,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: context.isDarkMode
                              ? AppColors.BACKGROUND_COLOR
                                  .withValues(alpha: 0.05)
                              : Colors.black12,
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (widget.messageEntity.hasReply)
                          if (widget.isSend)
                            ReplySendMessageCard(
                                width: MediaQuery.of(context).size.width * 0.7,
                                messageEntity: widget.messageEntity)
                          else
                            ReplyRecivedMessageCard(
                              messageEntity: widget.messageEntity,
                              width: MediaQuery.of(context).size.width * 0.7,
                            ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: GestureDetector(
                            onTap: () {
                              ManageVibration.vibrate();
                              log("voice message card tap is listened : ${widget.messageEntity.isListened}");
                              log("voice message card tap : ${widget.messageEntity.toString()}");
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Image.network(
                                    widget.messageEntity.sender.avatar,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7 -
                                          50,
                                  child: VoiceMessageView(
                                    activeSliderColor: Colors.black,
                                    playIcon: const Icon(
                                      Icons.play_arrow_rounded,
                                      color: Colors.black,
                                    ),
                                    pauseIcon: const Icon(
                                      Icons.pause_rounded,
                                      color: Colors.black,
                                    ),
                                    refreshIcon: const Icon(
                                      Icons.refresh,
                                      color: Colors.black,
                                    ),
                                    stopDownloadingIcon: const Icon(
                                      Icons.close,
                                      color: Colors.black,
                                    ),
                                    circlesColor: Colors.transparent,
                                    circlesTextStyle:
                                        Styles.smallText(color: Colors.black),
                                    counterTextStyle:
                                        Styles.smallText(color: Colors.black),
                                    backgroundColor: widget.isSend
                                        ? AppColors.MESSAGE_COLOR
                                        : context.isDarkMode
                                            ? AppColors.QUANTITY_COLOR
                                            : AppColors.BACKGROUND_COLOR,
                                    innerPadding: 0,
                                    cornerRadius: 12,
                                    controller: VoiceController(
                                      audioSrc:
                                          widget.messageEntity.media[0].url,
                                      maxDuration:
                                          const Duration(minutes: 1000),
                                      isFile: false,
                                      onComplete: () async {
                                        isListeningNotifier.value = false;
                                        if (!widget.messageEntity.byMe &&
                                            !widget.messageEntity.isListened) {
                                          await chatRoomCubit
                                              .setRecordAsListened(
                                                  message:
                                                      widget.messageEntity);
                                          // setState(() {
                                          // widget.messageEntity.isListened = true;
                                          // });
                                        }
                                        // log("Playing voice by me: ${widget.messageEntity.byMe}");
                                        // log("Playing voice listened: ${widget.messageEntity.isListened}");
                                        // setState(() {});
                                        // setState(() {
                                        //   widget.isListening = false;
                                        // });
                                      },
                                      onPause: () async {
                                        isListeningNotifier.value = false;
                                        if (!widget.messageEntity.byMe &&
                                            !widget.messageEntity.isListened) {
                                          await chatRoomCubit
                                              .setRecordAsListened(
                                                  message:
                                                      widget.messageEntity);
                                          // setState(() {
                                          // widget.messageEntity.isListened = true;
                                          // });
                                          // setState(() {
                                          //   widget.isListening = false;
                                          // });
                                        }
                                      },
                                      onPlaying: () async {
                                        isListeningNotifier.value = true;
                                        if (!widget.messageEntity.byMe &&
                                            !widget.messageEntity.isListened) {
                                          await chatRoomCubit
                                              .setRecordAsListened(
                                                  message:
                                                      widget.messageEntity);
                                          // setState(() {
                                          // widget.messageEntity.isListened = true;
                                          // });
                                        }
                                        // setState(() {
                                        //   widget.isListening = true;
                                        // });
                                      },
                                      onError: (p0) {
                                        // setState(() {
                                        log("voice error : $p0");
                                        // });
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                                text: widget.messageEntity.time,
                                style: Styles.smallText(
                                  color: widget.isSend
                                      ? Colors.black
                                      : context.isDarkMode
                                          ? AppColors.BACKGROUND_COLOR
                                              .withValues(alpha: 0.5)
                                          : AppColors.LIGHT_GRAY_COLOR2,
                                ),
                              ),
                              widget.isSend
                                  ? const SizedBox(width: 4)
                                  : const SizedBox(),
                              if (widget.isSend)
                                Image.asset(
                                  _getMessageIcon(widget.messageEntity),
                                  width: 20,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
      decoration: BoxDecoration(
        color: context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.white,
        borderRadius: const BorderRadius.only(
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
          color: context.isDarkMode
              ? Colors.white
              : AppColors.DARK_GRAY_COLOR.withValues(alpha: 0.4),
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
              decoration: BoxDecoration(
                color: messageEntity.reply!.sender.id != messageEntity.sender.id
                    ? AppColors.PRIMARY_COLOR
                    : AppColors.SECONDARY_COLOR,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
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
                      messageEntity.reply!.sender.id != messageEntity.sender.id
                          ? 'You'
                          : messageEntity.reply!.sender.name,
                      // messageEntity.reply!.sender.name,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mediumText(
                          color:
                              context.isDarkMode ? Colors.white : Colors.black,
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
                                  ? LocaleKeys.photo.localize
                                  : messageEntity.reply!.media[0].fileName ??
                                      LocaleKeys.file.localize
                              : messageEntity.reply!.text
                          : messageEntity.reply!.text,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mediumText(
                        color: context.isDarkMode
                            ? AppColors.BACKGROUND_COLOR
                            : AppColors.DARK_GRAY_COLOR,
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
                    : Icon(
                        Icons.insert_drive_file,
                        size: 30,
                        color: context.isDarkMode
                            ? AppColors.BACKGROUND_COLOR
                            : AppColors.GREY_DARK_COLOR,
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
          color: AppColors.DARK_GRAY_COLOR.withValues(alpha: 0.4),
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
              decoration: BoxDecoration(
                color: messageEntity.reply!.sender.id == messageEntity.sender.id
                    ? AppColors.PRIMARY_COLOR
                    : AppColors.SECONDARY_COLOR,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
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
                      messageEntity.reply!.sender.id == messageEntity.sender.id
                          ? 'You'
                          : messageEntity.reply!.sender.name,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mediumText(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
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
                                  ? LocaleKeys.photo.localize
                                  : messageEntity.reply!.media[0].fileName ??
                                      LocaleKeys.file.localize
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
                ManageVibration.vibrate();
                context.push(Routes.SHOWIMAGEVIEW, extra: messageEntity);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
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
  return await FlutterVideoThumbnailPlus.thumbnailData(
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
              ManageVibration.vibrate();
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
                              backgroundColor:
                                  Colors.black.withValues(alpha: 0.5),
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
                        child: CustomCircularProgressIndicator(
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
        ManageVibration.vibrate();
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

String _getMessageIcon(MessageEntity messageEntity) {
  if (messageEntity.seen) {
    return Assets.doubleCheckSeen;
  } else if (messageEntity.delivered) {
    return Assets.doubleCheck;
  } else {
    return Assets.check;
  }
}
