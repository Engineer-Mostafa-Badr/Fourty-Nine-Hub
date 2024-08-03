import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/loading_custom.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/chat_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:swipe_to/swipe_to.dart';
import '../widgets/room/message_card.dart';
import '../widgets/room/chat_room_app_bar.dart';
import '../widgets/room/send_message_widget.dart';

class ChatRoom extends StatefulWidget {
  final String? chatId;

  const ChatRoom({super.key, this.chatId});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late ChatRoomCubit chatRoomCubit;
  final focusNode = FocusNode();
  MessageEntity? _replayMessage;

  @override
  void initState() {
    super.initState();
    chatRoomCubit = context.read<ChatRoomCubit>()
      ..getChatMessages(widget.chatId!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.GREY_LIGHT_COLOR,
          appBar: const ChatRoomAppBar(),
          bottomNavigationBar: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: SendMessageWidget(
              focusNode: focusNode,
              replayMessage: _replayMessage,
              onCancelReplay: cancelReplay,
            ),
          ),
          body: BlocBuilder<ChatRoomCubit, ChatRoomState>(
              builder: (context, state) {
            return state.isLoading
                ? LoadingCustom.customThreeBounce(context)
                : ListView.separated(
                    reverse: true,
                    // physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => SwipeTo(
                      onRightSwipe: (message) {
                        // replay
                        replayMessage(state.chatMessages![index]);
                        // make cursor focus to write replay
                        focusNode.requestFocus();
                      },
                      child: MessageCard(
                        messageEntity: state.chatMessages![index],
                      ),
                    ),
                    separatorBuilder: (context, index) => const Sizer(
                      height: 3,
                    ),
                    itemCount: state.chatMessages?.length ?? 0,
                  );
          }),
        ),
      ),
    );
  }

  replayMessage(MessageEntity messageEntity) {
    setState(() {
      _replayMessage = messageEntity;
    });
  }

  cancelReplay() {
    setState(() {
      _replayMessage = null;
    });
  }
}
