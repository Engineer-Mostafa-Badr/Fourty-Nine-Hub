// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class ChatCard extends StatefulWidget {
  final bool isSecret;
  final ChatEntity? chat;
  final ChatsCubit? chatsCubit;

  const ChatCard(
      {super.key, this.isSecret = false, this.chat, this.chatsCubit});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatsCubit, ChatsState>(
      builder: (context, state) {
        return InkWell(
          splashColor: context.isDarkMode
              ? Colors.white
              : AppColors.PRIMARY_COLOR.withOpacity(0.05),
          // Ripple effect color
          highlightColor: context.isDarkMode
              ? AppColors.QUANTITY_COLOR
              : AppColors.LIGHT_GRAY_COLOR.withOpacity(0.2),
          // Highlight color on tap
          onTap: () {
            if (context.read<ChatsCubit>().selectedChats.isEmpty) {
              context.read<ChatsCubit>().selectChat = widget.chat!;
              context.push(Routes.CHATROOM, extra: widget.chatsCubit);
              // log("typiiiiiiiing = ${widget.chat!.typing}");
              // log("recordiiiiiiing = ${widget.chat!.recording}");
            } else {
              setState(() {
                if (!widget.chat!.isSelected) {
                  context
                      .read<ChatsCubit>()
                      .addChatToSelectedChats(chat: widget.chat!);
                } else {
                  context
                      .read<ChatsCubit>()
                      .removeChatToSelectedChats(chat: widget.chat!);
                }
              });
            }
          },
          onLongPress: () {
            setState(() {
              if (!widget.chat!.isSelected) {
                context
                    .read<ChatsCubit>()
                    .addChatToSelectedChats(chat: widget.chat!);
              } else {
                context
                    .read<ChatsCubit>()
                    .removeChatToSelectedChats(chat: widget.chat!);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            // curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: widget.chat!.isSelected
                  ? AppColors.PRIMARY_COLOR.withOpacity(0.001)
                  : context.isDarkMode
                      ? AppColors.QUANTITY_COLOR
                      : AppColors.BACKGROUND_COLOR,
              borderRadius: BorderRadius.circular(8),
              boxShadow: widget.chat!.isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.PRIMARY_COLOR.withOpacity(0.2),
                        blurRadius: 6,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        height: kToolbarHeight * .7,
                        width: kToolbarHeight * .7,
                        child: widget.isSecret
                            ? const CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Icon(
                                  FontAwesomeIcons.ghost,
                                  color: Colors.grey,
                                ))
                            : GestureDetector(
                                onTap: () {
                                  if (context.isUserLoggedIn) {
                                    context.read<UserCubit>().updateProfileView(
                                          isProfile: false,
                                          userId: widget.chat!.userId,
                                        );
                                  }
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return BlocProvider.value(
                                        value: widget.chatsCubit!,
                                        child: Builder(builder: (context) {
                                          return AlertDialog(
                                            contentPadding: EdgeInsets
                                                .zero, // Remove default padding
                                            backgroundColor: Colors
                                                .transparent, // Make the dialog background transparent
                                            content: ClipRRect(
                                              child: Stack(
                                                children: [
                                                  Image.network(
                                                    widget.chat!.avatar,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Image.network(
                                                        UIConst
                                                            .profilePlaceHolder,
                                                        fit: BoxFit.cover,
                                                      );
                                                    },
                                                  ),
                                                  Positioned(
                                                    top: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Container(
                                                      color: Colors.black
                                                          .withOpacity(0.4),
                                                      child: Row(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              widget.chat!.name,
                                                              style: const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    left: 0,
                                                    right: 0,
                                                    child: Container(
                                                        color: Colors.white,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly, // Distribute icons evenly
                                                          children: [
                                                            IconButton(
                                                              icon: const Icon(
                                                                Icons.chat,
                                                                color: AppColors
                                                                    .SECONDARY_COLOR,
                                                              ),
                                                              onPressed: () {
                                                                context
                                                                        .read<
                                                                            ChatsCubit>()
                                                                        .selectChat =
                                                                    widget
                                                                        .chat!;
                                                                context.push(
                                                                    Routes
                                                                        .CHATROOM,
                                                                    extra: widget
                                                                        .chatsCubit);
                                                              },
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(
                                                                Icons.call,
                                                                color: AppColors
                                                                    .SECONDARY_COLOR,
                                                              ),
                                                              onPressed: () {},
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(
                                                                Icons.videocam,
                                                                color: AppColors
                                                                    .SECONDARY_COLOR,
                                                              ),
                                                              onPressed: () {},
                                                            ),
                                                            IconButton(
                                                              icon: const Icon(
                                                                Icons.info,
                                                                color: AppColors
                                                                    .SECONDARY_COLOR,
                                                              ),
                                                              onPressed: () {
                                                                context
                                                                        .read<
                                                                            ChatsCubit>()
                                                                        .selectChat =
                                                                    widget
                                                                        .chat!;
                                                                context.push(
                                                                    Routes
                                                                        .VIEWCONTACT,
                                                                    extra: widget
                                                                        .chatsCubit);
                                                              },
                                                            ),
                                                          ],
                                                        )),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                      );
                                    },
                                  );
                                },
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: CircleAvatar(
                                        child: Image.network(
                                          widget.chat!.avatar,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.network(
                                              UIConst.profilePlaceHolder,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    widget.chat!.isSelected
                                        ? const Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: CircleAvatar(
                                              radius: 8,
                                              backgroundColor:
                                                  AppColors.PRIMARY_COLOR,
                                              child: Icon(
                                                Icons.check,
                                                color:
                                                    AppColors.BACKGROUND_COLOR,
                                                size: 10,
                                              ),
                                            ),
                                          )
                                        : Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: CircleAvatar(
                                              radius: 5,
                                              backgroundColor:
                                                  widget.chat!.online
                                                      ? Colors.green
                                                      : Colors.transparent,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                      ),
                      const Sizer(),
                      Flexible(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Label(
                                text: widget.isSecret
                                    ? 'Mxxx xxxl'
                                    : '${widget.chat?.name}',
                                style: Styles.mediumText(
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                              ),
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                widget.chat!.typing || widget.chat!.recording
                                    ? const SizedBox()
                                    : widget.chat!.lastMessage?.byMe ?? false
                                        ? widget.chat!.lastMessage?.seen ??
                                                false
                                            ? const Icon(
                                                FontAwesomeIcons.checkDouble,
                                                color:
                                                    AppColors.GREY_DARK_COLOR,
                                                size: 10,
                                              )
                                            : const Icon(
                                                FontAwesomeIcons.check,
                                                color:
                                                    AppColors.GREY_DARK_COLOR,
                                                size: 10,
                                              )
                                        : const SizedBox(),
                                if (widget.chat!.lastMessage?.seen ?? false)
                                  const SizedBox(width: 10),
                                widget.chat!.typing || widget.chat!.recording
                                    ? const SizedBox()
                                    : Expanded(
                                        child: Label(
                                            text: widget.chat?.lastMessage
                                                        ?.text ==
                                                    null
                                                ? context.isArabic
                                                    ? "لا توجد رسائل حتي الان"
                                                    : "No messages until now"
                                                : '${widget.chat?.lastMessage?.text}',
                                            style: Styles.mediumText(
                                              fontSize: 28,
                                              color: AppColors.DARK_GRAY_COLOR,
                                            )),
                                      ),
                                widget.chat!.typing
                                    ? Expanded(
                                        child: Label(
                                            text: context.isArabic
                                                ? "يكتب..."
                                                : "Typing...",
                                            style: Styles.mediumText(
                                              fontSize: 28,
                                              color: AppColors.SECONDARY_COLOR,
                                            )),
                                      )
                                    : const SizedBox(),
                                widget.chat!.recording
                                    ? Expanded(
                                        child: Label(
                                            text: context.isArabic
                                                ? "يسجل رساله صوتية..."
                                                : "Recording...",
                                            style: Styles.mediumText(
                                              fontSize: 28,
                                              color: AppColors.SECONDARY_COLOR,
                                            )),
                                      )
                                    : const SizedBox(),
                                const SizedBox(height: 10),
                                widget.chat!.muted
                                    ? const Icon(
                                        Icons.volume_off,
                                        color: Colors.grey,
                                        size: 17,
                                      )
                                    : const SizedBox(),
                                widget.chat!.isPinned
                                    ? const Icon(
                                        Icons.push_pin,
                                        color: Colors.grey,
                                        size: 17,
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      widget.chat?.unreadCount == 0
                          ? const SizedBox()
                          : CircleAvatar(
                              maxRadius: 10,
                              backgroundColor: AppColors.PRIMARY_COLOR,
                              child: Label(
                                  text: '${widget.chat?.unreadCount}',
                                  style: Styles.mediumText(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )),
                            ),
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          Label(
                              text: '${widget.chat?.lastMessage?.time}',
                              style: Styles.mediumText(color: Colors.grey)),
                          widget.chat?.lastSeenCount == null
                              ? const SizedBox()
                              : GestureDetector(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Label(
                                          text: '${widget.chat?.lastSeenCount}',
                                          style: Styles.mediumText(
                                              color: Colors.grey)),
                                      const SizedBox(width: 10),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        child: InkWell(
                                          onTap: () async {
                                            // Call the getLastSeen function
                                            await context
                                                .read<ChatsCubit>()
                                                .getChatLastSeen(
                                                    chatId: widget.chat!.id);

                                            // Open a scrollable bottom sheet
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              constraints: BoxConstraints(
                                                maxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.9,
                                              ),
                                              shape:
                                                  const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                        top: Radius.circular(
                                                            20)),
                                              ),
                                              builder: (context) {
                                                // Ensure the context has access to ChatsCubit using BlocProvider
                                                return BlocProvider<
                                                    ChatsCubit>.value(
                                                  value: widget.chatsCubit!,
                                                  child: Builder(
                                                    builder: (context) {
                                                      return BlocBuilder<
                                                          ChatsCubit,
                                                          ChatsState>(
                                                        builder:
                                                            (context, state) {
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(16.0),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                // Header
                                                                Text(
                                                                  context.isArabic
                                                                      ? "سجل مشاهدات الدردشة"
                                                                      : 'Chat Views History',
                                                                  style:
                                                                      const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                    height: 16),
                                                                // List of last seen chats
                                                                if (widget
                                                                    .chatsCubit!
                                                                    .lastSeenChats
                                                                    .isEmpty)
                                                                  Center(
                                                                    child: Text(
                                                                      context.isArabic
                                                                          ? "لا يوجد بيانات"
                                                                          : 'No data available',
                                                                      style: const TextStyle(
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                  )
                                                                else
                                                                  Flexible(
                                                                    child: ListView
                                                                        .builder(
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount: widget
                                                                          .chatsCubit!
                                                                          .lastSeenChats
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        final chat = widget
                                                                            .chatsCubit!
                                                                            .lastSeenChats[index];
                                                                        return Padding(
                                                                          padding: const EdgeInsets
                                                                              .symmetric(
                                                                              vertical: 8.0),
                                                                          child:
                                                                              Card(
                                                                            elevation:
                                                                                3,
                                                                            shape:
                                                                                RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                            ),
                                                                            child:
                                                                                ListTile(
                                                                              leading: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(50),
                                                                                child: CircleAvatar(
                                                                                  radius: 25,
                                                                                  child: Image.network(
                                                                                    widget.chat!.avatar,
                                                                                    fit: BoxFit.cover,
                                                                                    errorBuilder: (context, error, stackTrace) {
                                                                                      return Image.network(
                                                                                        UIConst.profilePlaceHolder,
                                                                                        fit: BoxFit.cover,
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              title: Text(
                                                                                chat.name,
                                                                                style: const TextStyle(
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),
                                                                              ),
                                                                              subtitle: Text(
                                                                                '${chat.date} - ${chat.time}',
                                                                                style: const TextStyle(
                                                                                  color: Colors.grey,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: const Icon(
                                            FontAwesomeIcons.eye,
                                            color: Colors.grey,
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                        ],
                      ),
                    ],
                  ),
                ),
                // Container(
                //   height: 0.4,
                //   width: MediaQuery.of(context).size.width,
                //   color: AppColors.GREY_DARK_COLOR,
                // ),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        // ignore: unrelated_type_equality_checks
        if (state.status == ChatsStates.typing &&
            widget.chat!.id == state.listenToTypingParams!.chatId) {
          setState(() {
            widget.chat!.typing = state.listenToTypingParams!.isTyping;
            log("typing chat card = ${widget.chat!.typing}");
          });
        }
        // ignore: unrelated_type_equality_checks
        if (state.status == ChatsStates.recording &&
            widget.chat!.id == state.listenToRecordingParams!.chatId) {
          setState(() {
            widget.chat!.recording = state.listenToRecordingParams!.isRecording;
            log("recording chat card = ${widget.chat!.recording}");
          });
        }
      },
    );
  }
}
