import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/chat_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/widgets/room/replay_message_widget.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'Attachment_types.dart';

class SendMessageWidget extends StatefulWidget {
  MessageEntity? replayMessage;
  final VoidCallback? onCancelReplay;
  FocusNode focusNode;
  String anotherUserName;

  SendMessageWidget(
      {super.key,
      required this.focusNode,
      required this.anotherUserName,
      this.replayMessage,
      this.onCancelReplay});

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  final _utils = EmojiPickerUtils();
  late final EmojiTextEditingController _controller;
  late final ScrollController _scrollController;
  final TextEditingController _messageTextController = TextEditingController();
  late final TextStyle _textStyle;
  final bool isApple = [TargetPlatform.iOS, TargetPlatform.macOS]
      .contains(foundation.defaultTargetPlatform);
  bool _emojiShowing = false;
  late ChatRoomCubit chatRoomCubit;
  static const inputTopRadius = Radius.circular(12);
  static const inputBottomRadius = Radius.circular(12);

  @override
  void initState() {
    final fontSize = 24 * (isApple ? 1.2 : 1.0);
    // Define Custom Emoji Font & Text Style
    _textStyle = DefaultEmojiTextStyle.copyWith(
      fontSize: fontSize,
    );

    _controller = EmojiTextEditingController(emojiTextStyle: _textStyle);
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatCubit = context.read<ChatRoomCubit>();
    final isReplaying = widget.replayMessage != null;

    return Container(
      padding: const EdgeInsets.all(8.0),
      height: isReplaying ? 170 : 90,
      child: Row(
        children: [
          Expanded(
              child: Column(
            children: [
              if (isReplaying) buildReplay(),
              Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: isReplaying ? Radius.zero : inputTopRadius,
                    topLeft: isReplaying ? Radius.zero : inputTopRadius,
                    bottomLeft: inputBottomRadius,
                    bottomRight: inputBottomRadius,
                  ),
                ),
                child: TextField(
                  maxLines: 2,
                  controller: _messageTextController,
                  scrollController: _scrollController,
                  focusNode: widget.focusNode,
                  onChanged: (value) async {
                    setState(() {
                      _messageTextController.text = value;
                    });
                    await Future.delayed(const Duration(milliseconds: 500));
                    // emit event typing
                    chatCubit.typingMessage();
                  },
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    hintText: 'Message',
                    prefixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _emojiShowing = !_emojiShowing;
                          if (!_emojiShowing) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              widget.focusNode.requestFocus();
                            });
                          } else {
                            widget.focusNode.unfocus();
                          }
                        });
                      },
                      icon: Icon(
                        _emojiShowing
                            ? Icons.keyboard
                            : Icons.emoji_emotions_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    fillColor: Colors.white,
                    focusColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      // const BorderSide(color: AppColors.LIGHT_GRAY_COLOR,
                      // ),
                      borderRadius: BorderRadius.only(
                        topRight: isReplaying ? Radius.zero : inputTopRadius,
                        topLeft: isReplaying ? Radius.zero : inputTopRadius,
                        bottomLeft: inputBottomRadius,
                        bottomRight: inputBottomRadius,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.LIGHT_GRAY_COLOR,
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: isReplaying ? Radius.zero : inputTopRadius,
                        topLeft: isReplaying ? Radius.zero : inputTopRadius,
                        bottomLeft: inputBottomRadius,
                        bottomRight: inputBottomRadius,
                      ),
                    ),
                    suffixIcon: _messageTextController.text.trim().isNotEmpty
                        ? const SizedBox()
                        : SizedBox(
                            width: kToolbarHeight * 1.5,
                            child: Row(
                              children: [
                                IconAppButton(
                                    icon: Icons.attach_file,
                                    onPressed: () {
                                      bottomSheet(
                                          context: context,
                                          widget: const AttachmentTypes());
                                    },
                                    color: Colors.grey),
                                const Sizer(),
                                const Icon(Icons.camera_alt_rounded,
                                    color: Colors.grey),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
            ],
          )),
          const Sizer(),
          _messageTextController.text.trim().isNotEmpty
              ? AppButton(
                  backColor: Colors.green,
                  label: '',
                  iconSize: 25,
                  radius: 50,
                  padding: 8,
                  icon: Icons.send_sharp,
                  onPressed: () {
                    chatCubit.sendMessage(
                      message: _messageTextController.text.trim(),
                      replyMessageId: widget.replayMessage?.sId,
                    );
                    setState(() {
                      _messageTextController.text = '';
                    });

                    if (widget.onCancelReplay != null) {
                      widget.onCancelReplay!();
                    }
                  },
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SocialMediaRecorder(
                    recordIconBackGroundColor: AppColors.PRIMARY_COLOR,
                    startRecording: () {},
                    stopRecording: (time) {},
                    sendRequestFunction: (soundFile, time) {},
                    encode: AudioEncoderType.AAC,
                  ),
                ),
        ],
      ),
    );
  }

  Widget buildReplay() => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(.2),
            borderRadius: const BorderRadius.only(
                topLeft: inputTopRadius, topRight: inputTopRadius)),
        child: ReplayMessageWidget(
          messageEntity: widget.replayMessage!,
          onCancelReplay: widget.onCancelReplay,
          anotherUserName: widget.anotherUserName,
        ),
      );
}

