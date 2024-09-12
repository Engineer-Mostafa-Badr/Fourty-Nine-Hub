import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_cubit/chat_room_cubit.dart';

import 'message_card.dart';

class MessagesListView extends StatelessWidget {
  const MessagesListView({super.key});

  @override
  Widget build(BuildContext context) {
    final chatRoomCubit = context.read<ChatRoomCubit>();
    return BlocBuilder<ChatRoomCubit, ChatRoomState>(
      // buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.messages != null) {
          return ListView.separated(
              addAutomaticKeepAlives: true,
              itemCount: state.messages?.length ?? 0,
              controller: chatRoomCubit.scrollController,
              itemBuilder: (context, index) => GestureDetector(
                    onLongPress: () {
                      // _showReplyDialog(
                      //   context,
                      //   messageEntity: state.chatMessages![index],
                      //   replyFunction: () {
                      //     Navigator.of(context).pop();
                      //     replayMessage(state.chatMessages![index]);
                      //   },
                      //   deleteFunction: () {
                      //     Navigator.of(context).pop();
                      //     deleteMessage(
                      //         chatId: state.chatMessages![index].chatId!,
                      //         messageId: state.chatMessages![index].sId!);
                      //   },
                      // );
                    },
                    onHorizontalDragEnd: (details) {
                      chatRoomCubit
                          .selectMessageForReplaying(state.messages![index]);
                    },
                    child: MessageCard(
                      messageEntity: state.messages![index],
                      anotherUserName: 'Anonymous',
                      // state.chatData?.chat?.contact?.name ?? LocaleKeys.anonymous.tr(),
                    ),
                  ),
              separatorBuilder: (context, index) =>  Sizer(
                    height: 3.h,
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
