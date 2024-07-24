import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fourtyninehub/common/widgets/dialogs/show_bottom_sheet.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/iconAppButton.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/chat_cubit/chat_room_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'Attachment_types.dart';

class SendMessageWidget extends StatefulWidget {
  const SendMessageWidget({super.key});

  @override
  State<SendMessageWidget> createState() => _SendMessageWidgetState();
}

class _SendMessageWidgetState extends State<SendMessageWidget> {
  final _utils = EmojiPickerUtils();
  late final EmojiTextEditingController _controller;
  late final ScrollController _scrollController;
  late final TextEditingController _messageTextController;
  late final FocusNode _focusNode;
  late final TextStyle _textStyle;
  final bool isApple = [TargetPlatform.iOS, TargetPlatform.macOS]
      .contains(foundation.defaultTargetPlatform);
  bool _emojiShowing = false;
  late ChatRoomCubit chatRoomCubit;

  @override
  void initState() {
    final fontSize = 24 * (isApple ? 1.2 : 1.0);
    // Define Custom Emoji Font & Text Style
    _textStyle = DefaultEmojiTextStyle.copyWith(
      fontSize: fontSize,
    );

    _controller = EmojiTextEditingController(emojiTextStyle: _textStyle);
    _scrollController = ScrollController();
    _focusNode = FocusNode();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatCubit = context.read<ChatRoomCubit>();

    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          height: kToolbarHeight * 1.3,
          child: Row(
            children: [
              Expanded(
                  child: Container(
                height: kToolbarHeight,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: _messageTextController,
                  scrollController: _scrollController,
                  focusNode: _focusNode,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    hintText: 'Message',
                    prefixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _emojiShowing = !_emojiShowing;
                          if (!_emojiShowing) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _focusNode.requestFocus();
                            });
                          } else {
                            _focusNode.unfocus();
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
                        borderSide:
                            const BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: AppColors.LIGHT_GRAY_COLOR),
                        borderRadius: BorderRadius.circular(20)),
                    suffixIcon:
                        _messageTextController.text.trim().isEmpty
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
                                              widget: AttachmentTypes());
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
              )),
              const Sizer(),
              SocialMediaRecorder(
                recordIconBackGroundColor: AppColors.PRIMARY_COLOR,
                startRecording: () {},
                stopRecording: (_time) {},
                sendRequestFunction: (soundFile, _time) {},
                encode: AudioEncoderType.AAC,
              ),
            ],
          ),
        ),
        if (_emojiShowing)
          EmojiPicker(
            textEditingController: _controller,
            scrollController: _scrollController,
            config: Config(
              height: 256,
              checkPlatformCompatibility: true,
              emojiTextStyle: _textStyle,
              emojiViewConfig: const EmojiViewConfig(
                backgroundColor: Colors.white,
              ),
              swapCategoryAndBottomBar: true,
              skinToneConfig: const SkinToneConfig(),
              categoryViewConfig: CategoryViewConfig(
                backgroundColor: Colors.white,
                dividerColor: Colors.white,
                indicatorColor: Colors.grey,
                iconColorSelected: Colors.black,
                iconColor: Colors.grey,
                customCategoryView: (
                  config,
                  state,
                  tabController,
                  pageController,
                ) {
                  return WhatsAppCategoryView(
                    config,
                    state,
                    tabController,
                    pageController,
                  );
                },
                categoryIcons: const CategoryIcons(
                  recentIcon: Icons.access_time_outlined,
                  smileyIcon: Icons.emoji_emotions_outlined,
                  animalIcon: Icons.cruelty_free_outlined,
                  foodIcon: Icons.coffee_outlined,
                  activityIcon: Icons.sports_soccer_outlined,
                  travelIcon: Icons.directions_car_filled_outlined,
                  objectIcon: Icons.lightbulb_outline,
                  symbolIcon: Icons.emoji_symbols_outlined,
                  flagIcon: Icons.flag_outlined,
                ),
              ),
              bottomActionBarConfig: const BottomActionBarConfig(
                backgroundColor: Colors.white,
                buttonColor: Colors.white,
                buttonIconColor: Colors.grey,
              ),
              searchViewConfig: SearchViewConfig(
                backgroundColor: Colors.white,
                customSearchView: (
                  config,
                  state,
                  showEmojiView,
                ) {
                  return WhatsAppSearchView(
                    config,
                    state,
                    showEmojiView,
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
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