class WhatsAppCategoryView extends CategoryView {
  const WhatsAppCategoryView(
    super.config,
    super.state,
    super.tabController,
    super.pageController, {
    super.key,
  });

  @override
  WhatsAppCategoryViewState createState() => WhatsAppCategoryViewState();
}

class WhatsAppCategoryViewState extends State<WhatsAppCategoryView>
    with SkinToneOverlayStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.config.categoryViewConfig.backgroundColor,
      child: Row(
        children: [
          Expanded(
            child: WhatsAppTabBar(
              widget.config,
              widget.tabController,
              widget.pageController,
              widget.state.categoryEmoji,
              closeSkinToneOverlay,
            ),
          ),
          _buildBackspaceButton(),
        ],
      ),
    );
  }

  Widget _buildBackspaceButton() {
    if (widget.config.categoryViewConfig.showBackspaceButton) {
      return BackspaceButton(
        widget.config,
        widget.state.onBackspacePressed,
        widget.state.onBackspaceLongPressed,
        widget.config.categoryViewConfig.backspaceColor,
      );
    }
    return const SizedBox.shrink();
  }
}

class WhatsAppTabBar extends StatelessWidget {
  const WhatsAppTabBar(
    this.config,
    this.tabController,
    this.pageController,
    this.categoryEmojis,
    this.closeSkinToneOverlay, {
    super.key,
  });

  final Config config;

  final TabController tabController;

  final PageController pageController;

  final List<CategoryEmoji> categoryEmojis;

  final VoidCallback closeSkinToneOverlay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: config.categoryViewConfig.tabBarHeight,
      child: TabBar(
        labelColor: config.categoryViewConfig.iconColorSelected,
        indicatorColor: config.categoryViewConfig.indicatorColor,
        unselectedLabelColor: config.categoryViewConfig.iconColor,
        dividerColor: config.categoryViewConfig.dividerColor,
        controller: tabController,
        labelPadding: const EdgeInsets.only(top: 1.0),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black12,
        ),
        onTap: (index) {
          closeSkinToneOverlay();
          pageController.jumpToPage(index);
        },
        tabs: categoryEmojis
            .asMap()
            .entries
            .map<Widget>(
                (item) => _buildCategory(item.key, item.value.category))
            .toList(),
      ),
    );
  }

  Widget _buildCategory(int index, Category category) {
    return Tab(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Icon(
          getIconForCategory(
            config.categoryViewConfig.categoryIcons,
            category,
          ),
          size: 20,
        ),
      ),
    );
  }
}

/// Custom Whatsapp Search view implementation
class WhatsAppSearchView extends SearchView {
  const WhatsAppSearchView(super.config, super.state, super.showEmojiView,
      {super.key});

  @override
  WhatsAppSearchViewState createState() => WhatsAppSearchViewState();
}

class WhatsAppSearchViewState extends SearchViewState {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final emojiSize =
          widget.config.emojiViewConfig.getEmojiSize(constraints.maxWidth);
      final emojiBoxSize =
          widget.config.emojiViewConfig.getEmojiBoxSize(constraints.maxWidth);
      return Container(
        color: widget.config.searchViewConfig.backgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: emojiBoxSize + 8.0,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                scrollDirection: Axis.horizontal,
                itemCount: results.length,
                itemBuilder: (context, index) {
                  return buildEmoji(
                    results[index],
                    emojiSize,
                    emojiBoxSize,
                  );
                },
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed: widget.showEmojiView,
                  color: widget.config.searchViewConfig.buttonColor,
                  icon: Icon(
                    Icons.arrow_back,
                    color: widget.config.searchViewConfig.buttonIconColor,
                    size: 20.0,
                  ),
                ),
                Expanded(
                  child: TextField(
                    onChanged: onTextInputChanged,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.config.searchViewConfig.hintText,
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                      ),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
