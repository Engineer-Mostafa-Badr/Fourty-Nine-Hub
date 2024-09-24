// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/contacts_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../res/style/const.dart';
import '../../../../../../../routes/routes.dart';
import '../../controllers/chat_room_cubit/chat_room_cubit.dart';
import '../chat_room_widgets/message_card.dart';

class ReceivedContactsCard extends StatefulWidget {
  const ReceivedContactsCard({
    super.key,
    required this.messageEntity,
  });
  final MessageEntity messageEntity;
  @override
  State<ReceivedContactsCard> createState() => _ReceivedContactsCardState();
}

class _ReceivedContactsCardState extends State<ReceivedContactsCard> {
  @override
  Widget build(BuildContext context) {
    final isArabic = LocaleKeys.more.tr() == "More";
    final chatRoomCubit = context.read<ChatRoomCubit>();
    return SwipeTo(
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
        padding: const EdgeInsets.only(left: 8, bottom: 6, top: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const CircleAvatar(
              radius: 15,
              backgroundColor: Colors.white,
              backgroundImage: NetworkImage(UIConst.profilePlaceHolder),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(12),
                        topRight: const Radius.circular(12),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          // height:widget.messageEntity.hasReply? MediaQuery.of(context).size.height * 0.15:MediaQuery.of(context).size.height * 0.08,
                          child: Column(
                            children: [
                              widget.messageEntity.hasReply
                                  ? ReplyRecivedMessageCard(
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
                                                      : "${widget.messageEntity.sharedContacts[0].name} and ${widget.messageEntity.sharedContacts.length - 1} other contact",
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
                              widget.messageEntity.byMe
                                  ? Icon(
                                      _getMessageIcon(widget.messageEntity),
                                      color: _getMessageIconColor(
                                          widget.messageEntity),
                                      size: 12,
                                    )
                                  : const SizedBox(width: 4),
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
                                        context.push(Routes.CONTACTSVIEW,
                                            extra: ContactsViewParams(
                                                chatRoomCubit: chatRoomCubit,
                                                messageEntity:
                                                    widget.messageEntity));
                                      },
                                      child: Text(
                                        "View all",
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

  String formatFileSize({required int fileSizeInBytes}) {
    const int kb = 1024;
    const int mb = kb * 1024;
    const int gb = mb * 1024;

    if (fileSizeInBytes < kb) {
      return '$fileSizeInBytes B';
    } else if (fileSizeInBytes < mb) {
      double sizeInKB = fileSizeInBytes / kb;
      return '${sizeInKB.toStringAsFixed(2)} KB';
    } else if (fileSizeInBytes < gb) {
      double sizeInMB = fileSizeInBytes / mb;
      return '${sizeInMB.toStringAsFixed(2)} MB';
    } else {
      double sizeInGB = fileSizeInBytes / gb;
      return '${sizeInGB.toStringAsFixed(2)} GB';
    }
  }
}

Future<void> downloadAndOpenFile({required String fileUrl}) async {
  Dio dio = Dio();

  try {
    var dir = await getDownloadsDirectory();
    String fileName = fileUrl.split('/').last;
    String savePath = '${dir!.path}/$fileName';
    // print(savePath);

    // Check if the file already exists
    if (await File(savePath).exists()) {
      // print('File already exists, opening...');
      // Open the existing file

      OpenFile.open(savePath);
    } else {
      // File doesn't exist, download it
      await dio.download(fileUrl, savePath);

      OpenFile.open(savePath);
    }
  } catch (e) {
    // print("Error: $e");
  }
}
