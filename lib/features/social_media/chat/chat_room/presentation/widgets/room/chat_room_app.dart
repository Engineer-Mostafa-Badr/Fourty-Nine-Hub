import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/chat_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

class ChatRoomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatRoomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kToolbarHeight,
      padding: const EdgeInsets.all(5),
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
              return state.chatData?.chat?.contact?.name == null
                  ? const SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        state.chatData?.chat?.contact?.name == null
                            ? const SizedBox()
                            : Label(
                                text: '${state.chatData?.chat?.contact?.name}',
                                style: Styles.headerText(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                        // Row(
                        //   children: [
                        //     const CircleAvatar(
                        //       radius: 3,
                        //       backgroundColor: Colors.red,
                        //     ),
                        //     const Sizer(),
                        //     state.chatData?.chat?.contact?.name == null
                        //         ? const SizedBox()
                        //         : Label(
                        //             text: 'Online',
                        //             style:
                        //                 Styles.mediumText(color: Colors.white),
                        //           ),
                        //   ],
                        // )
                      ],
                    );
            }),
          ),
          IconAppButton(
            icon: Icons.videocam,
            size: 24,
            onPressed: () {},
            color: Colors.white,
          ),
          const Sizer(
            width: 15,
          ),
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
            itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Mute notifications"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("Delete Chat"),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text("Report"),
                ),
                const PopupMenuItem<int>(
                  value: 3,
                  child: Text("Block"),
                ),
              ];
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
