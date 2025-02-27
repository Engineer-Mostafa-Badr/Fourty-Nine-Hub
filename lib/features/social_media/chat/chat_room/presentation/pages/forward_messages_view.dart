// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/enums/chat_categories.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/file_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_sender_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/widget/custom_scaffold.dart';

class ForwardMessagesViewParams {
  final ChatsCubit chatsCubit;
  final ChatRoomCubit chatRoomCubit;

  ForwardMessagesViewParams(
      {required this.chatsCubit, required this.chatRoomCubit});
}

class ForwardMessagesView extends StatefulWidget {
  final ForwardMessagesViewParams forwardMessagesViewParams;
  const ForwardMessagesView(
      {super.key, required this.forwardMessagesViewParams});

  @override
  State<ForwardMessagesView> createState() => _ForwardMessagesViewState();
}

class _ForwardMessagesViewState extends State<ForwardMessagesView>
    with TickerProviderStateMixin {
  bool isLoading = false;
  bool isStorySelected = false;
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.forwardMessagesViewParams.chatsCubit),
        BlocProvider.value(
          value: widget.forwardMessagesViewParams.chatRoomCubit,
        ),
      ],
      child: Builder(builder: (context) {
        return CustomScaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: AppColors.PRIMARY_COLOR,
              title: Text(
                LocaleKeys.forwardMessage.tr(),
                style: Styles.headerText(
                  fontWeight: FontWeight.bold,
                  color: AppColors.BACKGROUND_COLOR,
                ),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 26,
                  color: AppColors.BACKGROUND_COLOR,
                ),
              ),
            ),
            body: FutureBuilder(
                future: widget.forwardMessagesViewParams.chatsCubit
                    .getChatsByCategory(ChatCategories.social),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: _buildCategoryChats(),
                        ),
                        const StoryCard(),
                        const Column(),
                        (context
                                    .read<ChatRoomCubit>()
                                    .selectedMessages
                                    .isNotEmpty &&
                                context
                                        .read<ChatRoomCubit>()
                                        .selectedMessages
                                        .length ==
                                    1 &&
                                context
                                    .read<ChatRoomCubit>()
                                    .selectedMessages[0]
                                    .media
                                    .isNotEmpty &&
                                context
                                        .read<ChatRoomCubit>()
                                        .selectedMessages[0]
                                        .media[0]
                                        .type ==
                                    FileTypeEnum.image)
                            ? Positioned(
                                bottom: 0,
                                right: 0,
                                left: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: AppColors.PRIMARY_COLOR,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    child: Row(
                                      children: [
                                        // Thumbnail for the image or video
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              context
                                                  .read<ChatRoomCubit>()
                                                  .selectedMessages[0]
                                                  .media[0]
                                                  .url, // Replace with actual image URL
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            )),
                                        const SizedBox(width: 8),
                                        // TextField for writing a message
                                        Expanded(
                                          child: TextField(
                                            controller: _messageController,
                                            style: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                            ),
                                            decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                              ),
                                              hintText: context.isArabic
                                                  ? 'اكتب رسالة'
                                                  : 'Write a message...',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                borderSide: BorderSide.none,
                                              ),
                                              filled: true,
                                              fillColor: Colors.transparent,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox()
                      ],
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                }),
            floatingActionButton: BlocBuilder<ChatRoomCubit, ChatRoomState>(
              builder: (context, state) {
                return context
                        .read<ChatRoomCubit>()
                        .selectedChatsToForword
                        .isEmpty
                    ? Container()
                    : Stack(
                        children: [
                          Positioned(
                            bottom: (context
                                        .read<ChatRoomCubit>()
                                        .selectedMessages
                                        .isNotEmpty &&
                                    context
                                            .read<ChatRoomCubit>()
                                            .selectedMessages
                                            .length ==
                                        1 &&
                                    context
                                        .read<ChatRoomCubit>()
                                        .selectedMessages[0]
                                        .media
                                        .isNotEmpty &&
                                    context
                                            .read<ChatRoomCubit>()
                                            .selectedMessages[0]
                                            .media[0]
                                            .type ==
                                        FileTypeEnum.image)
                                ? 100
                                : 30,
                            right: 10,
                            child: FloatingActionButton(
                              onPressed: () async {
                                if (_messageController.text.isNotEmpty) {
                                  MessageEntity message = MessageEntity(
                                    id: '',
                                    text: _messageController.text,
                                    media: [],
                                    sender: MessageSenderEntity(
                                        id: '',
                                        name: '',
                                        avatar:
                                            ''), // Provide actual sender details
                                    reply: null, // No reply message initially
                                    createdAt: DateTime.now(),
                                    updateAt: DateTime.now(),
                                    byMe:
                                        true, // Assuming the user is the sender
                                    isUpdated: false,
                                    seen: false,
                                    delivered: false,
                                    hasReply: false,
                                    time: DateTime.now()
                                        .toIso8601String(), // Convert to string format
                                    isDeleted: false,
                                    sharedContacts: [],
                                    isOneTimeViewMessage: false,
                                    isOneTimeSeenMessage: false,
                                    isListened: false,
                                  );

                                  context
                                      .read<ChatRoomCubit>()
                                      .addMessageToSelectedMessages(
                                          message: message);
                                }
                                await context
                                    .read<ChatRoomCubit>()
                                    .forwardMessages();
                                // await Future.delayed(const Duration(seconds: 6), () {});
                                setState(() {
                                  isLoading = false;
                                });
                                // context.push(Routes.CHAT);
                                context.pop();
                                context.pop();
                              },
                              backgroundColor: AppColors.PRIMARY_COLOR,
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      color: AppColors.BACKGROUND_COLOR)
                                  : const Icon(Icons.send,
                                      color: AppColors.BACKGROUND_COLOR),
                            ),
                          ),
                        ],
                      );
              },
            ));
      }),
    );
  }

  Widget _buildCategoryChats() {
    return BlocBuilder<ChatRoomCubit, ChatRoomState>(
      builder: (context, state) {
        return BlocBuilder<ChatsCubit, ChatsState>(builder: (context, state) {
          return state.chats == null || state.isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : state.chats!.isEmpty
                  ? Center(
                      child: Label(
                          text: LocaleKeys.noChatsUntilNow.tr(),
                          style: Styles.mediumText(
                              fontWeight: FontWeight.bold, fontSize: 26)),
                    )
                  : Scrollbar(
                      // isAlwaysShown: true,  // Ensures the scrollbar is always visible
                      interactive: true,
                      thumbVisibility: true,
                      thickness: 3,

                      child: ListView.separated(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        // Enable scrolling
                        itemBuilder: (context, index) => InkWell(
                          splashColor: context.isDarkMode
                              ? Colors.white
                              : AppColors.PRIMARY_COLOR.withOpacity(0.05),
                          // Ripple effect color
                          highlightColor: context.isDarkMode
                              ? AppColors.QUANTITY_COLOR
                              : AppColors.LIGHT_GRAY_COLOR.withOpacity(0.2),
                          // Highlight color on tap
                          onTap: () {
                            // setState(() {
                            if (!state.chats![index].isSelected) {
                              context
                                  .read<ChatRoomCubit>()
                                  .addChatToSelectedChats(
                                      chat: state.chats![index]);
                            } else {
                              context
                                  .read<ChatRoomCubit>()
                                  .removeChatToSelectedChats(
                                      chat: state.chats![index]);
                            }
                            // });
                          },
                          onLongPress: () {
                            // setState(() {
                            if (!state.chats![index].isSelected) {
                              context
                                  .read<ChatRoomCubit>()
                                  .addChatToSelectedChats(
                                      chat: state.chats![index]);
                            } else {
                              context
                                  .read<ChatRoomCubit>()
                                  .removeChatToSelectedChats(
                                      chat: state.chats![index]);
                            }
                            // });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            // curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              color: state.chats![index].isSelected
                                  ? AppColors.PRIMARY_COLOR.withOpacity(0.001)
                                  : context.isDarkMode
                                      ? AppColors.QUANTITY_COLOR
                                      : AppColors.BACKGROUND_COLOR,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: state.chats![index].isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.PRIMARY_COLOR
                                            .withOpacity(0.2),
                                        blurRadius: 6,
                                        spreadRadius: 2,
                                      )
                                    ]
                                  : [],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 12),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: kToolbarHeight * .7,
                                        width: kToolbarHeight * .7,
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Image.network(
                                                UIConst.profilePlaceHolder,
                                              ),
                                            ),
                                            state.chats![index].isSelected
                                                ? const Positioned(
                                                    bottom: 0,
                                                    right: 0,
                                                    child: CircleAvatar(
                                                      radius: 8,
                                                      backgroundColor: AppColors
                                                          .PRIMARY_COLOR,
                                                      child: Icon(
                                                        Icons.check,
                                                        color: AppColors
                                                            .BACKGROUND_COLOR,
                                                        size: 10,
                                                      ),
                                                    ),
                                                  )
                                                : Positioned(
                                                    bottom: 0,
                                                    right: 0,
                                                    child: CircleAvatar(
                                                      radius: 5,
                                                      backgroundColor: state
                                                              .chats![index]
                                                              .online
                                                          ? Colors.green
                                                          : Colors.transparent,
                                                    ),
                                                  )
                                          ],
                                        ),
                                      ),
                                      const Sizer(),
                                      Flexible(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Label(
                                                text: state.chats![index].name,
                                                style: Styles.mediumText(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                maxLines: 1,
                                              ),
                                            ),
                                            // Row(
                                            //   children: [
                                            //     const SizedBox(width: 10),
                                            //     widget.chat!.typing ||
                                            //             widget.chat!.recording
                                            //         ? const SizedBox()
                                            //         : widget.chat!.lastMessage
                                            //                     ?.byMe ??
                                            //                 false
                                            //             ? widget
                                            //                         .chat!
                                            //                         .lastMessage
                                            //                         ?.seen ??
                                            //                     false
                                            //                 ? const Icon(
                                            //                     FontAwesomeIcons
                                            //                         .checkDouble,
                                            //                     color: AppColors
                                            //                         .GREY_DARK_COLOR,
                                            //                     size: 10,
                                            //                   )
                                            //                 : const Icon(
                                            //                     FontAwesomeIcons
                                            //                         .check,
                                            //                     color: AppColors
                                            //                         .GREY_DARK_COLOR,
                                            //                     size: 10,
                                            //                   )
                                            //             : const SizedBox(),
                                            //     if (widget.chat!.lastMessage
                                            //             ?.seen ??
                                            //         false)
                                            //       const SizedBox(width: 10),
                                            //     Expanded(
                                            //       child: Label(
                                            //           text: widget
                                            //                   .chat!.typing
                                            //               ? "Typing..."
                                            //               : widget.chat!
                                            //                       .recording
                                            //                   ? "Recording..."
                                            //                   : widget.chat?.lastMessage
                                            //                               ?.text ==
                                            //                           null
                                            //                       ? "No messages until now"
                                            //                       : '${widget.chat?.lastMessage?.text}',
                                            //           style:
                                            //               Styles.mediumText(
                                            //             fontSize: 24,
                                            //             color: widget
                                            //                     .chat!.typing
                                            //                 ? AppColors
                                            //                     .SPLASH_BLACK_COLOR
                                            //                 : AppColors
                                            //                     .DARK_GRAY_COLOR,
                                            //           )),
                                            //     ),
                                            //     const SizedBox(height: 10),
                                            //     widget.chat!.muted
                                            //         ? const Icon(
                                            //             Icons.volume_off,
                                            //             color: Colors.grey,
                                            //             size: 17,
                                            //           )
                                            //         : const SizedBox(),
                                            //     widget.chat!.isPinned
                                            //         ? const Icon(
                                            //             Icons.push_pin,
                                            //             color: Colors.grey,
                                            //             size: 17,
                                            //           )
                                            //         : const SizedBox(),
                                            //   ],
                                            // ),
                                          ],
                                        ),
                                      ),
                                      // widget.chat?.unreadCount == 0
                                      //     ? const SizedBox()
                                      //     : CircleAvatar(
                                      //         maxRadius: 10,
                                      //         backgroundColor:
                                      //             AppColors.PRIMARY_COLOR,
                                      //         child: Label(
                                      //             text:
                                      //                 '${widget.chat?.unreadCount}',
                                      //             style: Styles.mediumText(
                                      //               color: Colors.white,
                                      //               fontWeight:
                                      //                   FontWeight.bold,
                                      //               fontSize: 16,
                                      //             )),
                                      //       ),
                                      // const SizedBox(width: 8),
                                      // Column(
                                      //   children: [
                                      //     Label(
                                      //         text:
                                      //             '${widget.chat?.lastMessage?.time}',
                                      //         style: Styles.mediumText(
                                      //             color: Colors.grey)),
                                      //     widget.chat?.lastSeenCount == null
                                      //         ? const SizedBox()
                                      //         : GestureDetector(
                                      //             onTap: () {},
                                      //             child: Row(
                                      //               children: [
                                      //                 Label(
                                      //                     text:
                                      //                         '${widget.chat?.lastSeenCount}',
                                      //                     style: Styles
                                      //                         .mediumText(
                                      //                             color: Colors
                                      //                                 .grey)),
                                      //                 const SizedBox(
                                      //                     width: 10),
                                      //                 const Padding(
                                      //                   padding: EdgeInsets
                                      //                       .symmetric(
                                      //                           horizontal:
                                      //                               2.0),
                                      //                   child: Icon(
                                      //                       FontAwesomeIcons
                                      //                           .eye,
                                      //                       color:
                                      //                           Colors.grey,
                                      //                       size: 14),
                                      //                 ),
                                      //               ],
                                      //             ),
                                      //           )
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                                // Container(
                                //   height: 0.4,
                                //   width: MediaQuery.of(context).size.width,
                                //   color: AppColors.GREY_DARK_COLOR,
                                // ),
                              ],
                            ),
                          ),
                        ),
                        separatorBuilder: (context, index) => const SizedBox(),
                        itemCount: state.chats?.length ?? 0,
                      ),
                    );
        });
      },
    );
  }
}

