import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class ChatRoomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatRoomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
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
      title: BlocBuilder<ChatRoomCubit, ChatRoomState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => context.push(Routes.VIEWCONTACT,
                extra: context.read<ChatsCubit>().selectedChat.name),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(UIConst.profilePlaceHolder),
                ),
                const SizedBox(width: 12), // Spacing between avatar and text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.read<ChatsCubit>().selectedChat.name,
                      // 'state.chatData?.chat?.contact?.name',
                      overflow: TextOverflow.ellipsis,
                      style: Styles.headerText(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      actions: [
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
          color: AppColors.BACKGROUND_COLOR,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          offset: const Offset(0, 50),
          onSelected: (int value) async {
            if (value == 0) {
              context.push(Routes.VIEWCONTACT,
                  extra: context.read<ChatsCubit>().selectedChat.name);
            }
            if (value == 1) {
              context.push(Routes.ATTACHMENTSVIEW);
            }
            if (value == 6) {
              _showMoreMenu(context);
            }
          },
          itemBuilder: (context) {
            return _mainMenuBuilder();
          },
        )
      ],
    );
  }

  List<PopupMenuEntry<int>> _mainMenuBuilder() {
    return [
      PopupMenuItem<int>(
        value: 0,
        child: Text(
          LocaleKeys.viewContact.tr(),
          style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 1,
        child: Text(
          LocaleKeys.mediaLinksAndDocs.tr(),
          style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 2,
        child: Text(
          LocaleKeys.search.tr(),
          style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 3,
        child: Text(
          LocaleKeys.muteNotifications.tr(),
          style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 4,
        child: Text(
          LocaleKeys.wallpaper.tr(),
          style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 5,
        child: Text(
          LocaleKeys.disappearingMessages.tr(),
          style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 6,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              LocaleKeys.more.tr(),
              style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
            ),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 22,
              color: AppColors.PRIMARY_COLOR,
            )
          ],
        ),
      ),
    ];
  }

  void _showMoreMenu(BuildContext context) {
    showMenu<int>(
      context: context,
      position: RelativeRect.fromLTRB(LocaleKeys.more.tr() != "More" ? 0 : 250,
          78, LocaleKeys.more.tr() == "More" ? 0 : 250, 0),
      items: [
        PopupMenuItem<int>(
          value: 1,
          child: Text(
            LocaleKeys.edit.tr(),
            style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Text(
            LocaleKeys.share.tr(),
            style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
          ),
        ),
        PopupMenuItem<int>(
          value: 3,
          child: Text(
            LocaleKeys.report.tr(),
            style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
          ),
        ),
        PopupMenuItem<int>(
          value: 4,
          child: Text(
            LocaleKeys.block.tr(),
            style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
          ),
        ),
        PopupMenuItem<int>(
          value: 5,
          child: Text(
            LocaleKeys.clearChat.tr(),
            style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
          ),
        ),
        PopupMenuItem<int>(
          value: 6,
          child: Text(
            LocaleKeys.exportChat.tr(),
            style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
          ),
        ),
        PopupMenuItem<int>(
          value: 7,
          child: Text(
            "${LocaleKeys.addShortcut.tr()}      ",
            style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
          ),
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      color: AppColors.BACKGROUND_COLOR,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
