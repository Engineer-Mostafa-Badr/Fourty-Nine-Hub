import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/pages/forward_messages_view.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class ChatRoomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatRoomAppBar({super.key, required this.chatRoomCubit});
  final ChatRoomCubit chatRoomCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatRoomCubit, ChatRoomState>(
      builder: (context, state) {
        return Column(
          children: [
            AppBar(
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
              title: chatRoomCubit.selectedMessages.isEmpty
                  ? GestureDetector(
                      onTap: () => context.push(Routes.VIEWCONTACT,
                          extra:
                              context.read<ChatsCubit>().selectedChat.name),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                NetworkImage(UIConst.profilePlaceHolder),
                          ),
                          const SizedBox(
                              width: 12), // Spacing between avatar and text
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
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
                            ],
                          ),
                        ],
                      ),
                    )
                  : Text(
                      chatRoomCubit.selectedMessages.length.toString(),
                      // 'state.chatData?.chat?.contact?.name',
                      overflow: TextOverflow.ellipsis,
                      style: Styles.mediumText(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              actions: chatRoomCubit.selectedMessages.isEmpty
                  ? [
                      // video call
                      IconAppButton(
                        icon: Icons.videocam,
                        size: 24,
                        onPressed: () {},
                        color: Colors.white,
                      ),
                      const Sizer(
                        width: 15,
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
                                extra: context
                                    .read<ChatsCubit>()
                                    .selectedChat
                                    .name);
                          }
                          if (value == 1) {
                            context.push(
                              Routes.ATTACHMENTSVIEW,
                              extra: chatRoomCubit,
                            );
                          }
                          if (value == 6) {
                            _showMoreMenu(context, chatRoomCubit);
                          }
                        },
                        itemBuilder: (context) {
                          return _mainMenuBuilder(context);
                        },
                      )
                    ]
                  : [
                      chatRoomCubit.selectedMessages.length == 1
                          ? IconAppButton(
                              icon: Icons.copy,
                              size: 20,
                              onPressed: () async {
                                await chatRoomCubit.copyMessage(
                                  chatRoomCubit.selectedMessages.first,
                                );
                                chatRoomCubit.clearSelectedMessages();
                              },
                              color: Colors.white,
                            )
                          : const SizedBox(),
                      const Sizer(width: 15),
                      chatRoomCubit.selectedMessages.length == 1
                          ? IconButton(
                              onPressed: () async {
                                await chatRoomCubit.pinMessage(
                                  message:
                                      chatRoomCubit.selectedMessages.first,
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
                                chatRoomCubit: chatRoomCubit,
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
            ),
            chatRoomCubit.chat.pinnedMessageId != null
                ? _buildPinnedMessageCard(context)
                : const SizedBox(),
          ],
        );
      },
    );
  }

  Widget _buildPinnedMessageCard(BuildContext context) {
    return BlocBuilder<ChatRoomCubit, ChatRoomState>(
      builder: (context, state) {
        return chatRoomCubit.chat.pinnedMessage == null? const SizedBox(): Container(
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
                    chatRoomCubit.chat.pinnedMessage!.text,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.mediumText(color: Colors.white),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () async {
                    await chatRoomCubit.unpinMessage();
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
      PopupMenuItem<int>(
        value: 4,
        child: Text(
          LocaleKeys.wallpaper.tr(),
          style: Styles.mediumText(
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 5,
        child: Text(
          LocaleKeys.disappearingMessages.tr(),
          style: Styles.mediumText(
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 6,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.more.tr(),
              style: Styles.mediumText(
                  color: context.isDarkMode
                      ? Colors.white
                      : AppColors.PRIMARY_COLOR),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 22,
              color:
                  context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
            )
          ],
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
