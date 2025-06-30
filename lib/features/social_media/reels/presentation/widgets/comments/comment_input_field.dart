import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import 'package:fourtyninehub/features/social_media/social_posts/presentation/widgets/facebook_widgets/image_from_internet.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../res/assets/assets.dart';
import '../../../../../../routes/routes.dart';
import '../../../../../../service_locator/service_locator.dart';
import '../../../../tinder/data/shared/shared.dart';
import '../../controllers/preload_cubit/preload_bloc.dart';

class CommentInputField extends StatefulWidget {
  final TextEditingController commentController;
  final Reel reel;
  final ScrollController scrollController;
  final FocusNode focusNode;
  final bool isReplying;
  const CommentInputField({
    super.key,
    required this.reel,
    required this.commentController,
    required this.isReplying,
    required this.scrollController,
    required this.focusNode,
  });

  @override
  CommentInputFieldState createState() => CommentInputFieldState();
}

class CommentInputFieldState extends State<CommentInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: const EdgeInsets.all(8.0)
            .add(EdgeInsetsDirectional.only(end: 20.w, bottom: 10.h)),
        child: Row(
          children: [
            ImageFromInternet(
              width: 50,
              height: 50,
              isCircle: true,
              image: context.read<UserCubit>().state.data!.profilePicture ??
                  UIConst.profilePlaceHolder,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: TextField(
                focusNode: widget.focusNode,
                controller: widget.commentController,
                style: TextStyle(
                  color: context.isDarkMode ? Colors.white : Colors.black87,
                ),
                maxLines: null,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  filled: true,
                  suffixIcon: widget.commentController.text.isNotEmpty
                      ? Container(
                          margin: EdgeInsetsDirectional.only(
                              end: 10.w, top: 10, bottom: 10),
                          padding: const EdgeInsets.all(3)
                              .add(EdgeInsets.symmetric(horizontal: 10.w)),
                          decoration: BoxDecoration(
                            color: AppColors.SECONDARY_COLOR,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: InkWell(
                            onTap: () async {
                              final reelsCubit = context.read<ReelsCubit>();
                              if (reelsCubit.receiverComment != null &&
                                  reelsCubit.parentCommentId != null) {
                                await reelsCubit.addReplayComment(
                                  context,
                                  widget.reel.id,
                                  widget.commentController.text.trim(),
                                  parentCommentId: reelsCubit.parentCommentId,
                                  receiverComment: reelsCubit.receiverComment,
                                );
                              } else {
                                await reelsCubit.addComment(
                                    context,
                                    widget.reel.id,
                                    widget.commentController.text);
                                if (widget.scrollController.hasClients &&
                                    widget.scrollController.position
                                            .maxScrollExtent >
                                        0) {
                                  widget.scrollController.animateTo(
                                    widget.scrollController.position
                                        .minScrollExtent,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOut,
                                  );
                                }
                              }
                              widget.commentController.clear();
                              widget.focusNode.unfocus();
                              reelsCubit
                                  .updateParentCommentIdAndReceiverComment(
                                      receiverComment: null,
                                      parentCommentId: null);

                              // setState(() {});
                            },
                            child: Icon(
                              Icons.arrow_upward,
                              color: Colors.white,
                              size: 30.h,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              Assets.mentionIcon,
                            ),
                            SizedBox(width: 25.w),
                            SvgPicture.asset(
                              Assets.emojiIcon,
                            ),
                            SizedBox(width: 25.w),
                            SvgPicture.asset(
                              Assets.mentionIcon,
                            ),
                            SizedBox(width: 25.w),
                            GestureDetector(
                              onTap: () {
                                if (!serviceLocator<UserCubit>().isLoggedIn) {
                                  context.read<PreloadBloc>().pauseTheVideo();
                                  context.push(Routes.LOGIN);
                                } else {
                                  _showGiftBottomSheet(context);
                                }
                              },
                              child: SvgPicture.asset(
                                Assets.giftCommentIcon,
                              ),
                            ),
                            SizedBox(width: 25.w),
                          ],
                        ),
                  fillColor:
                      context.isDarkMode ? Colors.grey[800] : Colors.black12,
                  hintText: LocaleKeys.add_comment_hint.localize,
                  hintStyle: TextStyle(
                    color: context.isDarkMode ? Colors.grey : Colors.black54,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(16),
                ),
                minLines: 1,
                keyboardType: TextInputType.multiline,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TikTokCommentBox extends StatefulWidget {
  const TikTokCommentBox({super.key});

  @override
  State<TikTokCommentBox> createState() => _TikTokCommentBoxState();
}

class _TikTokCommentBoxState extends State<TikTokCommentBox> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  bool _isFocused = false;
  bool _showEmojiPicker = false;

  final emojiList = ['😁', '🥰', '😂', '😳', '😉', '😅', '🥺'];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
        if (_isFocused) _showEmojiPicker = false;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void insertEmoji(String emoji) {
    final text = _controller.text;
    final selection = _controller.selection;

    final newText = text.replaceRange(selection.start, selection.end, emoji);
    final emojiLength = emoji.length;
    final newSelectionIndex = selection.start + emojiLength;

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newSelectionIndex),
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم اختيار صورة من المعرض')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Emojis Row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.grey.withAlpha(50)
                  : const Color(0xffFAFAFA),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: emojiList
                  .map((emoji) => GestureDetector(
                        onTap: () => insertEmoji(emoji),
                        child:
                            Text(emoji, style: const TextStyle(fontSize: 24)),
                      ))
                  .toList(),
            ),
          ),

          // Comment box
          Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: TextFormField(
              minLines: 1,
              maxLines: 5,
              focusNode: _focusNode,
              controller: _controller,
              decoration: InputDecoration(
                prefixIcon: Container(
                  margin: const EdgeInsets.only(right: 10, left: 10),
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://i.pravatar.cc/300'),
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                hintText:
                    context.isArabic ? 'اضافة تعليق...' : 'Add comment...',
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.grey,
                ),
                filled: true,
                fillColor: isDarkMode
                    ? Colors.grey.withAlpha(50)
                    : const Color(0xffFAFAFA),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 20),
                    SvgPicture.asset(
                      Assets.mentionIcon,
                      width: 20,
                      height: 20,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _showEmojiPicker = !_showEmojiPicker;
                        });
                      },
                      child: SvgPicture.asset(
                        Assets.emojiIcon,
                        width: 20,
                        height: 20,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: _pickImage,
                      child: SvgPicture.asset(
                        Assets.galleryIcon,
                        width: 20,
                        height: 20,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => _showGiftBottomSheet(context),
                      child: SvgPicture.asset(
                        'assets/images/giftCommentIcon.svg',
                        width: 20,
                        height: 20,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
              style: const TextStyle(fontSize: 14),
            ),
          ),

          // Emoji Picker
          if (_showEmojiPicker)
            SizedBox(
              height: 250,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  insertEmoji(emoji.emoji);
                },
                config: Config(),
              ),
            ),
        ],
      ),
    );
  }
}

Future<void> _showGiftBottomSheet(BuildContext context) async {
  await showGiftBottomSheet(context, receiverId: "widget.receiverId");
}
