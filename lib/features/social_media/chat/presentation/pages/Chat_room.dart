import 'package:flutter/material.dart';
import '../../../../../common/widgets/dynamic/sizer.dart';
import '../widgets/room/message_card.dart';

import '../../../../../res/style/app_colors.dart';
import '../widgets/room/chat_room_app.dart';
import '../widgets/room/send_message_widget.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: ()=> FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: AppColors.GREY_LIGHT_COLOR,
          appBar: const ChatRoomAppBar(),
          bottomNavigationBar: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: const SendMessageWidget(),
          ),
          body: ListView.separated(
              reverse: true,
              itemBuilder: (context, index) => MessageCard(
                    isMine: index.isEven,
                  ),
              separatorBuilder: (context, index) => const Sizer(
                    height: 3,
                  ),
              itemCount: 10,
          ),
        ),
      ),
    );
  }
}