class StoryCard extends StatefulWidget {
  const StoryCard({super.key});

  @override
  State<StoryCard> createState() => _StoryCardState();
}

class _StoryCardState extends State<StoryCard> {
  bool isStorySelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: context.isDarkMode
          ? Colors.white
          : AppColors.PRIMARY_COLOR.withOpacity(0.05),
      // Ripple effect color
      highlightColor: context.isDarkMode
          ? AppColors.QUANTITY_COLOR
          : AppColors.LIGHT_GRAY_COLOR.withOpacity(0.2),
      // Highlight color on tap
      onTap: () {
        // setState(() {
        setState(() {
          if (!isStorySelected) {
            isStorySelected = true;
          } else {
            isStorySelected = false;
          }
        });
        // });
      },
      onLongPress: () {
        // setState(() {
        setState(() {
          if (!isStorySelected) {
            isStorySelected = true;
          } else {
            isStorySelected = false;
          }
        });
        // });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isStorySelected
              ? AppColors.PRIMARY_COLOR.withOpacity(0.001)
              : context.isDarkMode
                  ? AppColors.QUANTITY_COLOR
                  : AppColors.BACKGROUND_COLOR,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isStorySelected
              ? [
                  BoxShadow(
                    color: AppColors.PRIMARY_COLOR.withOpacity(0.2),
                    blurRadius: 6,
                    spreadRadius: 2,
                  )
                ]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 12, left: 10, right: 10),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: AppColors.PRIMARY_COLOR_DARK,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    width: 44,
                    height: 44,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.PRIMARY_COLOR,
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: Icon(
                        isStorySelected ? Icons.check : Icons.add,
                        size: 18,
                        color: AppColors.BACKGROUND_COLOR,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Text(context.isArabic ? 'قصتي' : 'My Story',
                  style: Styles.mediumText(
                    fontWeight: FontWeight.bold,
                    color: AppColors.PRIMARY_COLOR,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
