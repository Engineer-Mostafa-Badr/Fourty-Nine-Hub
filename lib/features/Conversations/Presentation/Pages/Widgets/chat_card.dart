import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../core/utils/format_numbers.dart';
import '../../../../../helpers/date_time_helper.dart';
import '../../../../../helpers/manage_vibration.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../../../res/style/styles.dart';
import '../../../../../routes/routes.dart';
import '../../../../../service_locator/service_locator.dart';
import '../../../../social_media/social_posts/presentation/widgets/facebook_widgets/build_gradient_border.dart';
import '../../../../social_media/tinder/data/shared/shared.dart';
import '../../../Domain/Entities/conversation_entity.dart';
import '../../Controllers/cubits/conversation_states.dart';
import '../../Controllers/cubits/conversations_cubit.dart';
import 'conversation_logs_buttom_sheet.dart';

class ChatCard extends StatefulWidget {
  final ConversationEntity? chat;

  const ChatCard({
    super.key,
    required this.chat,
  });

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationsCubit, ConversationsState>(
      builder: (context, state) {
        return InkWell(
          splashColor: context.isDarkMode
              ? Colors.white
              : AppColors.PRIMARY_COLOR.withValues(alpha: 0.05),
          // Ripple effect color
          highlightColor: context.isDarkMode
              ? AppColors.QUANTITY_COLOR
              : AppColors.LIGHT_GRAY_COLOR.withValues(alpha: 0.2),
          onTap: () {
            ManageVibration.vibrate();
            if (serviceLocator<ConversationsCubit>().selectedSocialConversation.isEmpty) {
              // context.read<ChatsCubit>().selectChat = widget.chat!;
              serviceLocator<ConversationsCubit>().setSelectedConversation(widget.chat);
              context.push(Routes.conversationScreen, extra: widget.chat?.conversationId ?? '');
              serviceLocator<ConversationsCubit>().joinConversation(conversationId: widget.chat?.conversationId ?? '');
            } else {
              setState(() {
                if (!widget.chat!.isSelected) {
                  serviceLocator<ConversationsCubit>()
                      .addConversationToSelectedSocialConversations(conversation: widget.chat!);
                } else {
                  serviceLocator<ConversationsCubit>()
                      .removeConversationFromSelectedSocialConversations(conversation: widget.chat!);
                }
              });
            }
          },
          onLongPress: () {
            ManageVibration.vibrate();
            setState(() {
              if (!widget.chat!.isSelected) {
                serviceLocator<ConversationsCubit>()
                    .addConversationToSelectedSocialConversations(conversation: widget.chat!);
              } else {
                serviceLocator<ConversationsCubit>()
                    .removeConversationFromSelectedSocialConversations(conversation: widget.chat!);
              }
            });
          },
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color:
                (widget.chat?.isSelected ?? false)
                        ? const Color(0xffFFD5CC)
                        :
                    context.isDarkMode
                        ? AppColors.QUANTITY_COLOR
                        : AppColors.BACKGROUND_COLOR,
                // borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _userImage(),
                        const Sizer(width: 24),
                        _nameAndLastMessage(),
                        // _lastMessageTime(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  _userImage() {
    // if (widget.isSecret || widget.isService) {
    //   return GradientProfileBorder(imageUrl: '',segments: 4,
    //       firstChar: 'A'
    //   );
    //   // return CircleAvatar(
    //   //   backgroundColor: AppColors.PRIMARY_COLOR_DARK,
    //   //
    //   //   child: ClipRRect(
    //   //     borderRadius: BorderRadius.circular(50),
    //   //     child: CircleAvatar(
    //   //       backgroundColor: Colors.red,
    //   //       child: Image.asset(
    //   //         // widget.chat!.gender == 'female'
    //   //         //     ?
    //   //         // Assets.femaleImagePlacehlder
    //   //         //     :
    //   //         Assets.maleImagePlaceholder,
    //   //         // UIConst.profilePlaceHolder,
    //   //         width: 50,
    //   //         height: 50,
    //   //         fit: BoxFit.cover,
    //   //       ),
    //   //     ),
    //   //   ),
    //   // );
    // } else {
    return Center(
      child: GestureDetector(
        onTap: () {
          ManageVibration.vibrate();
          // serviceLocator<ConversationsCubit>().leaveConversation(conversationId: widget.chat?.conversationId ?? '');
          // if (widget.chat!.hasStory) {}
          // if (widget.chat!.isAdmin != "admin") {
          //   if (context.isUserLoggedIn) {
          //     context.read<UserCubit>().updateProfileView(
          //       isProfile: false,
          //       userId: widget.chat!.userId,
          //     );
          //     _onPressedImageDialog();
          //   }
          // }
        },
        child: Stack(
          children: [
            // if (widget.chat!.isAdmin != 'admin')
            GradientProfileBorder(
                imageUrl: widget.chat?.profile?.profilePictureUrl ?? "",
                imageWidth: 46,
                fullWidth: 54,
                isViewed: (serviceLocator<ConversationsCubit>()
                            .socialConversations
                            .indexWhere((e) =>
                                e.conversationId ==
                                widget.chat?.conversationId)) %
                        2 !=
                    0,
                segments: serviceLocator<ConversationsCubit>()
                        .socialConversations
                        .indexWhere((e) =>
                            e.conversationId == widget.chat?.conversationId) +
                    1,
                firstChar: widget.chat?.profile?.firstName?[0].toUpperCase() ?? 'A'),
            // CircleAvatar(
            //   backgroundColor: AppColors.PRIMARY_COLOR_DARK,
            //   child: SizedBox(
            //     height: 50,
            //     width: 50,
            //     child: ProfileWithStoriesBorder(
            //       profilePictureUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQKu1w7TulWMUKGszjJlb7PDtn0LVSJgGnrog&s",
            //       storiesCount: 4,
            //     ),
            //   ),
            // )
            // else
            //   ClipRRect(
            //     borderRadius: BorderRadius.circular(50),
            //     child: CircleAvatar(
            //       radius: 25,
            //       child: Padding(
            //         padding: const EdgeInsets.all(4),
            //         child: Image.asset(
            //           Assets.logoWithoutText,
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //       // Image.network(
            //       //         widget.chat!.avatar,
            //       //         fit: BoxFit.cover,
            //       //         errorBuilder: (context, error, stackTrace) {
            //       //           return Image.network(
            //       //             UIConst.profilePlaceHolder,
            //       //             fit: BoxFit.cover,
            //       //           );
            //       //         },
            //       //       ),
            //     ),
            //   ),

            if ((widget.chat?.isSelected ?? false))
              const Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Color(0xffFFD5CC),
                  radius: 10,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: AppColors.PRIMARY_COLOR_DARK,
                    child: Icon(
                      Icons.check,
                      color: AppColors.BACKGROUND_COLOR,
                      size: 14,
                      weight: 20,
                    ),
                  ),
                ),
              ),
            // if (widget.chat!.isSelected)
            //    Positioned(
            //     bottom: 0,
            //     right: 0,
            //     child: CircleAvatar(
            //       radius: 10,
            //       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            //       child: const Icon(
            //         Icons.timelapse,
            //         color: Colors.black45,
            //         size: 14,
            //         weight: 20,
            //       ),
            //     ),
            //   ),
            if (widget.chat?.isOnline == true && (!(widget.chat?.isSelected ?? true) == true))
              const Positioned(
                bottom: 2,
                right: 2,
                child: CircleAvatar(
                  radius: 7,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 5,
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
    // }
  }

  _nameAndLastMessage() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 140),
                            child: Label(
                              text: ("${widget.chat?.profile?.firstName?.trim() ?? ""} ${(widget.chat?.profile?.lastName?.trim()) ?? ""}") ?? "Ahmed Nasr",
                              // text: "Ahmed Nasr Mohamed Fahmey",
                              overflow: TextOverflow.ellipsis,
                              // widget.isSecret
                              //     ? 'UNKNOWN'
                              //     : widget.isService
                              //     ? '${widget.chat?.name.split(' ').first}'
                              //     : widget.chat!.isAdmin == "admin"
                              //     ? "49Hub"
                              //     : '${widget.chat?.name}',
                              style: Styles.mediumText(
                                fontWeight: FontWeight.bold,
                                color: context.isDarkMode ? Colors.white : Colors.black,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(width: 2),
                          if (widget.chat?.profile?.isAccountVerified ?? false)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 9.0),
                            child: Icon(
                              Icons.verified,
                              color: Colors.blue,
                              size: 12,
                            ),
                          ),
                          // if (widget.chat!.lables.isNotEmpty &&
                          //     widget.chat!.lables.length == 1)
                          //   Icon(
                          //     Icons.label,
                          //     color: Colors.blue,
                          //     // LabelColorsMap.getColor(widget.chat!.lables.last.color),
                          //     size: 20,
                          //   ),
                          // if (widget.chat!.lables.isNotEmpty &&
                          //     widget.chat!.lables.length != 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 7.0),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  left: 4,
                                  bottom: 4,
                                  child: Icon(
                                    Icons.label,
                                    color: Colors.red,
                                    // LabelColorsMap.getColor(widget.chat!
                                    //     .lables[widget.chat!.lables.length - 2].color),
                                    size: 15,
                                  ),
                                ),
                                Icon(
                                  Icons.label,
                                  color: Colors.yellow,
                                  // LabelColorsMap.getColor(
                                  //     widget.chat!.lables.last.color),
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 4),
                          if (widget.chat?.profile?.isBirthday ?? false)
                          InkWell(
                            onTap: () async {
                              ManageVibration.vibrate();
                              await showGiftBottomSheet(
                                context,
                                receiverId: widget.chat?.profile?.id,
                              );
                            },
                            child: Icon(
                              FontAwesomeIcons.cakeCandles,
                              color: context.isDarkMode ? Colors.white54 : Colors.black45,
                              size: 14,
                            ),
                          ),
                          // Spacer()
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              // const Spacer(),
              if (widget.chat?.isMuted ?? false)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Icon(
                  Icons.volume_off_outlined,
                  color: context.isDarkMode ? Colors.white54 : Colors.black45,
                  size: 15,
                ),
              ),
              if (widget.chat?.isPinned ?? false)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Icon(
                  Icons.push_pin_outlined,
                  color: context.isDarkMode ? Colors.white54 : Colors.black45,
                  size: 15,
                ),
              ),
              // Spacer(),
              SizedBox(width: 4),
              Label(
                text: _getFormattedLastMessageTime(),
                style: Styles.mediumText(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: (widget.chat?.unreadMessagesCount??0) > 0 ?AppColors.PRIMARY_COLOR_DARK : context.isDarkMode ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              // if (!widget.chat!.typing || !widget.chat!.recording)
              //   if (context
              //       .read<ChatRoomCubit>()
              //       .messageTextController
              //       .text
              //       .isNotEmpty)
              //     Label(text: 'Draft Message', style: Styles.smallText()),
              // if (!widget.chat!.typing || !widget.chat!.recording)
              //   if (widget.chat!.lastMessage?.byMe ?? false)
              //     if (widget.chat!.lastMessage?.delivered ?? false)
              if((widget.chat?.lastMessage?.sender?.isMe ?? false) && (widget.chat?.isTyping == false && widget.chat?.isRecording == false && widget.chat?.inConversation == false))
                Image.asset(
                  Assets.doubleCheck,
                  width: 18,
                )
              // else if (widget.chat!.lastMessage?.seen ?? false)
              //   Image.asset(
              //     Assets.doubleCheckSeen,
              //     width: 18,
              //   )
              // else
              //   Image.asset(
              //     Assets.check,
              //     width: 18,
              //   ),
              // if (!widget.chat!.typing || !widget.chat!.recording)
              //   Expanded(
              //     child: Row(
              //       children: [
              //         if (widget.chat!.lastMessage != null &&
              //             (widget.chat!.lastMessage?.media.isNotEmpty ?? false))
              //           Row(
              //             children: [
              //               if (widget.chat!.lastMessage?.media.first.type ==
              //                   FileTypeEnum.image)
              //                 Icon(
              //                   Icons.image,
              //                   color: context.isDarkMode
              //                       ? Colors.white54
              //                       : Colors.black45,
              //                   size: 20,
              //                 )
              //               else if (widget
              //                   .chat!.lastMessage?.media.first.type ==
              //                   FileTypeEnum.video)
              //                 Icon(
              //                   Icons.video_camera_back,
              //                   color: context.isDarkMode
              //                       ? Colors.white54
              //                       : Colors.black45,
              //                   size: 20,
              //                 )
              //               else if (widget
              //                     .chat!.lastMessage?.media.first.type ==
              //                     FileTypeEnum.audio)
              //                   Icon(
              //                     Icons.mic,
              //                     color: context.isDarkMode
              //                         ? Colors.white54
              //                         : Colors.black45,
              //                     size: 20,
              //                   )
              //                 else if (widget
              //                       .chat!.lastMessage?.media.first.type ==
              //                       FileTypeEnum.document)
              //                     Icon(
              //                       Icons.description,
              //                       color: context.isDarkMode
              //                           ? Colors.white54
              //                           : Colors.black45,
              //                       size: 20,
              //                     ),
              //             ],
              //           ),
              ,
              if(widget.chat?.isRecording == true)
              Expanded(
                child: Label(
                  text:
                  context.isArabic? "...يسجل" : "recording...",
                  style: Styles.mediumText(
                    fontWeight: FontWeight.bold,
                    color:(widget.chat?.isTyping == true || widget.chat?.isRecording == true || widget.chat?.inConversation == true)? AppColors.PRIMARY_COLOR_DARK : context.isDarkMode
                        ? Colors.white54
                        : AppColors.DARK_GRAY_COLOR,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if(widget.chat?.isTyping == true)
                Expanded(
                  child: Label(
                    text:
                     context.isArabic? "...يكتب" : "typing..." ,
                    style: Styles.mediumText(
                      fontWeight: FontWeight.bold,
                      color:(widget.chat?.isTyping == true || widget.chat?.isRecording == true || widget.chat?.inConversation == true)? AppColors.PRIMARY_COLOR_DARK : context.isDarkMode
                          ? Colors.white54
                          : AppColors.DARK_GRAY_COLOR,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              if(widget.chat?.inConversation == true && (widget.chat?.isTyping == false && widget.chat?.isRecording == false))
                Expanded(
                  child: Label(
                    text: context.isArabic? "...يقرأ" : "reading...",
                    style: Styles.mediumText(
                      fontWeight: FontWeight.bold,
                      color:(widget.chat?.isTyping == true || widget.chat?.isRecording == true || widget.chat?.inConversation == true)? AppColors.PRIMARY_COLOR_DARK : context.isDarkMode
                          ? Colors.white54
                          : AppColors.DARK_GRAY_COLOR,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              if(widget.chat?.lastMessage?.content == null && (widget.chat?.isTyping == false && widget.chat?.isRecording == false && widget.chat?.inConversation == false))
                Expanded(
                  child: Label(
                    text: context.isArabic
                        ? "لا توجد رسائل حتي الان"
                        : "No messages until now",
                    style: Styles.mediumText(
                      fontWeight: FontWeight.bold,
                      color:(widget.chat?.isTyping == true || widget.chat?.isRecording == true || widget.chat?.inConversation == true)? AppColors.PRIMARY_COLOR_DARK : context.isDarkMode
                          ? Colors.white54
                          : AppColors.DARK_GRAY_COLOR,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              if(widget.chat?.lastMessage?.content != null && (widget.chat?.isTyping == false && widget.chat?.isRecording == false && widget.chat?.inConversation == false))
                Expanded(
                  child: Label(
                    text: '${widget.chat?.lastMessage?.content}',
                    style: Styles.mediumText(
                      fontWeight: FontWeight.bold,
                      color:(widget.chat?.isTyping == true || widget.chat?.isRecording == true || widget.chat?.inConversation == true)? AppColors.PRIMARY_COLOR_DARK : context.isDarkMode
                          ? Colors.white54
                          : AppColors.DARK_GRAY_COLOR,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              GestureDetector(
                onTap: () {
                  ManageVibration.vibrate();
                },
                child: Row(
                  children: [
                    _unreadMessagesCount(),
                    Label(
                      text: context.isArabic? '١٠ ' : '10 ',
                      style: Styles.mediumText(
                        color: context.isDarkMode ? Colors.white54 : Colors.black45,
                        fontSize: 24,
                      ),
                    ),
                    // const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: InkWell(
                        onTap: () async {
                          ManageVibration.vibrate();
                          showConversationLogsBottomSheet(context, widget.chat!);
                          // Call the getLastSeen function
                          // print('widget.chat!.isAdmin ${widget.chat!.isAdmin}');
                          // if (widget.chat!.isAdmin != "admin") {
                          //   await context
                          //       .read<ChatsCubit>()
                          //       .getChatLastSeen(chatId: widget.chat!.id);
                          // }
                          // // Open a scrollable bottom sheet
                          // _bottomSheet(context,
                          //     chatsCubit: widget.chatsCubit,
                          //     widgetChat: widget.chat);
                        },
                        child: Icon(
                          FontAwesomeIcons.eye,
                          color: context.isDarkMode ? Colors.white54 : Colors.black45,
                          size: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // _unreadMessagesCount(),
            ],
          ),
          // ),
          // if (widget.chat!.typing)
          //   Expanded(
          //     child: Label(
          //         text: context.isArabic ? "يكتب..." : "Typing...",
          //         style: Styles.mediumText(
          //           fontSize: 28,
          //           color: AppColors.SECONDARY_COLOR,
          //         )),
          //   ),
          // if (widget.chat!.recording)
          //   Expanded(
          //     child: Label(
          //         text: context.isArabic
          //             ? "يسجل رساله صوتية..."
          //             : "Recording...",
          //         style: Styles.mediumText(
          //           fontSize: 28,
          //           color: AppColors.SECONDARY_COLOR,
          //         )),
          //   ),
        ],
      ),
    );
  }



  _unreadMessagesCount() {
    if (widget.chat?.unreadMessagesCount == 0) return const SizedBox();

    return Container(
      margin: const EdgeInsetsDirectional.only(end: 8),
      decoration: const BoxDecoration(
        color: AppColors.SECONDARY_COLOR,
        shape: BoxShape.circle,
      ),
      height: 16,
      width: 16,
      child: Center(
        child: Label(
          text: FormatNumbers().convertNumberToLocalizedString(
              (widget.chat?.unreadMessagesCount.toString() ?? '0'),
              isArabic: context.isArabic) ,
          style: Styles.smallText(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _getFormattedLastMessageTime() {
    // Replace widget.chat?.lastMessageTime with your actual DateTime property
    final DateTime? lastMessageTime =
        widget.chat?.lastMessage?.createdAt; // أو أي property تاني

    return DateTimeHelper.formatLastMessageTime(
        lastMessageTime, context.isArabic);
  }

  _lastMessageTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Label(
          text: _getFormattedLastMessageTime(),
          style: Styles.mediumText(
            fontSize: 24,
            color: (widget.chat?.unreadMessagesCount??0) > 0 ?AppColors.PRIMARY_COLOR_DARK : context.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        SizedBox(height: 12),
        // if (widget.chat?.lastSeenCount != null)
        //   if (widget.chat!.isAdmin != "admin")
        GestureDetector(
          onTap: () {
            ManageVibration.vibrate();
          },
          child: Row(
            children: [
              _unreadMessagesCount(),
              Label(
                text: '10 ',
                style: Styles.mediumText(
                  color: context.isDarkMode ? Colors.white54 : Colors.black45,
                  fontSize: 24,
                ),
              ),
              // const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: InkWell(
                  onTap: () async {
                    ManageVibration.vibrate();
                    // Call the getLastSeen function
                    // print('widget.chat!.isAdmin ${widget.chat!.isAdmin}');
                    // if (widget.chat!.isAdmin != "admin") {
                    //   await context
                    //       .read<ChatsCubit>()
                    //       .getChatLastSeen(chatId: widget.chat!.id);
                    // }
                    // // Open a scrollable bottom sheet
                    // _bottomSheet(context,
                    //     chatsCubit: widget.chatsCubit,
                    //     widgetChat: widget.chat);
                  },
                  child: Icon(
                    FontAwesomeIcons.eye,
                    color: context.isDarkMode ? Colors.white54 : Colors.black45,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

//   _onPressedImageDialog() {
//     showAnimatedDialog(
//         context,
//         AlertDialog(
//           contentPadding: EdgeInsets.zero,
//           backgroundColor: Colors.transparent,
//           content: ClipRRect(
//             child: Stack(
//               children: [
//                 if (widget.chat!.isAdmin == "admin")
//                   Container(
//                     color: Theme.of(context).scaffoldBackgroundColor,
//                     padding: const EdgeInsets.only(
//                         bottom: 40, top: 16, left: 16, right: 16),
//                     child: Image.asset(
//                       Assets.logo,
//                       fit: BoxFit.cover,
//                     ),
//                   )
//                 else
//                   Image.network(
//                     widget.chat!.avatar,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Image.network(
//                         UIConst.profilePlaceHolder,
//                         fit: BoxFit.cover,
//                       );
//                     },
//                   ),
//                 Positioned(
//                   top: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                     color: Colors.black.withValues(alpha: 0.4),
//                     child: Row(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text(
//                             widget.chat!.name,
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: context.isDarkMode
//                                   ? Colors.white
//                                   : Colors.black,
//                             ),
//                           ),
//                         ),
//                         if (widget.chat!.isAdmin == "admin")
//                           const Icon(
//                             Icons.verified,
//                             color: Colors.blue,
//                             size: 16,
//                           ),
//                         if (widget.chat!.lables.isNotEmpty)
//                           Icon(
//                             Icons.label,
//                             color: LabelColorsMap.getColor(
//                                 widget.chat!.lables.last.color),
//                             size: 20,
//                           ),
//                         if (widget.chat!.isAdmin != "admin" &&
//                             widget.chat!.isBirthdayMonth)
//                           InkWell(
//                             onTap: () async {
//                               await showGiftBottomSheet(
//                                 context,
//                                 receiverId: widget.chat!.userId,
//                               );
//                             },
//                             child: const Icon(
//                               FontAwesomeIcons.cakeCandles,
//                               color: AppColors.PRIMARY_COLOR_DARK,
//                               size: 18,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom: 0,
//                   left: 0,
//                   right: 0,
//                   child: Container(
//                       color: Colors.white,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         // Distribute icons evenly
//                         children: [
//                           IconButton(
//                             icon: const Icon(
//                               Icons.chat,
//                               color: AppColors.SECONDARY_COLOR,
//                             ),
//                             onPressed: () {
//                               context.read<ChatsCubit>().selectChat =
//                               widget.chat!;
//                               context.push(Routes.CHATROOM,
//                                   extra: widget.chatsCubit);
//                             },
//                           ),
//                           IconButton(
//                             icon: const Icon(
//                               Icons.call,
//                               color: AppColors.SECONDARY_COLOR,
//                             ),
//                             onPressed: () {},
//                           ),
//                           IconButton(
//                             icon: const Icon(
//                               Icons.videocam,
//                               color: AppColors.SECONDARY_COLOR,
//                             ),
//                             onPressed: () {},
//                           ),
//                           IconButton(
//                             icon: const Icon(
//                               Icons.info,
//                               color: AppColors.SECONDARY_COLOR,
//                             ),
//                             onPressed: () {
//                               context.read<ChatsCubit>().selectChat =
//                               widget.chat!;
//                               context.push(Routes.VIEWCONTACT,
//                                   extra: widget.chatsCubit);
//                             },
//                           ),
//                         ],
//                       )),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
// }

// _bottomSheet(context,
//     {required ChatsCubit? chatsCubit, required ChatEntity? widgetChat}) {
//   return showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     constraints: BoxConstraints(
//       maxHeight: MediaQuery.of(context).size.height * 0.9,
//     ),
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//     ),
//     builder: (context) {
// // Ensure the context has access to ChatsCubit using BlocProvider
//       return BlocProvider<ChatsCubit>.value(
//         value: chatsCubit!,
//         child: Builder(
//           builder: (context) {
//             return BlocBuilder<ChatsCubit, ChatsState>(
//               builder: (context, state) {
//                 return Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
// // Header
//                       Text(
//                         context.isArabic
//                             ? "سجل مشاهدات الدردشة"
//                             : 'Chat Views History',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color:
//                           context.isDarkMode ? Colors.white : Colors.black,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
// // List of last seen chats
//                       if (chatsCubit.lastSeenChats.isEmpty)
//                         Center(
//                           child: Text(
//                             context.isArabic
//                                 ? "لا يوجد بيانات"
//                                 : 'No data available',
//                             style: TextStyle(
//                               color: context.isDarkMode
//                                   ? Colors.white54
//                                   : Colors.black45,
//                             ),
//                           ),
//                         )
//                       else
//                         Flexible(
//                           child: ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: chatsCubit.lastSeenChats.length,
//                             itemBuilder: (context, index) {
//                               final chat = chatsCubit.lastSeenChats[index];
//                               return Padding(
//                                 padding:
//                                 const EdgeInsets.symmetric(vertical: 8.0),
//                                 child: Card(
//                                   elevation: 3,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: ListTile(
//                                     leading: ClipRRect(
//                                       borderRadius: BorderRadius.circular(50),
//                                       child: CircleAvatar(
//                                         radius: 25,
//                                         child: widgetChat!.isAdmin == "admin"
//                                             ? Padding(
//                                           padding: const EdgeInsets.only(
//                                               bottom: 4,
//                                               right: 4,
//                                               left: 8,
//                                               top: 4),
//                                           child: Image.asset(
//                                             Assets.logo,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         )
//                                             : Image.network(
//                                           widgetChat.avatar,
//                                           fit: BoxFit.cover,
//                                           errorBuilder: (context, error,
//                                               stackTrace) {
//                                             return Image.network(
//                                               UIConst.profilePlaceHolder,
//                                               fit: BoxFit.cover,
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                     ),
//                                     title: Row(
//                                       children: [
//                                         Text(
//                                           chat.name,
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             color: context.isDarkMode
//                                                 ? Colors.white
//                                                 : Colors.black,
//                                           ),
//                                         ),
//                                         widgetChat.isAdmin == "admin"
//                                             ? const Icon(
//                                           Icons.verified,
//                                           color: Colors.blue,
//                                           size: 20,
//                                         )
//                                             : const SizedBox(),
//                                       ],
//                                     ),
//                                     subtitle: Label(
//                                       text: '${chat.date} - ${chat.time}',
//                                       style: Styles.mediumText(),
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       );
//     },
//   );
// }


}
