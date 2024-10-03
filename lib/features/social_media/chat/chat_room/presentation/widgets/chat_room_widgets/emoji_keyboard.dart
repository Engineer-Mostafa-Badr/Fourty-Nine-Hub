import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmojiKeyboard extends StatelessWidget {
  final TextEditingController? textController;
  final ScrollController? scrollController;
  final void Function(Category?, Emoji)? onEmojiSelected;
  const EmojiKeyboard(
      {super.key,
      this.textController,
      this.scrollController,
      this.onEmojiSelected});

  @override
  Widget build(BuildContext context) {
    return EmojiPicker(
      textEditingController: textController,
      scrollController: scrollController,
      onEmojiSelected: onEmojiSelected,
      config: Config(
        height: 500.h,
        checkPlatformCompatibility: true,
        emojiViewConfig: const EmojiViewConfig(
          backgroundColor: Colors.white,
        ),
        swapCategoryAndBottomBar: true,
        skinToneConfig: const SkinToneConfig(),
        categoryViewConfig: CategoryViewConfig(
          backgroundColor: Colors.white,
          dividerColor: Colors.white,
          iconColorSelected: Colors.black,
          customCategoryView: (
            config,
            state,
            tabController,
            pageController,
          ) {
            return _WhatsAppCategoryView(
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
          backgroundColor: AppColors.PRIMARY_COLOR,
          buttonColor: Colors.transparent,
        ),
        searchViewConfig: SearchViewConfig(
          backgroundColor: Colors.white,
          customSearchView: (
            config,
            state,
            showEmojiView,
          ) {
            return _WhatsAppSearchView(
              config,
              state,
              showEmojiView,
            );
          },
        ),
      ),
    );
  }
}

/// Customized Whatsapp category view
class _WhatsAppCategoryView extends CategoryView {
  const _WhatsAppCategoryView(
      super.config, super.state, super.tabController, super.pageController);

  @override
  WhatsAppCategoryViewState createState() => WhatsAppCategoryViewState();
}

class WhatsAppCategoryViewState extends State<_WhatsAppCategoryView>
    with SkinToneOverlayStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.config.categoryViewConfig.backgroundColor,
      child: Row(
        children: [
          Expanded(
            child: _WhatsAppTabBar(
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

class _WhatsAppTabBar extends StatelessWidget {
  const _WhatsAppTabBar(this.config, this.tabController, this.pageController,
      this.categoryEmojis, this.closeSkinToneOverlay);

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
class _WhatsAppSearchView extends SearchView {
  const _WhatsAppSearchView(super.config, super.state, super.showEmojiView);

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
                padding: EdgeInsets.symmetric(vertical: 4.h),
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
                  color: widget.config.searchViewConfig.buttonIconColor,
                  icon: const Icon(
                    Icons.arrow_back,
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
                        // color: secondaryColor,
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
