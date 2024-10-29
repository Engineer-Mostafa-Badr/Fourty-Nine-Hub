// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
// import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
// import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
// import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
// import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
// import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
// import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/chat_cubit/chat_room_cubit.dart';
// import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/room/replay_message_widget.dart';
// import 'package:fourtyninehub/res/style/app_colors.dart';
// import 'package:social_media_recorder/audio_encoder_type.dart';
// import 'package:social_media_recorder/screen/social_media_recorder.dart';
// import 'package:flutter/foundation.dart' as foundation;
// import 'Attachment_types.dart';

// class SendMessageWidget extends StatefulWidget {
//   MessageEntity? replayMessage;
//   final VoidCallback? onCancelReplay;
//   FocusNode focusNode;
//   String anotherUserName;

//   SendMessageWidget(
//       {super.key,
//       required this.focusNode,
//       required this.anotherUserName,
//       this.replayMessage,
//       this.onCancelReplay});

//   @override
//   State<SendMessageWidget> createState() => _SendMessageWidgetState();
// }

// class _SendMessageWidgetState extends State<SendMessageWidget> {
//   final _utils = EmojiPickerUtils();
//   late final EmojiTextEditingController _controller;
//   late final ScrollController _scrollController;
//   final TextEditingController? _messageTextController = TextEditingController();
//   late final TextStyle _textStyle;
//   final bool isApple = [TargetPlatform.iOS, TargetPlatform.macOS]
//       .contains(foundation.defaultTargetPlatform);
//   bool _emojiShowing = false;
//   late ChatRoomCubit chatRoomCubit;
//   static const inputTopRadius = Radius.circular(50);
//   static const inputBottomRadius = Radius.circular(50);

//   @override
//   void initState() {
//     final fontSize = 24 * (isApple ? 1.2 : 1.0);
//     // Define Custom Emoji Font & Text Style
//     _textStyle = DefaultEmojiTextStyle.copyWith(
//       fontSize: fontSize,
//     );

//     _controller = EmojiTextEditingController(emojiTextStyle: _textStyle);
//     _scrollController = ScrollController();

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final chatCubit = context.read<ChatRoomCubit>();
//     final isReplaying = widget.replayMessage != null;

