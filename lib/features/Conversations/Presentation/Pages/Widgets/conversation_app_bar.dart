import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../../common/widgets/stateless/buttons/iconAppButton.dart';
import '../../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../../core/enums/call_enums_manager.dart';
import '../../../../../../../core/extensions/context_extension.dart';
import '../../../../../../../core/extensions/string_extension.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../core/states/basic_state.dart';
import '../../../../../../../helpers/call_helpers/notifications_helper/fcm_notification_helper.dart';
import '../../../../../../../res/assets/assets.dart';
import '../../../../../../../res/style/app_colors.dart';
import '../../../../../../../res/style/const.dart';
import '../../../../../../../res/style/styles.dart';
import '../../../../../../../routes/routes.dart';
import '../../../../../../../service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../../../helpers/manage_vibration.dart';
import '../../Controllers/cubits/conversation_states.dart';
import '../../Controllers/cubits/conversations_cubit.dart';

class ConversationAppBar extends StatefulWidget implements PreferredSizeWidget {
  const ConversationAppBar({super.key});

  @override
  State<ConversationAppBar> createState() => _ConversationAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ConversationAppBarState extends State<ConversationAppBar> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationsCubit, ConversationsState>(
      builder: (context, state) {
        return Column(
          children: [
            Directionality(
          textDirection: TextDirection.ltr,
          child: AppBar(
            backgroundColor: context.isDarkMode
                ? AppColors.QUANTITY_COLOR
                : Colors.white,
            surfaceTintColor: context.isDarkMode
                ? AppColors.QUANTITY_COLOR
                : Colors.white,
            // Background color
            elevation: 0,
            leadingWidth: 20,
            leading: InkWell(
              onTap: () {
                ManageVibration.vibrate();
                // if (context
                //     .read<ChatRoomCubit>()
                //     .chat
                //     .isSearching) {
                //   context.read<ChatRoomCubit>().stopSearching();
                // } else {
                //   context.pop();
                // }
                context.pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: context.isDarkMode
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            title:
            // widget.chatRoomCubit.chat.isSearching
            //     ? Container(
            //   height: 40,
            //   padding:
            //   const EdgeInsets.symmetric(horizontal: 8),
            //   decoration: BoxDecoration(
            //     color: Colors.transparent,
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: TextField(
            //     onChanged: (value) {
            //       // Handle search input here
            //     },
            //     cursorColor: context.isDarkMode
            //         ? Colors.white
            //         : Colors.black,
            //     style: Styles.mediumText(
            //       color: context.isDarkMode
            //           ? Colors.white54
            //           : Colors
            //           .black54, // Same as hint text color
            //     ),
            //     decoration: InputDecoration(
            //       hintText: context.isArabic
            //           ? "بحث..."
            //           : "Search...",
            //       hintStyle: Styles.mediumText(
            //         color: context.isDarkMode
            //             ? Colors.white54
            //             : Colors.black54,
            //       ),
            //       border: InputBorder.none,
            //       filled: false,
            //     ),
            //   ),
            // )
            //     : widget.chatRoomCubit.selectedMessages.isEmpty
            //     ?
            GestureDetector(
              // onTap: context
              //     .read<ChatsCubit>()
              //     .selectedChat
              //     .isAdmin ==
              //     "admin"
              //     ? null
              //     : () => context.push(
              //   Routes.VIEWCONTACT,
              //   extra: chatsCubit,
              // ),
              child: Row(
                children: [
                  // context
                  //     .read<ChatsCubit>()
                  //     .selectedChat
                  //     .avatar !=
                  //     ""
                  //     ? InkWell(
                  //   onTap: context
                  //       .read<ChatsCubit>()
                  //       .selectedChat
                  //       .hasStory
                  //       ? () {
                  //     // navigate to stories
                  //   }
                  //       : null,
                  //   child: Container(
                  //     height: kToolbarHeight * .8,
                  //     width: kToolbarHeight * .8,
                  //     decoration: context
                  //         .read<ChatsCubit>()
                  //         .selectedChat
                  //         .hasStory
                  //         ? BoxDecoration(
                  //         borderRadius:
                  //         BorderRadius
                  //             .circular(50),
                  //         border: Border.all(
                  //           color: context
                  //               .isDarkMode
                  //               ? Colors.white
                  //               : AppColors
                  //               .PRIMARY_COLOR_DARK,
                  //           width: 3,
                  //         ))
                  //         : null,
                  //     child: CircleAvatar(
                  //       backgroundColor:
                  //       Colors.white,
                  //       backgroundImage: context
                  //           .read<
                  //           ChatsCubit>()
                  //           .selectedChat
                  //           .isAdmin ==
                  //           "admin"
                  //           ? null
                  //           : NetworkImage(
                  //         context
                  //             .read<
                  //             ChatsCubit>()
                  //             .selectedChat
                  //             .avatar,
                  //       ),
                  //       child: context
                  //           .read<
                  //           ChatsCubit>()
                  //           .selectedChat
                  //           .isAdmin !=
                  //           "admin"
                  //           ? null
                  //           : Padding(
                  //         padding:
                  //         const EdgeInsets
                  //             .only(
                  //             top: 4,
                  //             left: 8,
                  //             right: 4,
                  //             bottom: 4),
                  //         child: Image.asset(
                  //           Assets.logo,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // )
                  //     : InkWell(
                  //   onTap: context
                  //       .read<ChatsCubit>()
                  //       .selectedChat
                  //       .hasStory
                  //       ? () {
                  //     // navigate to stories
                  //   }
                  //       : null,
                  //   child: Container(
                  //     height: kToolbarHeight * .8,
                  //     width: kToolbarHeight * .8,
                  //     decoration: context
                  //         .read<ChatsCubit>()
                  //         .selectedChat
                  //         .hasStory
                  //         ? BoxDecoration(
                  //       borderRadius:
                  //       BorderRadius
                  //           .circular(50),
                  //       border: Border.all(
                  //         color: context
                  //             .isDarkMode
                  //             ? Colors.white
                  //             : AppColors
                  //             .PRIMARY_COLOR_DARK,
                  //         width: 3,
                  //       ),
                  //     )
                  //         : null,
                  //     child: const CircleAvatar(
                  //       backgroundColor:
                  //       Colors.white,
                  //       backgroundImage:
                  //       NetworkImage(
                  //         UIConst
                  //             .profilePlaceHolder,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 60,
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(
                                          context)
                                          .size
                                          .width *
                                          0.30),
                                  child: Label(
                                    text: "Ahmed Nasr",
                                    style:
                                    Styles.headerText(
                                      color: context
                                          .isDarkMode
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight:
                                      FontWeight.w400,
                                    ),
                                  ),
                                ),
                                // context
                                //     .read<
                                //     ChatsCubit>()
                                //     .selectedChat
                                //     .isAdmin ==
                                //     "admin"
                                //     ? Positioned(
                                //   right: context
                                //       .isArabic
                                //       ? 0
                                //       : -72,
                                //   left: context
                                //       .isArabic
                                //       ? -72
                                //       : 0,
                                //   child: const Icon(
                                //     Icons.verified,
                                //     color:
                                //     Colors.blue,
                                //     size: 20,
                                //   ),
                                // )
                                //     : const SizedBox(),
                              ],
                            ),
                          ],
                        ),
                        if (context
                            .read<ConversationsCubit>()
                            .selectedConversation
                            ?.isTyping == true)
                          Label(
                            text: context.isArabic
                                ? "يكتب..."
                                : "Typing...",
                            style: Styles.mediumText(
                              fontSize: 24,
                              color: AppColors
                                  .SECONDARY_COLOR,
                            ),
                          ),
                        if (context
                            .read<ConversationsCubit>()
                            .selectedConversation
                            ?.isRecording == true)
                          Label(
                            text: context.isArabic
                                ? "يسجل رساله صوتية..."
                                : "Recording...",
                            style: Styles.mediumText(
                              fontSize: 24,
                              color: AppColors
                                  .SECONDARY_COLOR,
                            ),
                          ),
                        // if (!context
                        //     .read<ChatsCubit>()
                        //     .selectedChat
                        //     .typing &&
                        //     !context
                        //         .read<ChatsCubit>()
                        //         .selectedChat
                        //         .recording)
                        //   if (context
                        //       .read<ChatsCubit>()
                        //       .selectedChat
                        //       .isAdmin ==
                        //       "admin")
                        //     Label(
                        //       text: context.isArabic
                        //           ? " 49Hub الرسمي"
                        //           : "Official 49Hub",
                        //       style: Styles.mediumText(
                        //         fontSize: 24,
                        //         color: context.isDarkMode
                        //             ? Colors.white
                        //             : Colors.black,
                        //       ),
                        //     )
                        //   else if (context
                        //       .read<ChatsCubit>()
                        //       .selectedChat
                        //       .online)
                        //     Label(
                        //       text: context.isArabic
                        //           ? "متصل"
                        //           : "Online",
                        //       style: Styles.mediumText(
                        //         fontSize: 24,
                        //         color: context.isDarkMode
                        //             ? Colors.white
                        //             : Colors.black,
                        //       ),
                        //     )
                        //   else if (chatsCubit.selectedChat
                        //         .lastSeen !=
                        //         null)
                        //       Label(
                        //         text: context.isArabic
                        //             ? " اخر ظهور في ${chatsCubit.selectedChat.lastSeen}"
                        //             : "Last seen at ${chatsCubit.selectedChat.lastSeen}",
                        //         style: Styles.mediumText(
                        //           fontSize: 24,
                        //           color: context.isDarkMode
                        //               ? Colors.white
                        //               : Colors.black,
                        //         ),
                        //       ),
                      ],
                    ),
                  ),
                ],
              ),
            )
            //     : Text(
            //   widget.chatRoomCubit.selectedMessages.length
            //       .toString(),
            //   // 'state.chatData?.chat?.contact?.name',
            //   overflow: TextOverflow.ellipsis,
            //   style: Styles.mediumText(
            //     color: context.isDarkMode
            //         ? Colors.white
            //         : Colors.black,
            //     fontWeight: FontWeight.w600,
            //   ),
            // )
            ,
            actions:
            // widget.chatRoomCubit.chat.isSearching
            //     ? []
            //     : widget.chatRoomCubit.selectedMessages.isEmpty
            //     ? context
            //     .read<ChatsCubit>()
            //     .selectedChat
            //     .isAdmin ==
            //     "admin"
            //     ? []
            //     :
            [

              IconButton(
                icon: Icon(
                  Icons.videocam,
                  size: 24,
                  color: context.isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () async {
                  // ManageVibration.vibrate();
                  // if (await Permission.microphone
                  //     .request() !=
                  //     PermissionStatus.granted ||
                  //     await Permission.camera
                  //         .request() !=
                  //         PermissionStatus.granted) {
                  //   await Permission.microphone
                  //       .request();
                  //   await Permission.camera.request();
                  // }
                  // if (chat.fcmToken == null) {
                  //   showCustomSnackBar(
                  //       context,
                  //       LocaleKeys.userNotAvailable
                  //           .localize,
                  //       Icon(
                  //           Icons
                  //               .warning_amber_rounded,
                  //           color: AppColors
                  //               .PRIMARY_COLOR_DARK));
                  //   return;
                  // }
                  // final fcmToken =
                  // await serviceLocator<
                  //     FcmNotificationHelper>()
                  //     .getFcmUserToken();
                  //
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) =>
                  //         SendWhatsappCallScreen(
                  //           isRealCall: true,
                  //           callType: CallType.video,
                  //           receiver: UserModel(
                  //               id: chat.userId,
                  //               firstName: chat.name,
                  //               lastName: '',
                  //               firebaseToken:
                  //               chat.fcmToken),
                  //           sender: UserModel(
                  //             id: userStateEntity
                  //                 .data!.id,
                  //             firstName: userStateEntity
                  //                 .data!.firstName,
                  //             lastName: userStateEntity
                  //                 .data!.lastName,
                  //             firebaseToken: fcmToken,
                  //           ),
                  //         ),
                  //   ),
                  // );
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.call,
                  size: 20,
                  color: context.isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
                onPressed: () async {
                  ManageVibration.vibrate();
                  // if (await Permission.microphone
                  //     .request() !=
                  //     PermissionStatus.granted ||
                  //     await Permission.camera
                  //         .request() !=
                  //         PermissionStatus.granted) {
                  //   await Permission.microphone
                  //       .request();
                  //   await Permission.camera.request();
                  // }
                  // print(
                  //     'sender data is ${chat.id}, ${chat.name}, ${chat.avatar}, ${chat.fcmToken}');
                  // final fcmToken =
                  // await serviceLocator<
                  //     FcmNotificationHelper>()
                  //     .getFcmUserToken();
                  // print('FCM Token: $fcmToken');
                  // if (chat.fcmToken == null) {
                  //   showCustomSnackBar(
                  //       context,
                  //       LocaleKeys.userNotAvailable
                  //           .localize,
                  //       Icon(
                  //           Icons
                  //               .warning_amber_rounded,
                  //           color: AppColors
                  //               .PRIMARY_COLOR_DARK));
                  //   return;
                  // }
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             SendWhatsappCallScreen(
                  //               isRealCall: true,
                  //               callType:
                  //               CallType.audio,
                  //               receiver: UserModel(
                  //                 id: chat.userId,
                  //                 firstName:
                  //                 chat.name,
                  //                 lastName: '',
                  //                 firebaseToken:
                  //                 chat.fcmToken,
                  //               ),
                  //               sender: UserModel(
                  //                 id: userStateEntity
                  //                     .data!.id,
                  //                 firstName:
                  //                 userStateEntity
                  //                     .data!
                  //                     .firstName,
                  //                 lastName:
                  //                 userStateEntity
                  //                     .data!
                  //                     .lastName,
                  //                 firebaseToken:
                  //                 fcmToken,
                  //               ),
                  //             )));
                },
              ),
              PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: context.isDarkMode
                      ? Colors.white
                      : Colors.black,
                ),
                color: context.isDarkMode
                    ? AppColors.QUANTITY_COLOR
                    : AppColors.BACKGROUND_COLOR,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(16.0)),
                ),
                offset: const Offset(0, 50),
                onSelected: (int value) async {
                  if (value == 0) {
                    // context.push(Routes.VIEWCONTACT,
                    //     extra: chatsCubit);
                  }
                  if (value == 1) {
                    // context.push(
                    //   Routes.ATTACHMENTSVIEW,
                    //   extra: widget.chatRoomCubit,
                    // );
                  }
                  if (value == 5) {
                    // Show alert dialog when "Clear Chat" is selected
                    // _showClearChatAlert(context,
                    //     widget.chatRoomCubit);
                  }
                  if (value == 6) {
                    // await widget.chatRoomCubit
                    //     .getLabels();
                    // _showLabelChatBottomSheet(context,
                    //     widget.chatRoomCubit);
                  }
                  if (value == 2) {
                    // widget.chatRoomCubit
                    //     .startSearching();
                  }
                },
                itemBuilder: (context) {
                  return _mainMenuBuilder(context);
                },
              )
            ]
            //     : [
            //   if (widget.chatRoomCubit.selectedMessages
            //       .length ==
            //       1)
            //     IconAppButton(
            //       icon: Icons.copy,
            //       size: 20,
            //       onPressed: () async {
            //         ManageVibration.vibrate();
            //         await widget.chatRoomCubit
            //             .copyMessage(
            //           widget.chatRoomCubit
            //               .selectedMessages.first,
            //         );
            //         widget.chatRoomCubit
            //             .clearSelectedMessages();
            //       },
            //       color: context.isDarkMode
            //           ? Colors.white
            //           : Colors.black,
            //     ),
            //   if (widget.chatRoomCubit.selectedMessages
            //       .length ==
            //       1)
            //     IconButton(
            //       onPressed: () async {
            //         ManageVibration.vibrate();
            //         await widget.chatRoomCubit.pinMessage(
            //           message: widget.chatRoomCubit
            //               .selectedMessages.first,
            //         );
            //       },
            //       icon: Icon(
            //         Icons.push_pin,
            //         size: 24,
            //         color: context.isDarkMode
            //             ? Colors.white
            //             : Colors.black,
            //       ),
            //     ),
            //   IconButton(
            //     onPressed: () async {
            //       ManageVibration.vibrate();
            //       // await chatsCubit.deleteChat();
            //       await widget.chatRoomCubit
            //           .deleteMessages();
            //     },
            //     icon: Icon(
            //       Icons.delete_forever,
            //       size: 24,
            //       color: context.isDarkMode
            //           ? Colors.white
            //           : Colors.black,
            //     ),
            //   ),
            //   IconButton(
            //     onPressed: () async {
            //       ManageVibration.vibrate();
            //       context.push(
            //         Routes.FORWARDMESSAGES,
            //         extra: ForwardMessagesViewParams(
            //           chatRoomCubit: widget.chatRoomCubit,
            //           chatsCubit: chatsCubit,
            //         ),
            //       );
            //     },
            //     icon: Icon(
            //       Icons.shortcut,
            //       size: 24,
            //       color: context.isDarkMode
            //           ? Colors.white
            //           : Colors.black,
            //     ),
            //   ),
            // ],
          ),
        ),
            // if (widget.chatRoomCubit.chat.pinnedMessageId != null)
            //   _buildPinnedMessageCard(context),
            // if (widget.chatRoomCubit.chat.isBirthdayMonth)
            //   InkWell(
            //     onTap: () async {
            //       ManageVibration.vibrate();
            //       await showGiftBottomSheet(
            //         context,
            //         receiverId: widget.chatRoomCubit.chat.userId,
            //       );
            //     },
            //     child: Container(
            //       width: double.infinity,
            //       // height: 50,
            //       color: context.isDarkMode
            //           ? AppColors.QUANTITY_COLOR
            //           : Colors.white,
            //       child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Row(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             const SizedBox(width: 8),
            //             ConstrainedBox(
            //               constraints: BoxConstraints(
            //                   maxWidth:
            //                   MediaQuery.of(context).size.width * 0.85),
            //               child: Text(
            //                 context.isArabic
            //                     ? "إنه عيد ميلاد ${widget.chatRoomCubit.chat.name}، أرسل هدية! 🎂🎉"
            //                     : 'It\'s ${widget.chatRoomCubit.chat.name} birthday, Send Gift!🎂🎉',
            //                 overflow: TextOverflow.ellipsis,
            //                 style: Styles.mediumText(
            //                   color: context.isDarkMode
            //                       ? Colors.white
            //                       : Colors.black,
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        );
      }
    );
  }

  // void _showLabelChatBottomSheet(
  //     BuildContext context, ChatRoomCubit chatRoomCubit) {
  //   log("lables length : ${chatRoomCubit.chat.lables.length}");
  //
  //   TextEditingController newLabelController = TextEditingController();
  //   bool isEditingNewLabel = false;
  //   String newLabelColor = LabelColorsMap.getRandomColor();
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     constraints: BoxConstraints(
  //       maxHeight: MediaQuery.of(context).size.height *
  //           0.9, // Set height to 90% of screen height
  //     ),
  //     builder: (BuildContext context) {
  //       return BlocProvider.value(
  //         value: chatRoomCubit,
  //         child: BlocBuilder<ChatRoomCubit, ChatRoomState>(
  //           builder: (context, state) {
  //             return Padding(
  //               padding: const EdgeInsets.all(16.0),
  //               child: Column(
  //                 children: [
  //                   Container(
  //                     width: 50,
  //                     height: 4,
  //                     padding: const EdgeInsets.all(16),
  //                     decoration: BoxDecoration(
  //                       color: context.isDarkMode
  //                           ? AppColors.QUANTITY_COLOR
  //                           : Colors.white,
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                   ),
  //                   const SizedBox(height: 10),
  //                   Text(
  //                     context.isArabic ? "اضافة علامة للمحادثة" : "Label Chat",
  //                     style: TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                       color: context.isDarkMode ? Colors.white : Colors.black,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 20),
  //                   Expanded(
  //                     child: StatefulBuilder(
  //                       builder: (context, setState) {
  //                         return ListView.builder(
  //                           itemCount: chatRoomCubit.chat.lables.length + 1,
  //                           itemBuilder: (context, index) {
  //                             log("lables length before index: ${chatRoomCubit.chat.lables.length}");
  //                             log("index : $index");
  //                             if (index == 0) {
  //                               if (isEditingNewLabel) {
  //                                 return Padding(
  //                                   padding: const EdgeInsets.symmetric(
  //                                       vertical: 4.0),
  //                                   child: Row(
  //                                     children: [
  //                                       InkWell(
  //                                         onTap: () {
  //                                           ManageVibration.vibrate();
  //                                           setState(() {
  //                                             newLabelColor = LabelColorsMap
  //                                                 .getRandomColor();
  //                                           });
  //                                         },
  //                                         child: Container(
  //                                           decoration: BoxDecoration(
  //                                             color: LabelColorsMap.getColor(
  //                                                 newLabelColor),
  //                                             shape: BoxShape.circle,
  //                                           ),
  //                                           padding: const EdgeInsets.all(8),
  //                                           child: Icon(
  //                                             Icons.label_outlined,
  //                                             color: context.isDarkMode
  //                                                 ? Colors.white
  //                                                 : Colors.black,
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       const SizedBox(width: 10),
  //                                       Expanded(
  //                                         child: Theme(
  //                                           data: ThemeData(
  //                                             primaryColor:
  //                                             AppColors.PRIMARY_COLOR,
  //                                             // تحديد اللون الأساسي
  //                                             inputDecorationTheme:
  //                                             InputDecorationTheme(
  //                                               focusedBorder:
  //                                               const UnderlineInputBorder(
  //                                                 borderSide: BorderSide(
  //                                                   color:
  //                                                   AppColors.PRIMARY_COLOR,
  //                                                   // تحديد اللون للحد السفلي
  //                                                   width:
  //                                                   2.0, // تعديل سمك الحد السفلي
  //                                                 ),
  //                                               ),
  //                                               enabledBorder:
  //                                               UnderlineInputBorder(
  //                                                 borderSide: BorderSide(
  //                                                   color: AppColors
  //                                                       .PRIMARY_COLOR
  //                                                       .withValues(alpha: 0.5),
  //                                                   // تغيير اللون عند عدم التركيز
  //                                                   width: 2.0,
  //                                                 ),
  //                                               ),
  //                                             ),
  //                                           ),
  //                                           child: TextField(
  //                                             controller: newLabelController,
  //                                             onChanged: (value) =>
  //                                                 setState(() {}),
  //                                             decoration: InputDecoration(
  //                                               hintText: context.isArabic
  //                                                   ? "اسم العلامة"
  //                                                   : "New Label",
  //                                             ),
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       const SizedBox(width: 10),
  //                                       newLabelController.text.isNotEmpty
  //                                           ? IconButton(
  //                                         icon: Icon(
  //                                           Icons.check,
  //                                           color: context.isDarkMode
  //                                               ? Colors.white
  //                                               : AppColors
  //                                               .PRIMARY_COLOR_DARK,
  //                                         ),
  //                                         onPressed: () async {
  //                                           ManageVibration.vibrate();
  //                                           await chatRoomCubit
  //                                               .createLable(
  //                                               name:
  //                                               newLabelController
  //                                                   .text,
  //                                               color: newLabelColor);
  //                                           setState(() {
  //                                             isEditingNewLabel = false;
  //                                             newLabelController.clear();
  //                                           });
  //                                         },
  //                                       )
  //                                           : IconButton(
  //                                         icon: Icon(
  //                                           Icons.close,
  //                                           color: context.isDarkMode
  //                                               ? Colors.white
  //                                               : AppColors
  //                                               .PRIMARY_COLOR_DARK,
  //                                         ),
  //                                         onPressed: () async {
  //                                           ManageVibration.vibrate();
  //                                           setState(() {
  //                                             isEditingNewLabel = false;
  //                                             newLabelController.clear();
  //                                           });
  //                                         },
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 );
  //                               } else {
  //                                 return InkWell(
  //                                   onTap: () {
  //                                     ManageVibration.vibrate();
  //                                     setState(() {
  //                                       isEditingNewLabel = true;
  //                                     });
  //                                   },
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.symmetric(
  //                                         vertical: 4.0),
  //                                     child: Row(
  //                                       children: [
  //                                         Container(
  //                                           decoration: BoxDecoration(
  //                                             color: Colors.grey
  //                                                 .withValues(alpha: 0.3),
  //                                             borderRadius:
  //                                             BorderRadius.circular(50),
  //                                           ),
  //                                           padding: const EdgeInsets.all(10),
  //                                           child: Icon(Icons.add,
  //                                               color: context.isDarkMode
  //                                                   ? Colors.white
  //                                                   : Colors.black),
  //                                         ),
  //                                         const SizedBox(width: 10),
  //                                         Text(
  //                                           context.isArabic
  //                                               ? "علامة جديدة"
  //                                               : "New Label",
  //                                           style: TextStyle(
  //                                             fontSize: 16,
  //                                             fontWeight: FontWeight.w600,
  //                                             color: context.isDarkMode
  //                                                 ? Colors.white
  //                                                 : Colors.black,
  //                                           ),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                   ),
  //                                 );
  //                               }
  //                             } else {
  //                               return Padding(
  //                                 padding:
  //                                 const EdgeInsets.symmetric(vertical: 4.0),
  //                                 child: Row(
  //                                   children: [
  //                                     Container(
  //                                       decoration: BoxDecoration(
  //                                         color: LabelColorsMap.getColor(
  //                                             chatRoomCubit.chat
  //                                                 .lables[index - 1].color),
  //                                         shape: BoxShape.circle,
  //                                       ),
  //                                       padding: const EdgeInsets.all(8),
  //                                       child: Icon(
  //                                         Icons.label_outlined,
  //                                         color: context.isDarkMode
  //                                             ? Colors.white
  //                                             : Colors.black,
  //                                       ),
  //                                     ),
  //                                     const SizedBox(width: 10),
  //                                     Text(
  //                                       chatRoomCubit
  //                                           .chat.lables[index - 1].name,
  //                                       style: const TextStyle(
  //                                           fontSize: 16,
  //                                           fontWeight: FontWeight.w600),
  //                                     ),
  //                                     const Spacer(),
  //                                     Checkbox(
  //                                       value: chatRoomCubit
  //                                           .chat.lables[index - 1].isSelected,
  //                                       activeColor:
  //                                       AppColors.PRIMARY_COLOR_DARK,
  //                                       checkColor: Colors.black,
  //                                       onChanged: (bool? newValue) {
  //                                         chatRoomCubit.updateLabelSelection(
  //                                             index - 1, newValue);
  //                                       },
  //                                     ),
  //                                   ],
  //                                 ),
  //                               );
  //                             }
  //                           },
  //                         );
  //                       },
  //                     ),
  //                   ),
  //                   Container(
  //                     width: double.infinity, // Full width of the screen
  //                     padding: const EdgeInsets.symmetric(
  //                         vertical: 12.0,
  //                         horizontal: 16), // Padding for the button
  //                     child: ElevatedButton(
  //                       style: ElevatedButton.styleFrom(
  //                         padding: const EdgeInsets.symmetric(vertical: 8),
  //                         backgroundColor:
  //                         AppColors.PRIMARY_COLOR, // Button color
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(50),
  //                         ),
  //                       ),
  //                       onPressed: () async {
  //                         ManageVibration.vibrate();
  //                         // Action to save or perform when Save is tapped
  //                         await chatRoomCubit.assignLabels();
  //                         Navigator.pop(context);
  //                       },
  //                       child: Text(
  //                         context.isArabic ? "حفظ" : "Save",
  //                         style: TextStyle(
  //                           fontSize: 16,
  //                           fontWeight: FontWeight.bold,
  //                           color: context.isDarkMode
  //                               ? Colors.white
  //                               : Colors.black,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  // Widget _buildPinnedMessageCard(BuildContext context) {
  //   return BlocBuilder<ChatRoomCubit, ChatRoomState>(
  //     builder: (context, state) {
  //       return widget.chatRoomCubit.chat.pinnedMessage == null
  //           ? const SizedBox()
  //           : Container(
  //         width: double.infinity,
  //         // height: 50,
  //         color: context.isDarkMode
  //             ? AppColors.QUANTITY_COLOR
  //             : AppColors.PRIMARY_COLOR,
  //         child: Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Icon(
  //                 Icons.push_pin,
  //                 size: 20,
  //                 color: context.isDarkMode
  //                     ? Colors.white54
  //                     : Colors.black54,
  //               ),
  //               const SizedBox(width: 8),
  //               ConstrainedBox(
  //                 constraints: BoxConstraints(
  //                     maxWidth: MediaQuery.of(context).size.width * 0.8),
  //                 child: Text(
  //                   widget.chatRoomCubit.chat.pinnedMessage!.text,
  //                   overflow: TextOverflow.ellipsis,
  //                   style: Styles.mediumText(
  //                     color: context.isDarkMode
  //                         ? Colors.white
  //                         : Colors.black,
  //                   ),
  //                 ),
  //               ),
  //               const Spacer(),
  //               InkWell(
  //                 onTap: () async {
  //                   ManageVibration.vibrate();
  //                   await widget.chatRoomCubit.unpinMessage();
  //                 },
  //                 child: Icon(
  //                   Icons.close,
  //                   size: 20,
  //                   color: context.isDarkMode
  //                       ? Colors.white54
  //                       : Colors.black54,
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  List<PopupMenuEntry<int>> _mainMenuBuilder(BuildContext context) {
    return [
      PopupMenuItem<int>(
        value: 0,
        child: Text(
          LocaleKeys.viewContact.localize,
          style: Styles.mediumText(
            color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
          ),
        ),
      ),
      PopupMenuItem<int>(
        value: 1,
        child: Text(
          LocaleKeys.mediaLinksAndDocs.localize,
          style: Styles.mediumText(
            color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
          ),
        ),
      ),
      PopupMenuItem<int>(
        value: 2,
        child: Text(
          LocaleKeys.search.localize,
          style: Styles.mediumText(
            color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
          ),
        ),
      ),
      PopupMenuItem<int>(
        value: 3,
        child: Text(
          LocaleKeys.muteNotifications.localize,
          style: Styles.mediumText(
            color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
          ),
        ),
      ),
      // PopupMenuItem<int>(
      //   value: 4,
      //   child: Text(
      //     LocaleKeys.wallpaper.localize,
      //     style: Styles.mediumText(
      //         color:
      //             context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
      //   ),
      // ),
      // PopupMenuItem<int>(
      //   value: 5,
      //   child: Text(
      //     LocaleKeys.disappearingMessages.localize,
      //     style: Styles.mediumText(
      //         color:
      //             context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR),
      //   ),
      // ),
      // PopupMenuItem<int>(
      //   value: 6,
      //   child: Row(
      //     mainAxisSize: MainAxisSize.min,
      //     children: [
      //       Text(
      //         LocaleKeys.more.localize,
      //         style: Styles.mediumText(
      //             color: context.isDarkMode
      //                 ? Colors.white
      //                 : AppColors.PRIMARY_COLOR),
      //       ),
      //       const Spacer(),
      //       Icon(
      //         Icons.arrow_forward_ios,
      //         size: 22,
      //         color:
      //             context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
      //       )
      //     ],
      //   ),
      // ),
      PopupMenuItem<int>(
        value: 4,
        child: Text(
          LocaleKeys.block.localize,
          style: Styles.mediumText(
            color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
          ),
        ),
      ),
      PopupMenuItem<int>(
        value: 5,
        // onTap: () {
        //   // Show alert dialog when "Clear Chat" is selected
        //   _showClearChatAlert(context, chatRoomCubit);
        // },
        child: Text(
          LocaleKeys.clearChat.localize,
          style: Styles.mediumText(
            color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
          ),
        ),
      ),
      PopupMenuItem<int>(
        value: 6,
        child: Text(
          context.isArabic ? "اضافة علامة للمحادثة" : "Label Chat",
          style: Styles.mediumText(
            color: context.isDarkMode ? Colors.white : AppColors.PRIMARY_COLOR,
          ),
        ),
      ),
    ];
  }

  // void _showMoreMenu(BuildContext context, ChatRoomCubit chatRoomCubit) {
  //   showMenu<int>(
  //     context: context,
  //     position: RelativeRect.fromLTRB(LocaleKeys.more.tr() != "More" ? 0 : 250,
  //         78, LocaleKeys.more.tr() == "More" ? 0 : 250, 0),
  //     items: [
  //       PopupMenuItem<int>(
  //         value: 1,
  //         child: Text(
  //           LocaleKeys.edit.localize,
  //           style: Styles.mediumText(
  //               color: context.isDarkMode
  //                   ? Colors.white
  //                   : AppColors.PRIMARY_COLOR,),
  //         ),
  //       ),
  //       PopupMenuItem<int>(
  //         value: 2,
  //         child: Text(
  //           LocaleKeys.share.localize,
  //           style: Styles.mediumText(
  //               color: context.isDarkMode
  //                   ? Colors.white
  //                   : AppColors.PRIMARY_COLOR,),
  //         ),
  //       ),
  //       PopupMenuItem<int>(
  //         value: 3,
  //         child: Text(
  //           LocaleKeys.report.localize,
  //           style: Styles.mediumText(
  //               color: context.isDarkMode
  //                   ? Colors.white
  //                   : AppColors.PRIMARY_COLOR,),
  //         ),
  //       ),
  //       PopupMenuItem<int>(
  //         value: 4,
  //         child: Text(
  //           LocaleKeys.block.localize,
  //           style: Styles.mediumText(
  //               color: context.isDarkMode
  //                   ? Colors.white
  //                   : AppColors.PRIMARY_COLOR,),
  //         ),
  //       ),
  //       PopupMenuItem<int>(
  //         value: 5,
  //         onTap: () {
  //           // Show alert dialog when "Clear Chat" is selected
  //           _showClearChatAlert(context, chatRoomCubit);
  //         },
  //         child: Text(
  //           LocaleKeys.clearChat.localize,
  //           style: Styles.mediumText(
  //               color: context.isDarkMode
  //                   ? Colors.white
  //                   : AppColors.PRIMARY_COLOR,),
  //         ),
  //       ),
  //       PopupMenuItem<int>(
  //         value: 6,
  //         child: Text(
  //           LocaleKeys.exportChat.localize,
  //           style: Styles.mediumText(
  //               color: context.isDarkMode
  //                   ? Colors.white
  //                   : AppColors.PRIMARY_COLOR,),
  //         ),
  //       ),
  //       PopupMenuItem<int>(
  //         value: 7,
  //         child: Text(
  //           "${LocaleKeys.addShortcut.tr()}      ",
  //           style: Styles.mediumText(
  //               color: context.isDarkMode
  //                   ? Colors.white
  //                   : AppColors.PRIMARY_COLOR,),
  //         ),
  //       ),
  //     ],
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.all(Radius.circular(16.0)),
  //     ),
  //     color: context.isDarkMode
  //         ? AppColors.PRIMARY_COLOR
  //         : AppColors.BACKGROUND_COLOR,
  //   );
  // }

  // void _showClearChatAlert(BuildContext context, ChatRoomCubit chatRoomCubit) {
  //   int selectedOption = 0; // To track the selected radio button
  //
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           LocaleKeys.clearThisChat.localize,
  //         ),
  //         content: StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //             return Column(
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 ListTile(
  //                   title: Text(
  //                     LocaleKeys.clearForMe.localize,
  //                     style: Styles.mediumText(
  //                       color: context.isDarkMode
  //                           ? Colors.white
  //                           : AppColors.PRIMARY_COLOR,
  //                     ),
  //                   ),
  //                   leading: Radio<int>(
  //                     value: 0,
  //                     // activeColor: AppColors.PRIMARY_COLOR_DARK,
  //                     groupValue: selectedOption,
  //                     onChanged: (int? value) {
  //                       setState(() {
  //                         selectedOption = value!;
  //                       });
  //                     },
  //                   ),
  //                 ),
  //                 ListTile(
  //                   title: Text(
  //                     LocaleKeys.clearForEveryone.localize,
  //                     style: Styles.mediumText(
  //                       color: context.isDarkMode
  //                           ? Colors.white
  //                           : AppColors.PRIMARY_COLOR,
  //                     ),
  //                   ),
  //                   leading: Radio<int>(
  //                     value: 1,
  //                     // activeColor: AppColors.PRIMARY_COLOR_DARK,
  //                     groupValue: selectedOption,
  //                     onChanged: (int? value) {
  //                       setState(() {
  //                         selectedOption = value!;
  //                       });
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             );
  //           },
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text(
  //               LocaleKeys.cancel.localize,
  //               style: Styles.mediumText(
  //                 color: context.isDarkMode
  //                     ? Colors.white
  //                     : AppColors.PRIMARY_COLOR,
  //               ),
  //             ),
  //             onPressed: () {
  //               ManageVibration.vibrate();
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: Text(
  //               LocaleKeys.clearChat.localize,
  //               style: Styles.mediumText(color: AppColors.PRIMARY_COLOR_DARK),
  //             ),
  //             onPressed: () async {
  //               ManageVibration.vibrate();
  //               await chatRoomCubit.clearChat(clearForAll: selectedOption == 1);
  //               // ignore: use_build_context_synchronously
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
