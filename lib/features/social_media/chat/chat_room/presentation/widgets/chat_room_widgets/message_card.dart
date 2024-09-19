// Nasr
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/read_more_label.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:swipe_to/swipe_to.dart';

class MessageCard extends StatelessWidget {
  final MessageEntity messageEntity;
  final String anotherUserName;

  const MessageCard(
      {super.key, required this.messageEntity, required this.anotherUserName});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isArabic = LocaleKeys.more.tr() == "More";

    return messageEntity.byMe
        ? messageEntity.media.isEmpty
            ? _buildMineMessage(
                width: width, messageEntity: messageEntity, context: context)
            : GestureDetector(
                onTap: () {
                  log(messageEntity.media.first.url);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 60,
                    top: 6,
                    bottom: 6,
                    right: 8,
                  ),
                  child: Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Conditional Layout for Images based on count
                                if (messageEntity.media.length == 1)
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      imageUrl: messageEntity.media[0].url,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                if (messageEntity.media.length == 2)
                                  Row(
                                    children: messageEntity.media.map((media) {
                                      return Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: CachedNetworkImage(
                                              imageUrl: media.url,
                                              fit: BoxFit.cover,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.3,
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                if (messageEntity.media.length == 3)
                                  Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: messageEntity.media[0].url,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                      Row(
                                        children: messageEntity.media
                                            .sublist(1)
                                            .map((media) {
                                          return Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: CachedNetworkImage(
                                                  imageUrl: media.url,
                                                  fit: BoxFit.cover,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.2,
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                if (messageEntity.media.length >= 4)
                                  Stack(
                                    children: [
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: 4,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 4.0,
                                          crossAxisSpacing: 4.0,
                                          childAspectRatio: 1.0,
                                        ),
                                        itemBuilder: (context, index) {
                                          if (index < 4) {
                                            return ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: CachedNetworkImage(
                                                imageUrl: messageEntity
                                                    .media[index].url,
                                                fit: BoxFit.cover,
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            );
                                          } else {
                                            return const SizedBox(); // Empty container for extra images
                                          }
                                        },
                                      ),
                                      if (messageEntity.media.length > 4)
                                        Positioned(
                                          bottom: 8,
                                          right: 8,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0.6),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
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
                                    ],
                                  ),
                                const SizedBox(height: 6),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                      ),
                                      child: Text(
                                        messageEntity.text,
                                        style: Styles.mediumText(
                                          color: AppColors.PRIMARY_COLOR,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    const Spacer(),
                                    Label(
                                      text: messageEntity.time,
                                      style: Styles.smallText(
                                          color: AppColors.PRIMARY_COLOR),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      _getMessageIcon(messageEntity),
                                      color:
                                          _getMessageIconColor(messageEntity),
                                      size: 12,
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
              )
        : _buildOtherMessage(
            width: width, messageEntity: messageEntity, context: context);
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
      child: GestureDetector(
        onTap: () {
          log(messageEntity.media.length.toString());
          log(messageEntity.media[0].url);
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
                          ? Container(
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
                                  color: AppColors.DARK_GRAY_COLOR
                                      .withOpacity(0.4),
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
                                      width: 3,
                                      color: AppColors.PRIMARY_COLOR,
                                      height: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: width * 0.7,
                                            ),
                                            child: Text(
                                              messageEntity.reply!.sender.name,
                                              overflow: TextOverflow.ellipsis,
                                              style: Styles.mediumText(
                                                  color:
                                                      AppColors.PRIMARY_COLOR,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: width * 0.7,
                                              maxHeight: 20,
                                            ),
                                            child: Text(
                                              messageEntity.reply!.text,
                                              overflow: TextOverflow.ellipsis,
                                              style: Styles.mediumText(
                                                color:
                                                    AppColors.DARK_GRAY_COLOR,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(),
                      Container(
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
                                          style: Styles.mediumText(
                                              color: Colors.black54),
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
                                  text: messageEntity.time,
                                  style: Styles.smallText(
                                      color: AppColors.PRIMARY_COLOR),
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
                        ? Container(
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
                                color:
                                    AppColors.DARK_GRAY_COLOR.withOpacity(0.4),
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
                                    width: 3,
                                    color: AppColors.PRIMARY_COLOR,
                                    height: 30,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: width * 0.55,
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
                                            maxWidth: width * 0.55,
                                            maxHeight: 20,
                                          ),
                                          child: Text(
                                            messageEntity.reply!.text,
                                            overflow: TextOverflow.ellipsis,
                                            style: Styles.mediumText(
                                              color: AppColors.DARK_GRAY_COLOR,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
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
                              trimLines: 5,
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