//     return Container(
//       padding: const EdgeInsets.all(8.0),
//       // height: isReplaying ? 170 : 90,
//       child: Row(
//         children: [
//           Expanded(
//               child: Column(
//             children: [
//               if (isReplaying) buildReplay(),
//               Container(
//                 // height: 50,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.only(
//                     topRight: isReplaying ? Radius.zero : inputTopRadius,
//                     topLeft: isReplaying ? Radius.zero : inputTopRadius,
//                     bottomLeft: inputBottomRadius,
//                     bottomRight: inputBottomRadius,
//                   ),
//                 ),
//                 child: TextField(
//                   maxLines: 2,
//                   controller: _messageTextController,
//                   scrollController: _scrollController,
//                   focusNode: widget.focusNode,
//                   onChanged: (value) async {
//                     setState(() {
//                       _messageTextController.text = value;
//                     });
//                     await Future.delayed(const Duration(milliseconds: 500));
//                     // emit event typing
//                     chatCubit.typingMessage();
//                   },
//                   textAlignVertical: TextAlignVertical.bottom,
//                   decoration: InputDecoration(
//                     hintText: 'Message',
//                     prefixIcon: IconButton(
//                       onPressed: () {
//                         setState(() {
//                           _emojiShowing = !_emojiShowing;
//                           if (!_emojiShowing) {
//                             WidgetsBinding.instance.addPostFrameCallback((_) {
//                               widget.focusNode.requestFocus();
//                             });
//                           } else {
//                             widget.focusNode.unfocus();
//                           }
//                         });
//                       },
//                       icon: Icon(
//                         _emojiShowing
//                             ? Icons.keyboard
//                             : Icons.emoji_emotions_outlined,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     fillColor: Colors.white,
//                     focusColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide.none,
//                       // const BorderSide(color: AppColors.LIGHT_GRAY_COLOR,
//                       // ),
//                       borderRadius: BorderRadius.only(
//                         topRight: isReplaying ? Radius.zero : inputTopRadius,
//                         topLeft: isReplaying ? Radius.zero : inputTopRadius,
//                         bottomLeft: inputBottomRadius,
//                         bottomRight: inputBottomRadius,
//                       ),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(
//                         color: AppColors.LIGHT_GRAY_COLOR,
//                       ),
//                       borderRadius: BorderRadius.only(
//                         topRight: isReplaying ? Radius.zero : inputTopRadius,
//                         topLeft: isReplaying ? Radius.zero : inputTopRadius,
//                         bottomLeft: inputBottomRadius,
//                         bottomRight: inputBottomRadius,
//                       ),
//                     ),
//                     suffixIcon: _messageTextController!.text.trim().length != 0
//                         ? const SizedBox()
//                         : SizedBox(
//                             width: kToolbarHeight * 1.5,
//                             child: Row(
//                               children: [
//                                 IconAppButton(
//                                     icon: Icons.attach_file,
//                                     onPressed: () {
//                                       bottomSheet(
//                                           context: context,
//                                           widget: AttachmentTypes());
//                                     },
//                                     color: Colors.grey),
//                                 const Sizer(),
//                                 const Icon(Icons.camera_alt_rounded,
//                                     color: Colors.grey),
//                               ],
//                             ),
//                           ),
//                   ),
//                 ),
//               ),
//             ],
//           )),
//           const Sizer(),
//           _messageTextController.text.trim().length > 0
//               ? AppButton(
//                   backColor: Colors.green,
//                   label: '',
//                   iconSize: 25,
//                   radius: 50,
//                   padding: 8,
//                   icon: Icons.send_sharp,
//                   onPressed: () {
//                     chatCubit.sendMessage(
//                       message: _messageTextController.text.trim(),
//                       replyMessageId: widget.replayMessage?.sId,
//                     );
//                     setState(() {
//                       _messageTextController.text = '';
//                     });

//                     if (widget.onCancelReplay != null) {
//                       widget.onCancelReplay!();
//                     }
//                   },
//                 )
//               : Padding(
//                   padding: const EdgeInsets.only(top: 10),
//                   child: SocialMediaRecorder(
//                     recordIconBackGroundColor: AppColors.PRIMARY_COLOR,
//                     startRecording: () {},
//                     stopRecording: (_time) {},
//                     sendRequestFunction: (soundFile, _time) {},
//                     encode: AudioEncoderType.AAC,
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }

//   Widget buildReplay() =>
//   Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//             color: Colors.grey.withOpacity(.2),
//             borderRadius: BorderRadius.only(
//                 topLeft: inputTopRadius, topRight: inputTopRadius)),
//         child: ReplayMessageWidget(
//           messageEntity: widget.replayMessage!,
//           onCancelReplay: widget.onCancelReplay,
//           anotherUserName: widget.anotherUserName,
//         ),
//       );
// }

// class WhatsAppCategoryView extends CategoryView {
//   const WhatsAppCategoryView(
//     super.config,
//     super.state,
//     super.tabController,
//     super.pageController, {
//     super.key,
//   });

//   @override
//   WhatsAppCategoryViewState createState() => WhatsAppCategoryViewState();
// }

// class WhatsAppCategoryViewState extends State<WhatsAppCategoryView>
//     with SkinToneOverlayStateMixin {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: widget.config.categoryViewConfig.backgroundColor,
//       child: Row(
//         children: [
//           Expanded(
//             child: WhatsAppTabBar(
//               widget.config,
//               widget.tabController,
//               widget.pageController,
//               widget.state.categoryEmoji,
//               closeSkinToneOverlay,
//             ),
//           ),
//           _buildBackspaceButton(),
//         ],
//       ),
//     );
//   }

//   Widget _buildBackspaceButton() {
//     if (widget.config.categoryViewConfig.showBackspaceButton) {
//       return BackspaceButton(
//         widget.config,
//         widget.state.onBackspacePressed,
//         widget.state.onBackspaceLongPressed,
//         widget.config.categoryViewConfig.backspaceColor,
//       );
//     }
//     return const SizedBox.shrink();
//   }
// }

