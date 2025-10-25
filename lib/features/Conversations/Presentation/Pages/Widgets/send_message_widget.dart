import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/Conversations/Presentation/Controllers/cubits/conversations_cubit.dart';
import '../../../../../../../common/widgets/dialogs/show_bottom_sheet.dart';
import '../../../../../../../common/widgets/dynamic/sizer.dart';
import '../../../../../../../core/extensions/context_extension.dart';
import '../../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../../res/style/app_colors.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';

import '../../../../../../../helpers/manage_vibration.dart';
import '../../../../../service_locator/service_locator.dart';
import 'attatchment_types.dart';
import 'emojiKeyboard.dart';

class SendMessageWidget extends StatefulWidget {
  const SendMessageWidget({super.key, required this.conversationId});

  final String conversationId;

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  late final TextEditingController _messageTextController;
  late final FocusNode _messageFocusNode;
  final ScrollController _scrollController = ScrollController();
  late bool _showMicButton;
  late bool _showEmojiKeyboard;
  final Radius radius = const Radius.circular(32);
  bool _isRecording = false;

  @override
  void initState() {
    // _messageTextController =
    //     context.read<ChatRoomCubit>().messageTextController;
    _messageTextController = TextEditingController();
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
    print('_messageTextController:: ${_messageTextController.text}');
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
              if (!_isRecording)
                Expanded(
                  flex: 6,
                  child: Column(
                    children: [
                      // _replayedMessageCard(),
                      _textField(),
                    ],
                  ),
                ),
              const Sizer(),
              _showMicButton
                  ? SizedBox(height: 50, child: _micButton(context))
                  : _sendButton(),
            ],
          ),
        ),
        _emojiKeyboard(),
      ],
    );
  }

  Widget _micButton(BuildContext context) {
    final AudioPlayer audioPlayer = AudioPlayer();
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SocialMediaRecorder(
          startRecording: () async {
            serviceLocator<ConversationsCubit>().startRecording(widget.conversationId);
            _isRecording = true;
            setState(() {});
          },
          stopRecording: (time) async {
            serviceLocator<ConversationsCubit>().stopRecording(widget.conversationId);
            _isRecording = false;
            setState(() {});
          },
          encode: AudioEncoderType.AAC,
          // Ensure it's recorded in AAC
          sendRequestFunction: (File soundFile, String time) async {
            serviceLocator<ConversationsCubit>().stopRecording(widget.conversationId);
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
            // context.read<ChatRoomCubit>().media.add(mp3File);
            // // ignore: use_build_context_synchronously
            // await context.read<ChatRoomCubit>().sendMessage();
          },
          initRecordPackageWidth: 50,
          fullRecordPackageHeight: 50,
          recordIcon:
          Icon(Icons.mic, color: AppColors.BACKGROUND_COLOR, size: 50.h),
          recordIconBackGroundColor: AppColors.PRIMARY_COLOR,
          recordIconWhenLockBackGroundColor: AppColors.PRIMARY_COLOR,
          counterBackGroundColor: context.isDarkMode? Colors.white :AppColors.PRIMARY_COLOR,
          cancelTextBackGroundColor:context.isDarkMode? Colors.white : AppColors.PRIMARY_COLOR,
          backGroundColor: AppColors.PRIMARY_COLOR,
          cancelTextStyle:  TextStyle(color:context.isDarkMode? Colors.black : Colors.white),
          counterTextStyle:  TextStyle(color: context.isDarkMode? Colors.black :Colors.white),
          radius: BorderRadius.circular(50),
        ),
        // _isRecording
        //     ? Positioned(
        //         // top: 10,
        //         right: 40,
        //         left: 0,
        //         top: 0,
        //         bottom: 0,
        //         child: IconButton(
        //           icon: Icon(
        //               context.read<ChatRoomCubit>().isOneTimeView
        //                   ? Icons.looks_one
        //                   : Icons.looks_one_outlined,
        //               color: Colors.grey),
        //           onPressed: () async {
        //             setState(() {
        //               context.read<ChatRoomCubit>().isOneTimeView =
        //                   !context.read<ChatRoomCubit>().isOneTimeView;
        //             });
        //           },
        //         ),
        //       )
        //     : const SizedBox.shrink(),
      ],
    );
  }

  Widget _sendButton() {
    return LayoutBuilder(builder: (context, constraints) {
      return InkWell(
        onTap: () async {
          ManageVibration.vibrate();
          // await context.read<ChatRoomCubit>().sendMessage();
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
        await context.read<ConversationsCubit>().startTyping(widget.conversationId);
      } else if (_messageTextController.text.isEmpty) {
        // User stopped typing or cleared the text
        await context.read<ConversationsCubit>().stopTyping(widget.conversationId);
      }
    });

     return WillPopScope(
      onWillPop: () async {
        // if (context.read<ChatRoomCubit>().chat.isSearching) {
        //   context.read<ChatRoomCubit>().stopSearching();
        // }
        if (_showEmojiKeyboard) {
          _closeEmojiKeyboard();
          _openTextKeyboard();
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
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
                  top: Radius.circular(20),
                  bottom: radius,
                ),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
                bottom: radius,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                _showEmojiKeyboard ? _keyboardButton() : _emojiButton(),
                Expanded(
                  child: Scrollbar(
                    controller: _scrollController,
                    interactive: true,
                    thickness: 4,
                    radius: const Radius.circular(50),
                    child: TextFormField(
                      controller: _messageTextController,
                      focusNode: _messageFocusNode,
                      onTap: () {
                        ManageVibration.vibrate();
                        _closeEmojiKeyboard();
                        _openTextKeyboard();
                      },
                      decoration: InputDecoration(
                        hintText: LocaleKeys.message.tr(),
                        hintStyle: const TextStyle(color: Colors.grey),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        border: InputBorder
                            .none,
                      ),
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      minLines: 1,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      child: Icon(
                        // context.read<ChatRoomCubit>().isOneTimeView
                        //     ? Icons.looks_one
                        //     :
                        Icons.looks_one_outlined,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        ManageVibration.vibrate();
                        // setState(() {
                        //   context.read<ChatRoomCubit>().isOneTimeView =
                        //   !context.read<ChatRoomCubit>().isOneTimeView;
                        // });
                      },
                    ),
                    _attachmentButton(),
                  ],
                ),
              ],
            ),
          ),
          //  Scrollbar(
          //   controller: _scrollController,
          //   interactive: true,
          //   scrollbarOrientation: ScrollbarOrientation.values[0],
          //   thickness: 4,
          //   radius: const Radius.circular(50),
          //   child: TextFormField(
          //     controller: _messageTextController,
          //     focusNode: _messageFocusNode,
          //     onTap: () {
          //       _closeEmojiKeyboard();
          //       _openTextKeyboard();
          //     },
          //     decoration: InputDecoration(
          //       fillColor: Colors.white,
          //       filled: true,
          //       hintText: LocaleKeys.message.tr(),
          //       hintStyle: const TextStyle(color: Colors.grey),
          //       contentPadding: const EdgeInsets.symmetric(
          //           vertical: 10, horizontal: 12),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.vertical(
          //           top: topRadius,
          //           bottom: radius,
          //         ),
          //         borderSide: BorderSide.none,
          //       ),
          //       prefixIcon:
          //           _showEmojiKeyboard ? _keyboardButton() : _emojiButton(),
          //       suffixIcon: Padding(
          //         padding: const EdgeInsets.only(right: 10),
          //         child: Row(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             GestureDetector(
          //               child: Icon(
          //                 context.read<ChatRoomCubit>().isOneTimeView
          //                     ? Icons.looks_one
          //                     : Icons.looks_one_outlined,
          //                 color: Colors.grey,
          //               ),
          //               onTap: () async {
          //                 setState(() {
          //                   context.read<ChatRoomCubit>().isOneTimeView =
          //                       !context
          //                           .read<ChatRoomCubit>()
          //                           .isOneTimeView;
          //                 });
          //               },
          //             ),
          //             _attachmentButton(),
          //           ],
          //         ),
          //       ),
          //     ),
          //     style: const TextStyle(color: Colors.black),
          //     keyboardType: TextInputType.multiline,
          //     maxLines: 3,
          //     minLines: 1,
          //   ),
          // ),
        ),
      ),
    );
  }

  // Widget _replayedMessageCard() {
  //   return Container(
  //     padding: const EdgeInsets.all(8),
  //     decoration: const BoxDecoration(
  //       boxShadow: [
  //         BoxShadow(
  //           color: AppColors.PRIMARY_COLOR,
  //           blurRadius: 7,
  //           spreadRadius: -5,
  //         )
  //       ],
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //       color: AppColors.BACKGROUND_COLOR,
  //     ),
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(12),
  //         color: AppColors.GRAY_LIGHT_COLOR3,
  //       ),
  //       child: ReplayMessageWidget(
  //         messageEntity: state.replayedMessage!,
  //         onCancelReplay: () =>
  //             context.read<ChatRoomCubit>().cancelReplay(),
  //         anotherUserName: state.replayedMessage!.byMe
  //             ? 'You'
  //             : context.read<ChatsCubit>().selectedChat.name,
  //         // state.chatData?.chat?.contact?.name ??
  //         //     LocaleKeys.anonymous.tr(),
  //       ),
  //     ),
  //   );
  // }

  Widget _keyboardButton() {
    return IconButton(
      icon: const Icon(
        Icons.keyboard,
        color: Colors.grey,
      ),
      onPressed: () {
        ManageVibration.vibrate();
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
        ManageVibration.vibrate();
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
        ManageVibration.vibrate();
        bottomSheet(
            context: context,
            widget: AttachmentTypes());
      },
    );
  }

  _toggleMicButton(String value) {
    value = value.trim();
    if (value.isNotEmpty && _showMicButton) {
      setState(() {
        _showMicButton = false;
        // context.read<ChatRoomCubit>().chat.messageDraft = value;
      });
    } else if ((value.isEmpty) && !_showMicButton) {
      setState(() {
        _showMicButton = true;
        // context.read<ChatRoomCubit>().chat.messageDraft = null;
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