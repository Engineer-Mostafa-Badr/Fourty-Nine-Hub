import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/chat_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import '../widgets/room/message_card.dart';
import '../widgets/room/chat_room_app.dart';
import '../widgets/room/send_message_widget.dart';

class ChatRoom extends StatefulWidget {
  final String? chatId;

  const ChatRoom({super.key, this.chatId});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late ChatRoomCubit chatRoomCubit;

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
            child: const SendMessageWidget(),
          ),
          body: BlocBuilder<ChatRoomCubit, ChatRoomState>(
              builder: (context, state) {
                print("state.chatMessages?.length ${state.chatMessages?.length}");
            return ListView.separated(
              reverse: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => MessageCard(
               messageEntity: state.chatMessages![index],
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
}