// class WhatsAppTabBar extends StatelessWidget {
//   const WhatsAppTabBar(
//     this.config,
//     this.tabController,
//     this.pageController,
//     this.categoryEmojis,
//     this.closeSkinToneOverlay, {
//     super.key,
//   });

//   final Config config;

//   final TabController tabController;

//   final PageController pageController;

//   final List<CategoryEmoji> categoryEmojis;

//   final VoidCallback closeSkinToneOverlay;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: config.categoryViewConfig.tabBarHeight,
//       child: TabBar(
//         labelColor: config.categoryViewConfig.iconColorSelected,
//         indicatorColor: config.categoryViewConfig.indicatorColor,
//         unselectedLabelColor: config.categoryViewConfig.iconColor,
//         dividerColor: config.categoryViewConfig.dividerColor,
//         controller: tabController,
//         labelPadding: const EdgeInsets.only(top: 1.0),
//         indicatorSize: TabBarIndicatorSize.label,
//         indicator: const BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.black12,
//         ),
//         onTap: (index) {
//           closeSkinToneOverlay();
//           pageController.jumpToPage(index);
//         },
//         tabs: categoryEmojis
//             .asMap()
//             .entries
//             .map<Widget>(
//                 (item) => _buildCategory(item.key, item.value.category))
//             .toList(),
//       ),
//     );
//   }

//   Widget _buildCategory(int index, Category category) {
//     return Tab(
//       child: Padding(
//         padding: const EdgeInsets.all(6.0),
//         child: Icon(
//           getIconForCategory(
//             config.categoryViewConfig.categoryIcons,
//             category,
//           ),
//           size: 20,
//         ),
//       ),
//     );
//   }
// }

// /// Custom Whatsapp Search view implementation
// class WhatsAppSearchView extends SearchView {
//   const WhatsAppSearchView(super.config, super.state, super.showEmojiView,
//       {super.key});

//   @override
//   WhatsAppSearchViewState createState() => WhatsAppSearchViewState();
// }

