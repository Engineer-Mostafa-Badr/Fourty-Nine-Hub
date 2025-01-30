// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/forward_messages_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/label_colors_map.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class ChatRoomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ChatRoomAppBar({super.key, required this.chatRoomCubit});
  final ChatRoomCubit chatRoomCubit;

  @override
  State<ChatRoomAppBar> createState() => _ChatRoomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ChatRoomAppBarState extends State<ChatRoomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRoomCubit, ChatRoomState>(
      builder: (context, state) {
        return Column(
          children: [
            BlocConsumer<ChatsCubit, ChatsState>(
              listener: (context, state) {
                // ignore: unrelated_type_equality_checks
                if (state.status == ChatsStates.typing &&
                    context.read<ChatsCubit>().selectedChat.id ==
                        state.listenToTypingParams!.chatId) {
                  setState(() {
                    context.read<ChatsCubit>().selectedChat.typing =
                        state.listenToTypingParams!.isTyping;
                    log("typing chat card = ${context.read<ChatsCubit>().selectedChat.typing}");
                  });
                }
                // ignore: unrelated_type_equality_checks
                if (state.status == ChatsStates.recording &&
                    context.read<ChatsCubit>().selectedChat.id ==
                        state.listenToRecordingParams!.chatId) {
                  setState(() {
                    context.read<ChatsCubit>().selectedChat.recording =
                        state.listenToRecordingParams!.isRecording;
                    log("recording chat card = ${context.read<ChatsCubit>().selectedChat.recording}");
                  });
                }
              },
              builder: (context, state) {
                return AppBar(
                  backgroundColor: AppColors.PRIMARY_COLOR, // Background color
                  elevation: 0,
                  leadingWidth: 26,
                  leading: IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                  title: widget.chatRoomCubit.selectedMessages.isEmpty
                      ? GestureDetector(
                          onTap:
                              context.read<ChatsCubit>().selectedChat.isAdmin ==
                                      "admin"
                                  ? null
                                  : () => context.push(Routes.VIEWCONTACT,
                                      extra: context.read<ChatsCubit>()),
                          child: Row(
                            children: [
                              context.read<ChatsCubit>().selectedChat.avatar !=
                                      ""
                                  ? InkWell(
                                      onTap: context
                                              .read<ChatsCubit>()
                                              .selectedChat
                                              .hasStory
                                          ? () {
                                              // navigate to stories
                                            }
                                          : null,
                                      child: Container(
                                        height: kToolbarHeight * .8,
                                        width: kToolbarHeight * .8,
                                        decoration: context
                                                .read<ChatsCubit>()
                                                .selectedChat
                                                .hasStory
                                            ? BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                border: Border.all(
                                                  color: AppColors
                                                      .PRIMARY_COLOR_DARK,
                                                  width: 3,
                                                ))
                                            : null,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          backgroundImage: NetworkImage(
                                            context
                                                .read<ChatsCubit>()
                                                .selectedChat
                                                .avatar,
                                          ),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: context
                                              .read<ChatsCubit>()
                                              .selectedChat
                                              .hasStory
                                          ? () {
                                              // navigate to stories
                                            }
                                          : null,
                                      child: Container(
                                        height: kToolbarHeight * .8,
                                        width: kToolbarHeight * .8,
                                        decoration: context
                                                .read<ChatsCubit>()
                                                .selectedChat
                                                .hasStory
                                            ? BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                border: Border.all(
                                                  color: AppColors
                                                      .PRIMARY_COLOR_DARK,
                                                  width: 3,
                                                ))
                                            : null,
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.white,
                                          backgroundImage: NetworkImage(
                                            UIConst.profilePlaceHolder,
                                          ),
                                        ),
                                      ),
                                    ),
                              const SizedBox(width: 12),
                              SizedBox(
                                height: 60,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      children: [
                                        Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.4),
                                              child: Text(
                                                context
                                                    .read<ChatsCubit>()
                                                    .selectedChat
                                                    .name,
                                                // 'state.chatData?.chat?.contact?.name',
                                                overflow: TextOverflow.ellipsis,
                                                style: Styles.headerText(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ),
                                            context
                                                        .read<ChatsCubit>()
                                                        .selectedChat
                                                        .isAdmin ==
                                                    "admin"
                                                ? Positioned(
                                                    right: context.isArabic
                                                        ? 0
                                                        : -72,
                                                    left: context.isArabic
                                                        ? -72
                                                        : 0,
                                                    child: const Icon(
                                                      Icons.verified,
                                                      color: Colors.blue,
                                                      size: 20,
                                                    ),
                                                  )
                                                : const SizedBox(),
                                          ],
                                        ),
                                      ],
                                    ),
                                    context
                                            .read<ChatsCubit>()
                                            .selectedChat
                                            .typing
                                        ? Label(
                                            text: context.isArabic
                                                ? "يكتب..."
                                                : "Typing...",
                                            style: Styles.mediumText(
                                              fontSize: 24,
                                              color: Colors.white,
                                            ))
                                        : const SizedBox(),
                                    context
                                            .read<ChatsCubit>()
                                            .selectedChat
                                            .recording
                                        ? Label(
                                            text: context.isArabic
                                                ? "يسجل رساله صوتية..."
                                                : "Recording...",
                                            style: Styles.mediumText(
                                              fontSize: 24,
                                              color: Colors.white,
                                            ))
                                        : const SizedBox(),
                                    (!context
                                                .read<ChatsCubit>()
                                                .selectedChat
                                                .typing &&
                                            !context
                                                .read<ChatsCubit>()
                                                .selectedChat
                                                .recording)
                                        ? context
                                                    .read<ChatsCubit>()
                                                    .selectedChat
                                                    .isAdmin ==
                                                "admin"
                                            ? Label(
                                                text: context.isArabic
                                                    ? "حساب 49Hub الرسمي."
                                                    : "Official 49Hub Account.",
                                                style: Styles.mediumText(
                                                  fontSize: 24,
                                                  color: Colors.white,
                                                ))
                                            : Label(
                                                text: context
                                                        .read<ChatsCubit>()
                                                        .selectedChat
                                                        .online
                                                    ? context.isArabic
                                                        ? "متصل"
                                                        : "Online"
                                                    : context.isArabic
                                                        ? " اخر ظهور في ${context.read<ChatsCubit>().selectedChat.lastSeen}"
                                                        : "Last seen at ${context.read<ChatsCubit>().selectedChat.lastSeen}",
                                                style: Styles.mediumText(
                                                  fontSize: 24,
                                                  color: Colors.white,
                                                ))
                                        : const SizedBox(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          widget.chatRoomCubit.selectedMessages.length
                              .toString(),
                          // 'state.chatData?.chat?.contact?.name',
                          overflow: TextOverflow.ellipsis,
                          style: Styles.mediumText(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  actions: widget.chatRoomCubit.selectedMessages.isEmpty
                      ? context.read<ChatsCubit>().selectedChat.isAdmin ==
                              "admin"
                          ? []
                          : [
                              // video call
                              IconAppButton(
                                icon: Icons.videocam,
                                size: 24,
                                onPressed: () {},
                                color: Colors.white,
                              ),
                              const Sizer(
                                width: 20,
                              ),
                              // call
                              IconAppButton(
                                icon: Icons.call,
                                size: 20,
                                onPressed: () {},
                                color: Colors.white,
                              ),
                              PopupMenuButton(
                                icon: const Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                ),
                                color: context.isDarkMode
                                    ? AppColors.PRIMARY_COLOR
                                    : AppColors.BACKGROUND_COLOR,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16.0)),
                                ),
                                offset: const Offset(0, 50),
                                onSelected: (int value) async {
                                  if (value == 0) {
                                    context.push(Routes.VIEWCONTACT,
                                        extra: context.read<ChatsCubit>());
                                  }
                                  if (value == 1) {
                                    context.push(
                                      Routes.ATTACHMENTSVIEW,
                                      extra: widget.chatRoomCubit,
                                    );
                                  }
                                  if (value == 5) {
// Show alert dialog when "Clear Chat" is selected
                                    _showClearChatAlert(
                                        context, widget.chatRoomCubit);
                                  }
                                  if (value == 6) {
                                    await widget.chatRoomCubit.getLabels();
                                    _showLabelChatBottomSheet(
                                        context, widget.chatRoomCubit);
                                  }
                                },
                                itemBuilder: (context) {
                                  return _mainMenuBuilder(context);
                                },
                              )
                            ]
                      : [
                          widget.chatRoomCubit.selectedMessages.length == 1
                              ? IconAppButton(
                                  icon: Icons.copy,
                                  size: 20,
                                  onPressed: () async {
                                    await widget.chatRoomCubit.copyMessage(
                                      widget
                                          .chatRoomCubit.selectedMessages.first,
                                    );
                                    widget.chatRoomCubit
                                        .clearSelectedMessages();
                                  },
                                  color: Colors.white,
                                )
                              : const SizedBox(),
                          const Sizer(width: 15),
                          widget.chatRoomCubit.selectedMessages.length == 1
                              ? IconButton(
                                  onPressed: () async {
                                    await widget.chatRoomCubit.pinMessage(
                                      message: widget
                                          .chatRoomCubit.selectedMessages.first,
                                    );
                                  },
                                  icon: const Icon(Icons.push_pin),
                                  color: Colors.white,
                                )
                              : const SizedBox(),
                          const Sizer(width: 15),
                          IconButton(
                            onPressed: () async {
                              // await context.read<ChatsCubit>().deleteChat();
                              await widget.chatRoomCubit.deleteMessages();
                            },
                            icon: const Icon(
                              Icons.delete_forever,
                              color: Colors.white,
                            ),
                          ),
                          const Sizer(width: 15),
                          IconButton(
                            onPressed: () async {
                              context.push(
                                Routes.FORWARDMESSAGES,
                                extra: ForwardMessagesViewParams(
                                  chatRoomCubit: widget.chatRoomCubit,
                                  chatsCubit: context.read<ChatsCubit>(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.shortcut,
                              color: Colors.white,
                            ),
                          ),
                        ],
                );
              },
            ),
            widget.chatRoomCubit.chat.pinnedMessageId != null
                ? _buildPinnedMessageCard(context)
                : const SizedBox(),
          ],
        );
      },
    );
  }

  void _showLabelChatBottomSheet(
      BuildContext context, ChatRoomCubit chatRoomCubit) {
    log("lables length : ${chatRoomCubit.chat.lables.length}");

    TextEditingController newLabelController = TextEditingController();
    bool isEditingNewLabel = false;
    String newLabelColor = LabelColorsMap.getRandomColor();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height *
            0.9, // Set height to 90% of screen height
      ),
      builder: (BuildContext context) {
        return BlocProvider.value(
          value: chatRoomCubit,
          child: BlocBuilder<ChatRoomCubit, ChatRoomState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      width: 50,
                      height: 4,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.isArabic ? "اضافة علامة للمحادثة" : "Label Chat",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return ListView.builder(
                            itemCount: chatRoomCubit.chat.lables.length + 1,
                            itemBuilder: (context, index) {
                              log("lables length before index: ${chatRoomCubit.chat.lables.length}");
                              log("index : $index");

                              if (index == 0) {
                                if (isEditingNewLabel) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              newLabelColor = LabelColorsMap.getRandomColor();
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: LabelColorsMap.getColor(
                                                  newLabelColor),
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            child: const Icon(
                                                Icons.label_outlined,
                                                color: Colors.white),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Theme(
                                            data: ThemeData(
                                              primaryColor: AppColors
                                                  .PRIMARY_COLOR, // تحديد اللون الأساسي
                                              inputDecorationTheme:
                                                  InputDecorationTheme(
                                                focusedBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppColors
                                                        .PRIMARY_COLOR, // تحديد اللون للحد السفلي
                                                    width:
                                                        2.0, // تعديل سمك الحد السفلي
                                                  ),
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppColors
                                                        .PRIMARY_COLOR
                                                        .withOpacity(
                                                            0.5), // تغيير اللون عند عدم التركيز
                                                    width: 2.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            child: TextField(
                                              controller: newLabelController,
                                              onChanged: (value) =>
                                                  setState(() {}),
                                              decoration: InputDecoration(
                                                hintText: context.isArabic
                                                    ? "اسم العلامة"
                                                    : "New Label",
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        newLabelController.text.isNotEmpty
                                            ? IconButton(
                                                icon: const Icon(Icons.check,
                                                    color: AppColors
                                                        .PRIMARY_COLOR_DARK),
                                                onPressed: () async {
                                                  await chatRoomCubit
                                                      .createLable(
                                                          name:
                                                              newLabelController
                                                                  .text,
                                                          color: newLabelColor);
                                                  setState(() {
                                                    isEditingNewLabel = false;
                                                    newLabelController.clear();
                                                  });
                                                },
                                              )
                                            : IconButton(
                                                icon: const Icon(Icons.close,
                                                    color: AppColors
                                                        .PRIMARY_COLOR_DARK),
                                                onPressed: () async {
                                                  setState(() {
                                                    isEditingNewLabel = false;
                                                    newLabelController.clear();
                                                  });
                                                },
                                              ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        isEditingNewLabel = true;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 4.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            padding: const EdgeInsets.all(10),
                                            child: const Icon(Icons.add,
                                                color: Colors.black),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            context.isArabic
                                                ? "علامة جديدة"
                                                : "New Label",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              } else {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: LabelColorsMap.getColor(
                                              chatRoomCubit.chat
                                                  .lables[index - 1].color),
                                          shape: BoxShape.circle,
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        child: const Icon(Icons.label_outlined,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        chatRoomCubit
                                            .chat.lables[index - 1].name,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      const Spacer(),
                                      Checkbox(
                                        value: chatRoomCubit
                                            .chat.lables[index - 1].isSelected,
                                        activeColor:
                                            AppColors.PRIMARY_COLOR_DARK,
                                        checkColor: Colors.white,
                                        onChanged: (bool? newValue) {
                                          chatRoomCubit.updateLabelSelection(
                                              index - 1, newValue);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity, // Full width of the screen
                      padding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16), // Padding for the button
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          backgroundColor:
                              AppColors.PRIMARY_COLOR, // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () async {
                          // Action to save or perform when Save is tapped
                          await chatRoomCubit.assignLabels();
                          Navigator.pop(context);
                        },
                        child: Text(
                          context.isArabic ? "حفظ" : "Save",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildPinnedMessageCard(BuildContext context) {
    return BlocBuilder<ChatRoomCubit, ChatRoomState>(
      builder: (context, state) {
        return widget.chatRoomCubit.chat.pinnedMessage == null
            ? const SizedBox()
            : Container(
                width: double.infinity,
                // height: 50,
                color: AppColors.PRIMARY_COLOR,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.push_pin,
                        size: 20,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(width: 8),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.8),
                        child: Text(
                          widget.chatRoomCubit.chat.pinnedMessage!.text,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.mediumText(color: Colors.white),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () async {
                          await widget.chatRoomCubit.unpinMessage();
                        },
                        child: Icon(
                          Icons.close,
                          size: 20,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      )
                    ],
                  ),
                ),
              );
      },
    );
  }

  List<PopupMenuEntry<int>> _mainMenuBuilder(BuildContext context) {
    return [
      PopupMenuItem<int>(
        value: 0,
        child: Text(
          LocaleKeys.viewContact.tr(),
          style: Styles.mediumText(
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 1,
        child: Text(
          LocaleKeys.mediaLinksAndDocs.tr(),
          style: Styles.mediumText(
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 2,
        child: Text(
          LocaleKeys.search.tr(),
          style: Styles.mediumText(
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 3,
        child: Text(
          LocaleKeys.muteNotifications.tr(),
          style: Styles.mediumText(
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
        ),
      ),
      // PopupMenuItem<int>(
      //   value: 4,
      //   child: Text(
      //     LocaleKeys.wallpaper.tr(),
      //     style: Styles.mediumText(
      //         color:
      //             context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
      //   ),
      // ),
      // PopupMenuItem<int>(
      //   value: 5,
      //   child: Text(
      //     LocaleKeys.disappearingMessages.tr(),
      //     style: Styles.mediumText(
      //         color:
      //             context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
      //   ),
      // ),
      // PopupMenuItem<int>(
      //   value: 6,
      //   child: Row(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       Text(
      //         LocaleKeys.more.tr(),
      //         style: Styles.mediumText(
      //             color: context.isDarkMode
      //                 ? Colors.white
      //                 : AppColors.PRIMARY_COLOR),
      //       ),
      //       const Spacer(),
      //       Icon(
      //         Icons.arrow_forward_ios,
      //         size: 22,
      //         color:
      //             context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
      //       )
      //     ],
      //   ),
      // ),
      PopupMenuItem<int>(
        value: 4,
        child: Text(
          LocaleKeys.block.tr(),
          style: Styles.mediumText(
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 5,
        // onTap: () {
        //   // Show alert dialog when "Clear Chat" is selected
        //   _showClearChatAlert(context, chatRoomCubit);
        // },
        child: Text(
          LocaleKeys.clearChat.tr(),
          style: Styles.mediumText(
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 6,
        child: Text(
          context.isArabic ? "اضافة علامة للمحادثة" : "Label Chat",
          style: Styles.mediumText(
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
        ),
      ),
    ];
  }

  void _showMoreMenu(BuildContext context, ChatRoomCubit chatRoomCubit) {
    showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(LocaleKeys.more.tr() != "More" ? 0 : 250,
          78, LocaleKeys.more.tr() == "More" ? 0 : 250, 0),
      items: [
        PopupMenuItem<int>(
          value: 1,
          child: Text(
            LocaleKeys.edit.tr(),
            style: Styles.mediumText(
                color: context.isDarkMode
                    ? Colors.white
                    : AppColors.PRIMARY_COLOR),
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Text(
            LocaleKeys.share.tr(),
            style: Styles.mediumText(
                color: context.isDarkMode
                    ? Colors.white
                    : AppColors.PRIMARY_COLOR),
          ),
        ),
        PopupMenuItem<int>(
          value: 3,
          child: Text(
            LocaleKeys.report.tr(),
            style: Styles.mediumText(
                color: context.isDarkMode
                    ? Colors.white
                    : AppColors.PRIMARY_COLOR),
          ),
        ),
        PopupMenuItem<int>(
          value: 4,
          child: Text(
            LocaleKeys.block.tr(),
            style: Styles.mediumText(
                color: context.isDarkMode
                    ? Colors.white
                    : AppColors.PRIMARY_COLOR),
          ),
        ),
        PopupMenuItem<int>(
          value: 5,
          onTap: () {
            // Show alert dialog when "Clear Chat" is selected
            _showClearChatAlert(context, chatRoomCubit);
          },
          child: Text(
            LocaleKeys.clearChat.tr(),
            style: Styles.mediumText(
                color: context.isDarkMode
                    ? Colors.white
                    : AppColors.PRIMARY_COLOR),
          ),
        ),
        PopupMenuItem<int>(
          value: 6,
          child: Text(
            LocaleKeys.exportChat.tr(),
            style: Styles.mediumText(
                color: context.isDarkMode
                    ? Colors.white
                    : AppColors.PRIMARY_COLOR),
          ),
        ),
        PopupMenuItem<int>(
          value: 7,
          child: Text(
            "${LocaleKeys.addShortcut.tr()}      ",
            style: Styles.mediumText(
                color: context.isDarkMode
                    ? Colors.white
                    : AppColors.PRIMARY_COLOR),
          ),
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      color: context.isDarkMode
          ? AppColors.PRIMARY_COLOR
          : AppColors.BACKGROUND_COLOR,
    );
  }

  void _showClearChatAlert(BuildContext context, ChatRoomCubit chatRoomCubit) {
    int selectedOption = 0; // To track the selected radio button

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(LocaleKeys.clearThisChat.tr()),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(
                      LocaleKeys.clearForMe.tr(),
                      style: Styles.mediumText(
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR),
                    ),
                    leading: Radio<int>(
                      value: 0,
                      activeColor: AppColors.PRIMARY_COLOR_DARK,
                      groupValue: selectedOption,
                      onChanged: (int? value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: Text(
                      LocaleKeys.clearForEveryone.tr(),
                      style: Styles.mediumText(
                          color: context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR),
                    ),
                    leading: Radio<int>(
                      value: 1,
                      activeColor: AppColors.PRIMARY_COLOR_DARK,
                      groupValue: selectedOption,
                      onChanged: (int? value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                LocaleKeys.cancel.tr(),
                style: Styles.mediumText(
                    color: context.isDarkMode
                        ? Colors.white
                        : AppColors.PRIMARY_COLOR),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                LocaleKeys.clearChat.tr(),
                style: Styles.mediumText(color: AppColors.PRIMARY_COLOR_DARK),
              ),
              onPressed: () async {
                await chatRoomCubit.clearChat(clearForAll: selectedOption == 1);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
