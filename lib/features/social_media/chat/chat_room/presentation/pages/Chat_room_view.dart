import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/delete_message_body.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/masseges_list_view.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import '../widgets/chat_room_app_bar.dart';
import '../widgets/send_message_widget.dart';

class ChatRoomView extends StatefulWidget {
  final String? chatId;

  const ChatRoomView({super.key, this.chatId});

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
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
    return const Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: ChatRoomAppBar(),
      body: Column(
        children: [
          MessagesListView(),
          SendMessageWidget(),
        ],
      ),
    );
  }

  replayMessage(MessageEntity messageEntity) {
    setState(() {
      _replayMessage = messageEntity;
    });
    // make cursor focus to write replay
    focusNode.requestFocus();
  }

  deleteMessage({required String chatId, required String messageId}) {
    bottomSheet(
        context: context,
        widget: DeleteMessageBody(
          deleteMessageFunction: () {
            chatRoomCubit.deleteMessage(chatId: chatId, messageId: messageId);
            Navigator.of(context).pop();
          },
        ));
  }

  cancelReplay() {
    setState(() {
      _replayMessage = null;
    });
  }

  void _showReplyDialog(
    BuildContext context, {
    required MessageEntity messageEntity,
    required VoidCallback replyFunction,
    required VoidCallback deleteFunction,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            insetPadding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0),
            ),
            backgroundColor: Colors.transparent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    color: AppColors.PRIMARY_COLOR.withOpacity(.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Label(
                      text: "${messageEntity.text}",
                      style: Styles.headerText(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Container(
                    margin: const EdgeInsets.only(right: 50),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(5),
                      ),
                      color: AppColors.PRIMARY_COLOR.withOpacity(.8),
                    ),
                    child: Column(
                      children: [
                        // reply message
                        InkWell(
                          onTap: replyFunction,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Label(
                                  text: "Replay",
                                  style: Styles.headerText(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const Icon(
                                  Icons.replay,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Divider(),

                        //  delete message
                        InkWell(
                          onTap: deleteFunction,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Label(
                                  text: "Delete",
                                  style: Styles.headerText(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const Icon(
                                  Icons.delete,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}
