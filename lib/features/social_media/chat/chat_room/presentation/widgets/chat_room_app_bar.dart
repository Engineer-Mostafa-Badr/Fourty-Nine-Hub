import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';

class ChatRoomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatRoomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight + 20,
      padding: const EdgeInsets.only(bottom: 5, top: 24),
      decoration: const BoxDecoration(
        color: AppColors.PRIMARY_COLOR,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          const CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(UIConst.profilePlaceHolder),
          ),
          const Sizer(),
          Expanded(
            child: BlocBuilder<ChatRoomCubit, ChatRoomState>(
                builder: (context, state) {
              return 'state.chatData?.chat?.contact?.name' == null
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () => context.push(Routes.VIEWCONTACT),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          'state.chatData?.chat?.contact?.name' == null
                              ? const SizedBox()
                              : Row(
                                  children: [
                                    Expanded(
                                      child: Label(
                                        text: "Ahmed Nasr",
                                        // 'state.chatData?.chat?.contact?.name',
                                        style: Styles.headerText(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      child: SizedBox(
                                        width: 5,
                                        height: 5,
                                      ),
                                    )
                                  ],
                                ),
                        ],
                      ),
                    );
            }),
          ),
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
          // menu icon
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
                context.push(Routes.VIEWCONTACT);
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
      ),
    );
  }

  List<PopupMenuEntry<int>> _mainMenuBuilder() {
    return [
      PopupMenuItem<int>(
        value: 0,
        child: Text(
          "View Contact",
          style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 1,
        child: Text(
          "Media, Links and docs",
          style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 2,
        child: Text(
          "Search",
          style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 3,
        child: Text(
          "Mute notifications",
          style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 4,
        child: Text(
          "Wallpaper",
          style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 5,
        child: Text(
          "Disappearing messages",
          style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
        ),
      ),
      PopupMenuItem<int>(
        value: 6,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "More",
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
      position: const RelativeRect.fromLTRB(250, 74, 0, 0),
      items: [
        PopupMenuItem<int>(
          value: 1,
          child: Text(
            "Edit",
            style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Text(
            "Share",
            style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
          ),
        ),
        PopupMenuItem<int>(
          value: 3,
          child: Text(
            "Report",
            style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
          ),
        ),
        PopupMenuItem<int>(
          value: 4,
          child: Text(
            "Block",
            style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
          ),
        ),
        PopupMenuItem<int>(
          value: 5,
          child: Text(
            "Clear chat",
            style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
          ),
        ),
        PopupMenuItem<int>(
          value: 6,
          child: Text(
            "Export chat",
            style: Styles.mediumText(color: AppColors.PRIMARY_COLOR),
          ),
        ),
        PopupMenuItem<int>(
          value: 7,
          child: Text(
            "Add shortcut      ",
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
