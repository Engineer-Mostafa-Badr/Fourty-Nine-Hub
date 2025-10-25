
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/assets/assets.dart';

import '../../../../../../core/widget/custom_scaffold.dart';
import '../../../../common/widgets/dynamic/sizer.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/const.dart';
import '../../../../service_locator/service_locator.dart';
import '../Controllers/cubits/conversation_states.dart';
import '../Controllers/cubits/conversations_cubit.dart';
import 'Widgets/conversation_app_bar.dart';
import 'Widgets/messages_list_view.dart';
import 'Widgets/send_message_widget.dart';

class ConversationScreen extends StatefulWidget {
  final String conversationId;

  const ConversationScreen({super.key, required this.conversationId});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen>
    with TickerProviderStateMixin {
  final focusNode = FocusNode();
  // bool isTyping = false;
  // bool isRecording = false;

  late AnimationController _typingController;
  late AnimationController _recordingController;
  late Animation<double> _typingAnimation;
  late Animation<double> _recordingAnimation;

  @override
  void initState() {
    super.initState();

    // Typing animation controller
    _typingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _typingAnimation =
        Tween<double>(begin: 0.9, end: 1.1).animate(_typingController);

    // Recording animation controller
    _recordingController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    _recordingAnimation =
        Tween<double>(begin: 0.8, end: 1.2).animate(_recordingController);
  }

  @override
  void dispose() {
    _typingController.dispose();
    _recordingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = LocaleKeys.more.tr() == "More";
    return PopScope(
      onPopInvokedWithResult: (value, result) {
        serviceLocator<ConversationsCubit>().leaveConversation(conversationId: widget.conversationId);
        serviceLocator<ConversationsCubit>().resetSelectedConversation();
        },
      child: Builder(builder: (context) {
        return CustomScaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: ConversationAppBar(),
          ),
          body: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.asset(
                  Assets.chatRoomBackground,
                  scale: 8,
                  repeat: ImageRepeat.repeat,
                  opacity: context.isDarkMode
                      ? const AlwaysStoppedAnimation(0.1)
                      : const AlwaysStoppedAnimation(0.7),
                ),
              ),
              // Main content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: MessagesListView()),
                  BlocBuilder<ConversationsCubit, ConversationsState>(
                    builder: (context, state) {
                      if (context.read<ConversationsCubit>().selectedConversation?.conversationId == widget.conversationId && context.read<ConversationsCubit>().selectedConversation?.isTyping == true) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: context.isDarkMode
                                    ? AppColors.QUANTITY_COLOR
                                    : Colors.white,
                                backgroundImage: const NetworkImage(
                                    UIConst.profilePlaceHolder),
                              ),
                              const Sizer(width: 5),
                              ScaleTransition(
                                scale: _typingAnimation,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: context.isDarkMode
                                        ? AppColors.QUANTITY_COLOR
                                        : Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(12),
                                      topRight: const Radius.circular(12),
                                      bottomLeft: isArabic
                                          ? const Radius.circular(0)
                                          : const Radius.circular(12),
                                      bottomRight: isArabic
                                          ? const Radius.circular(12)
                                          : const Radius.circular(0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: context.isDarkMode
                                            ? AppColors.BACKGROUND_COLOR
                                            .withOpacity(0.05)
                                            : Colors.black12,
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.more_horiz,
                                      color: AppColors.PRIMARY_COLOR_DARK,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      if (context.read<ConversationsCubit>().selectedConversation?.conversationId == widget.conversationId && context.read<ConversationsCubit>().selectedConversation?.isRecording == true) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: context.isDarkMode
                                    ? AppColors.QUANTITY_COLOR
                                    : Colors.white,
                                backgroundImage: const NetworkImage(
                                    UIConst.profilePlaceHolder),
                              ),
                              const Sizer(width: 5),
                              ScaleTransition(
                                scale: _recordingAnimation,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: context.isDarkMode
                                        ? AppColors.QUANTITY_COLOR
                                        : Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: const Radius.circular(12),
                                      topRight: const Radius.circular(12),
                                      bottomLeft: isArabic
                                          ? const Radius.circular(0)
                                          : const Radius.circular(12),
                                      bottomRight: isArabic
                                          ? const Radius.circular(12)
                                          : const Radius.circular(0),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: context.isDarkMode
                                            ? AppColors.BACKGROUND_COLOR
                                            .withOpacity(0.05)
                                            : Colors.black12,
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.mic,
                                      color: AppColors.PRIMARY_COLOR_DARK,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
                  // BlocConsumer<ChatsCubit, ChatsState>(
                  //   builder: (context, state) {
                  //     if (isTyping) {
                  //       return Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 8, vertical: 4),
                  //         child: Row(
                  //           crossAxisAlignment: CrossAxisAlignment.end,
                  //           children: [
                  //             CircleAvatar(
                  //               radius: 15,
                  //               backgroundColor: context.isDarkMode
                  //                   ? AppColors.QUANTITY_COLOR
                  //                   : Colors.white,
                  //               backgroundImage: const NetworkImage(
                  //                   UIConst.profilePlaceHolder),
                  //             ),
                  //             const Sizer(width: 5),
                  //             ScaleTransition(
                  //               scale: _typingAnimation,
                  //               child: Container(
                  //                 padding: const EdgeInsets.all(12),
                  //                 decoration: BoxDecoration(
                  //                   color: context.isDarkMode
                  //                       ? AppColors.QUANTITY_COLOR
                  //                       : Colors.white,
                  //                   borderRadius: BorderRadius.only(
                  //                     topLeft: const Radius.circular(12),
                  //                     topRight: const Radius.circular(12),
                  //                     bottomLeft: isArabic
                  //                         ? const Radius.circular(0)
                  //                         : const Radius.circular(12),
                  //                     bottomRight: isArabic
                  //                         ? const Radius.circular(12)
                  //                         : const Radius.circular(0),
                  //                   ),
                  //                   boxShadow: [
                  //                     BoxShadow(
                  //                       color: context.isDarkMode
                  //                           ? AppColors.BACKGROUND_COLOR
                  //                           .withOpacity(0.05)
                  //                           : Colors.black12,
                  //                       blurRadius: 8,
                  //                       offset: const Offset(0, 4),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 child: const Center(
                  //                   child: Icon(
                  //                     Icons.more_horiz,
                  //                     color: AppColors.PRIMARY_COLOR_DARK,
                  //                   ),
                  //                 ),
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       );
                  //     }
                  //     if (isRecording) {
                  //       return Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 8, vertical: 4),
                  //         child: Row(
                  //           crossAxisAlignment: CrossAxisAlignment.end,
                  //           children: [
                  //             CircleAvatar(
                  //               radius: 15,
                  //               backgroundColor: context.isDarkMode
                  //                   ? AppColors.QUANTITY_COLOR
                  //                   : Colors.white,
                  //               backgroundImage: const NetworkImage(
                  //                   UIConst.profilePlaceHolder),
                  //             ),
                  //             const Sizer(width: 5),
                  //             ScaleTransition(
                  //               scale: _recordingAnimation,
                  //               child: Container(
                  //                 padding: const EdgeInsets.all(12),
                  //                 decoration: BoxDecoration(
                  //                   color: context.isDarkMode
                  //                       ? AppColors.QUANTITY_COLOR
                  //                       : Colors.white,
                  //                   borderRadius: BorderRadius.only(
                  //                     topLeft: const Radius.circular(12),
                  //                     topRight: const Radius.circular(12),
                  //                     bottomLeft: isArabic
                  //                         ? const Radius.circular(0)
                  //                         : const Radius.circular(12),
                  //                     bottomRight: isArabic
                  //                         ? const Radius.circular(12)
                  //                         : const Radius.circular(0),
                  //                   ),
                  //                   boxShadow: [
                  //                     BoxShadow(
                  //                       color: context.isDarkMode
                  //                           ? AppColors.BACKGROUND_COLOR
                  //                           .withOpacity(0.05)
                  //                           : Colors.black12,
                  //                       blurRadius: 8,
                  //                       offset: const Offset(0, 4),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 child: const Center(
                  //                   child: Icon(
                  //                     Icons.mic,
                  //                     color: AppColors.PRIMARY_COLOR_DARK,
                  //                   ),
                  //                 ),
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //       );
                  //     }
                  //     return const SizedBox.shrink();
                  //   },
                  //   listener: (context, state) async {
                  //     if (state.status == ChatsStates.typing) {
                  //       setState(() {
                  //         isTyping = state.listenToTypingParams!.isTyping;
                  //         log("typing chat card in chat room = ${state.listenToTypingParams!.isTyping}");
                  //       });
                  //     }
                  //     if (state.status == ChatsStates.recording) {
                  //       setState(() {
                  //         isRecording =
                  //             state.listenToRecordingParams!.isRecording;
                  //         log("recording chat card in chat room = ${state.listenToRecordingParams!.isRecording}");
                  //       });
                  //     }
                  //     if (state.status == ChatsStates.newMessage) {
                  //       if (state.newMessage != null &&
                  //           (!state.newMessage!.byMe)) {
                  //         log("sound before receive message");
                  //         final player =
                  //         AudioPlayer(); // Initialize the player
                  //         await player.play(AssetSource(
                  //             'ChatSounds/Incoming Message.mp3'));
                  //         log("sound after receive message");
                  //       }
                  //     }
                  //   },
                  // ),


                  // (chatRoomCubit.chat.categoryId ==
                  //     ChatCategoriesIds.greet &&
                  //     chatRoomCubit.getMessagesCount() > 0)
                  //     ? Container(
                  //   // height: 200,
                  //   color: context.isDarkMode
                  //       ? AppColors.PRIMARY_COLOR
                  //       : Colors.white,
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                  //       const SizedBox(
                  //         height: 16,
                  //       ),
                  //       Text(
                  //         context.isArabic
                  //             ? 'تم ارسال الدعوة'
                  //             : "Invite sent",
                  //         style: const TextStyle(
                  //           fontSize: 18,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         height: 16,
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 16),
                  //         child: Text(
                  //           context.isArabic
                  //               ? 'بإمكانك إرسال المزيد من الرسائل بعد قبول دعوتك.'
                  //               : "You can send more messages after your invite is accepted.",
                  //           style: const TextStyle(
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w500,
                  //             color: Colors.grey,
                  //           ),
                  //           textAlign: TextAlign.center,
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         height: 30,
                  //       ),
                  //     ],
                  //   ),
                  // )
                  //     : chatRoomCubit.chat.isAdmin == "admin"
                  //     ? Container(
                  //   color: AppColors.PRIMARY_COLOR,
                  //   child: Center(
                  //     child: Padding(
                  //       padding: const EdgeInsets.symmetric(
                  //           vertical: 12),
                  //       child: Text(
                  //         context.isArabic
                  //             ? 'فقط 49Hub يمكنه ارسال الرسائل.'
                  //             : 'Only 49Hub can send messages.',
                  //         style: const TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w600,
                  //           color: Colors.white,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // )
                  //     :


                  SendMessageWidget(
                    conversationId: widget.conversationId,
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
