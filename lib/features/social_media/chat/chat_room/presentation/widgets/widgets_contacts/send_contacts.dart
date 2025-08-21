// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/contacts_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../res/style/const.dart';
import '../../../../../../../routes/routes.dart';
import '../../controllers/chat_room_cubit/chat_room_cubit.dart';
import '../chat_room_widgets/message_card.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class SentContactsCard extends StatefulWidget {
  const SentContactsCard({
    super.key,
    required this.messageEntity,
  });

  final MessageEntity messageEntity;

  @override
  State<SentContactsCard> createState() => _SentContactsCardState();
}

class _SentContactsCardState extends State<SentContactsCard> {
  @override
  Widget build(BuildContext context) {
    final isArabic = LocaleKeys.more.tr() == "More";
    final chatRoomCubit = context.read<ChatRoomCubit>();
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
              ? AppColors.DARK_GRAY_COLOR.withOpacity(0.5)
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
            padding:
                const EdgeInsets.only(right: 8, bottom: 6, top: 6, left: 8),
            child: Container(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.MESSAGE_COLOR,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
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
                          offset: const Offset(
                            0,
                            0,
                          ),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          // height:widget.messageEntity.hasReply? MediaQuery.of(context).size.height * 0.15:MediaQuery.of(context).size.height * 0.08,
                          child: Column(
                            children: [
                              widget.messageEntity.hasReply
                                  ? ReplySendMessageCard(
                                      width: double.infinity,
                                      messageEntity: widget.messageEntity)
                                  : const SizedBox(),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    // margin: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                        ManageVibration.vibrate();
                                        if (widget.messageEntity.sharedContacts
                                                .length ==
                                            1) {
                                          context.push(Routes.CONTACTSVIEW,
                                              extra: ContactsViewParams(
                                                  chatRoomCubit: chatRoomCubit,
                                                  messageEntity:
                                                      widget.messageEntity));
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          const CircleAvatar(
                                            backgroundColor: Colors.white,
                                            backgroundImage: NetworkImage(
                                                UIConst.profilePlaceHolder),
                                          ),
                                          const SizedBox(
                                            width: 4,
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                                child: Text(
                                                  widget
                                                              .messageEntity
                                                              .sharedContacts
                                                              .length ==
                                                          1
                                                      ? widget
                                                          .messageEntity
                                                          .sharedContacts[0]
                                                          .name
                                                      : "${widget.messageEntity.sharedContacts[0].name} ${LocaleKeys.and.tr()} ${widget.messageEntity.sharedContacts.length - 1} ${LocaleKeys.otherContacts.tr()}",
                                                  // overflow: TextOverflow.ellipsis,
                                                  style: Styles.mediumText(
                                                      color: AppColors
                                                          .GREY_DARK_COLOR),
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Label(
                                text: widget.messageEntity.time,
                                style: Styles.smallText(
                                    color: AppColors.PRIMARY_COLOR),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                _getMessageIcon(widget.messageEntity),
                                color:
                                    _getMessageIconColor(widget.messageEntity),
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                        widget.messageEntity.sharedContacts.length != 1
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Column(
                                  children: [
                                    const Divider(),
                                    TextButton(
                                      onPressed: () {
                                        ManageVibration.vibrate();
                                        context.push(Routes.CONTACTSVIEW,
                                            extra: ContactsViewParams(
                                                chatRoomCubit: chatRoomCubit,
                                                messageEntity:
                                                    widget.messageEntity));
                                      },
                                      child: Text(
                                        LocaleKeys.viewAll.tr(),
                                        // overflow: TextOverflow.ellipsis,
                                        style: Styles.mediumText(
                                            color: AppColors.PRIMARY_COLOR),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
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
