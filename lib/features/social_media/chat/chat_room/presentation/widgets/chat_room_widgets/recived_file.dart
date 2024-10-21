// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:path/path.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../core/service/download_and_open_files.dart';
import '../../../../../../../core/service/get_file_size_format.dart';
import '../../../../../../../res/style/const.dart';
import '../../controllers/chat_room_cubit/chat_room_cubit.dart';
import 'message_card.dart';

class ReceivedFileCard extends StatefulWidget {
  const ReceivedFileCard({
    super.key,
    required this.messageEntity,
  });
  final MessageEntity messageEntity;
  @override
  State<ReceivedFileCard> createState() => _ReceivedFileCardState();
}

class _ReceivedFileCardState extends State<ReceivedFileCard> {
  String? fileSize;
  String? fileExtension;

  @override
  void initState() {
    fileExtension =
        extension(widget.messageEntity.media[0].fileName ?? "Unknown")
            .toUpperCase();
    fileSize = formatFileSize(
        fileSizeInBytes: widget.messageEntity.media[0].fileSize ?? 100);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
        padding: const EdgeInsets.only(left: 8, bottom: 6, top: 6, right: 8),
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
                        GestureDetector(
                          onTap: () async {
                            log("Downloading...");
                            await downloadAndOpenFile(
                              fileUrl: widget.messageEntity.media[0].url,
                            );
                          },
                          child: SizedBox(
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
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.insert_drive_file,
                                            size: 40,
                                            color: AppColors.GREY_DARK_COLOR,
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
                                                    0.5,
                                                child: Text(
                                                  widget.messageEntity.media[0]
                                                          .fileName ??
                                                      "fileName",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Styles.mediumText(
                                                      color: AppColors
                                                          .GREY_DARK_COLOR),
                                                ),
                                              ),
                                              Text(
                                                '${fileSize ?? ''}'
                                                ' - '
                                                '$fileExtension',
                                                style: Styles.smallText(
                                                    color: AppColors
                                                        .GREY_DARK_COLOR),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
}
