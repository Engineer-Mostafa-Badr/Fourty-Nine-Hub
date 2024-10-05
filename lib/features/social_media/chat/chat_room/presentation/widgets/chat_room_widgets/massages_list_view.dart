import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:swipe_to/swipe_to.dart';

import 'message_card.dart';

class MessagesListView extends StatelessWidget {
  const MessagesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final chatRoomCubit = context.read<ChatRoomCubit>();
    
    return BlocListener<ChatsCubit, ChatsState>(
      listener: (context, state) {
        if (state.isNewMessage && state.newMessage != null) {
          chatRoomCubit.addMessage(state.newMessage!);
        }
      },
      child: BlocBuilder<ChatRoomCubit, ChatRoomState>(
        builder: (context, state) {
          if (state.messages != null) {
            return Expanded(
              child: ListView.separated(
                  addAutomaticKeepAlives: true,
                  itemCount: state.messages?.length ?? 0,
                  controller: chatRoomCubit.scrollController,
                  itemBuilder: (context, index) => MessageCard(
                        messageEntity: state.messages![index],
                        anotherUserName: 'Anonymous',
                      ),
                  separatorBuilder: (context, index) => const Sizer(
                        height: 3,
                      )),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
