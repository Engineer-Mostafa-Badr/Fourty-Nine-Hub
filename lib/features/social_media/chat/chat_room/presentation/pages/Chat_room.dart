import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/global/loading_custom.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/service/socket_service.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/chat_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/room/delete_message_body.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:get_it/get_it.dart';
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
          // bottomNavigationBar: Padding(
          //   padding: MediaQuery.of(context).viewInsets,
          //   child: SendMessageWidget(
          //     focusNode: focusNode,
          //     replayMessage: _replayMessage,
          //     onCancelReplay: cancelReplay,
          //     anotherUserName:
          //         chatRoomCubit.chatMessagesModel.chat?.contact?.name ??
          //             'No name',
          //   ),
          // ),
          body: Column(
            children: [
              BlocBuilder<ChatRoomCubit, ChatRoomState>(
                  builder: (context, state) {
                return state.isLoading
                    ? LoadingCustom.customThreeBounce(context)
                    : const Expanded(
                        child: SizedBox(),
                        // child: ListView.separated(
                        //   addAutomaticKeepAlives: true,
                        //   controller: chatRoomCubit.scrollController,
                        //   // reverse: true,
                        //   // physics: const NeverScrollableScrollPhysics(),
                        //   itemBuilder: (context, index) => SwipeTo(
                        //     onRightSwipe: (message) {
                        //       replayMessage(state.chatMessages![index]);
                        //     },
                        //     child: GestureDetector(
                        //       onLongPress: () {
                        //         _showReplyDialog(
                        //           context,
                        //           messageEntity: state.chatMessages![index],
                        //           replyFunction: () {
                        //             Navigator.of(context).pop();
                        //             replayMessage(state.chatMessages![index]);
                        //           },
                        //           deleteFunction: () {
                        //             Navigator.of(context).pop();
                        //             deleteMessage(
                        //                 chatId:
                        //                     state.chatMessages![index].chatId!,
                        //                 messageId:
                        //                     state.chatMessages![index].sId!);
                        //           },
                        //         );
                        //       },
                        //       child: MessageCard(
                        //         messageEntity: state.chatMessages![index],
                        //         anotherUserName:
                        //             state.chatData?.chat?.contact?.name ??
                        //                 'No name',
                        //       ),
                        //     ),
                        //   ),
                        //   separatorBuilder: (context, index) => const Sizer(
                        //     height: 3,
                        //   ),
                        //   itemCount: state.chatMessages?.length ?? 0,
                        // ),
                      );
              }),
              const SendMessageWidget(
                  // focusNode: focusNode,
                  // replayMessage: _replayMessage,
                  // onCancelReplay: cancelReplay,
                  // anotherUserName:
                  //     chatRoomCubit.chatMessagesModel.chat?.contact?.name ??
                  //         'No name',
                  ),
            ],
          ),
        ),
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
