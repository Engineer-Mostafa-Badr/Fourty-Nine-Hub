import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:swipe_to/swipe_to.dart';

import 'message_card.dart';

class MessagesListView extends StatelessWidget {
  const MessagesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final chatRoomCubit = context.read<ChatRoomCubit>();
    return BlocBuilder<ChatRoomCubit, ChatRoomState>(
      builder: (context, state) {
        if (state.messages != null) {
          return ListView.separated(
              addAutomaticKeepAlives: true,
              itemCount: state.messages?.length ?? 0,
              controller: chatRoomCubit.scrollController,
              itemBuilder: (context, index) => SwipeTo(
                    onLeftSwipe: (details) {
                      chatRoomCubit
                          .selectMessageForReplaying(state.messages![index]);
                    },
                    child: MessageCard(
                      messageEntity: state.messages![index],
                      anotherUserName: 'Anonymous',
                      // state.chatData?.chat?.contact?.name ?? LocaleKeys.anonymous.tr(),
                    ),
                  ),
              separatorBuilder: (context, index) => const Sizer(
                    height: 3,
                  ));
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