// class WhatsAppSearchViewState extends SearchViewState {
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(builder: (context, constraints) {
//       final emojiSize =
//           widget.config.emojiViewConfig.getEmojiSize(constraints.maxWidth);
//       final emojiBoxSize =
//           widget.config.emojiViewConfig.getEmojiBoxSize(constraints.maxWidth);
//       return Container(
//         color: widget.config.searchViewConfig.backgroundColor,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             SizedBox(
//               height: emojiBoxSize + 8.0,
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(vertical: 4.0),
//                 scrollDirection: Axis.horizontal,
//                 itemCount: results.length,
//                 itemBuilder: (context, index) {
//                   return buildEmoji(
//                     results[index],
//                     emojiSize,
//                     emojiBoxSize,
//                   );
//                 },
//               ),
//             ),
//             Row(
//               children: [
//                 IconButton(
//                   onPressed: widget.showEmojiView,
//                   color: widget.config.searchViewConfig.buttonColor,
//                   icon: Icon(
//                     Icons.arrow_back,
//                     color: widget.config.searchViewConfig.buttonIconColor,
//                     size: 20.0,
//                   ),
//                 ),
//                 Expanded(
//                   child: TextField(
//                     onChanged: onTextInputChanged,
//                     focusNode: focusNode,
//                     decoration: InputDecoration(
//                       border: InputBorder.none,
//                       hintText: widget.config.searchViewConfig.hintText,
//                       hintStyle: const TextStyle(
//                         color: Colors.grey,
//                         fontWeight: FontWeight.normal,
//                       ),
//                       contentPadding: EdgeInsets.zero,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       );
//     });
//   }
// }

// ========================================================================================================================================================================================
// ========================================================================================================================================================================================
// ========================================================================================================================================================================================
// ========================================================================================================================================================================================

// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/chat_room_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/chat_room_widgets/Attachment_types.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/chat_room_widgets/emoji_keyboard.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/presentation/chat_cubit/chats_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';

import 'replay_message_widget.dart';

class SendMessageWidget extends StatefulWidget {
  const SendMessageWidget({super.key});

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  late final TextEditingController _messageTextController;
  late final FocusNode _messageFocusNode;
  late bool _showMicButton;
  late bool _showEmojiKeyboard;
  final Radius radius = const Radius.circular(32);
  bool _isRecording = false;

  @override
  void initState() {
    _messageTextController =
        context.read<ChatRoomCubit>().messageTextController;
    _messageFocusNode = FocusNode();
    _showMicButton = true;
    _showEmojiKeyboard = false;
    _messageTextController.addListener(() {
      _toggleMicButton(_messageTextController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _messageFocusNode.dispose();
    _messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _isRecording
                  ? const SizedBox.shrink()
                  : Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          _replayedMessageCard(),
                          _textField(),
                        ],
                      ),
                    ),
              const Sizer(),
              Expanded(
                flex: 1,
                child: _showMicButton
                    ? SizedBox(height: 50, child: _micButton(context))
                    : _sendButton(),
              ),
            ],
          ),
        ),
        _emojiKeyboard(),
      ],
    );
  }

  Widget _micButton(BuildContext context) {
    final AudioPlayer audioPlayer = AudioPlayer();
    return SocialMediaRecorder(
      startRecording: () async {
        await context.read<ChatRoomCubit>().startRecording();
        _isRecording = true;
        setState(() {});
      },

      stopRecording: (time) async {
        await context.read<ChatRoomCubit>().stopRecording();
        _isRecording = false;

        setState(() {});
      },
      encode: AudioEncoderType.AAC, // Ensure it's recorded in AAC

      sendRequestFunction: (File soundFile, String time) async {
        await context.read<ChatRoomCubit>().stopRecording();
        _isRecording = false;
        setState(() {});
        log("sound file path is : ${soundFile.path}");
        // Rename the file to .mp3
        String newPath = soundFile.path.replaceAll('.m4a', '.mp3');
        log("new path is : $newPath");
        File mp3File = await soundFile.rename(newPath);

        log(mp3File.path); // Log the new file path

        // Play the audio file locally
        await audioPlayer.play(
          DeviceFileSource(mp3File.path),
          volume: 0,
        );

        // Add the renamed MP3 file to the media list
        // ignore: use_build_context_synchronously
        context.read<ChatRoomCubit>().media.add(mp3File);
        // ignore: use_build_context_synchronously
        await context.read<ChatRoomCubit>().sendMessage();
      },
      initRecordPackageWidth: 50,
      fullRecordPackageHeight: 50,
      recordIcon:
          Icon(Icons.mic, color: AppColors.BACKGROUND_COLOR, size: 50.h),
      recordIconBackGroundColor: AppColors.PRIMARY_COLOR,
      recordIconWhenLockBackGroundColor: AppColors.PRIMARY_COLOR,
      counterBackGroundColor: AppColors.PRIMARY_COLOR,
      cancelTextBackGroundColor: AppColors.PRIMARY_COLOR,
      backGroundColor: AppColors.PRIMARY_COLOR,
      cancelTextStyle: const TextStyle(color: Colors.white),
      counterTextStyle: const TextStyle(color: Colors.white),
      radius: BorderRadius.circular(50),
    );
  }

  Widget _sendButton() {
    return LayoutBuilder(builder: (context, constraints) {
      return InkWell(
        onTap: () async {
          await context.read<ChatRoomCubit>().sendMessage();
        },
        child: const CircleAvatar(
          backgroundColor: AppColors.PRIMARY_COLOR,
          radius: 25,
          child: Center(
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      );
    });
  }

  Widget _textField() {
    _messageTextController.addListener(() async {
      // Check if the user is typing
      if (_messageTextController.text.length == 1) {
        await context.read<ChatRoomCubit>().startTyping();
      } else if (_messageTextController.text.isEmpty) {
        // User stopped typing or cleared the text
        await context.read<ChatRoomCubit>().stopTyping();
      }
    });

    return BlocBuilder<ChatRoomCubit, ChatRoomState>(
      builder: (context, state) {
        Radius topRadius = state.replayedMessage == null ? radius : Radius.zero;

        return WillPopScope(
          onWillPop: () async {
            if (_showEmojiKeyboard) {
              _closeEmojiKeyboard();
              _openTextKeyboard();
              return Future.value(false);
            }
            return Future.value(true);
          },
          child: Container(
            decoration: BoxDecoration(
              boxShadow: state.replayedMessage == null
                  ? [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 1,
                        offset: const Offset(0, 3),
                      ),
                    ],
              borderRadius: BorderRadius.vertical(
                top: topRadius,
                bottom: radius,
              ),
            ),
            child: Theme(
              data: ThemeData(
                inputDecorationTheme: InputDecorationTheme(
                  fillColor: Colors.white,
                  filled: true,
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.vertical(
                      top: topRadius,
                      bottom: radius,
                    ),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              child: TextFormField(
                controller: _messageTextController,
                focusNode: _messageFocusNode,
                onTap: () {
                  _closeEmojiKeyboard();
                  _openTextKeyboard();
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: LocaleKeys.message.tr(),
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.vertical(
                      top: topRadius,
                      bottom: radius,
                    ),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon:
                      _showEmojiKeyboard ? _keyboardButton() : _emojiButton(),
                  suffixIcon: _attachmentButton(),
                ),
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                minLines: 1,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _replayedMessageCard() {
    return BlocBuilder<ChatRoomCubit, ChatRoomState>(
      builder: (context, state) {
        if (state.replayedMessage != null) {
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: AppColors.PRIMARY_COLOR,
                  blurRadius: 7,
                  spreadRadius: -5,
                )
              ],
              borderRadius: BorderRadius.vertical(top: radius),
              color: AppColors.BACKGROUND_COLOR,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: radius),
                color: AppColors.GRAY_LIGHT_COLOR3,
              ),
              child: ReplayMessageWidget(
                messageEntity: state.replayedMessage!,
                onCancelReplay: () =>
                    context.read<ChatRoomCubit>().cancelReplay(),
                anotherUserName: state.replayedMessage!.byMe == true
                    ? 'You'
                    : context.read<ChatsCubit>().selectedChat.name,
                // state.chatData?.chat?.contact?.name ??
                //     LocaleKeys.anonymous.tr(),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Widget _keyboardButton() {
    return IconButton(
      icon: const Icon(
        Icons.keyboard,
        color: Colors.grey,
      ),
      onPressed: () {
        _closeEmojiKeyboard();
        _openTextKeyboard();
      },
    );
  }

  Widget _emojiButton() {
    return IconButton(
      icon: const Icon(
        Icons.emoji_emotions_outlined,
        color: Colors.grey,
      ),
      onPressed: () {
        _closeTextKeyboard();
        _openEmojiKeyboard();
      },
    );
  }

  Widget _emojiKeyboard() {
    return Offstage(
      offstage: !_showEmojiKeyboard,
      child: EmojiKeyboard(textController: _messageTextController),
    );
  }

  Widget _attachmentButton() {
    return IconButton(
      icon: const Icon(
        Icons.attach_file_outlined,
        color: Colors.grey,
      ),
      onPressed: () {
        bottomSheet(
            context: context,
            widget: AttachmentTypes(
              chatRoomCubit: context.read<ChatRoomCubit>(),
            ));
      },
    );
  }

  _toggleMicButton(String value) {
    value = value.trim();
    if (value.isNotEmpty && _showMicButton) {
      setState(() {
        _showMicButton = false;
      });
    } else if ((value.isEmpty) && !_showMicButton) {
      setState(() {
        _showMicButton = true;
      });
    }
  }

  _closeEmojiKeyboard() {
    setState(() {
      _showEmojiKeyboard = false;
    });
  }

  _openEmojiKeyboard() {
    setState(() {
      _showEmojiKeyboard = true;
    });
  }

  _closeTextKeyboard() {
    _messageFocusNode.unfocus();
  }

  _openTextKeyboard() {
    _messageFocusNode.requestFocus();
  }
}
