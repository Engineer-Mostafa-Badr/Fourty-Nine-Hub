import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import '../../../../../res/style/app_colors.dart';

class ReplyWidget extends StatefulWidget {
  const ReplyWidget({super.key});

  @override
  State<ReplyWidget> createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> with WidgetsBindingObserver {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _keyboardWasVisible = false;
  bool _isInitialized = false;
  bool _isRecording = false;
  bool _showEmojiPicker = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // إضافة listener للتحكم في حالة النص
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _focusNode.requestFocus();
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            _isInitialized = true;
            _keyboardWasVisible = true;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    if (!_isInitialized) return;

    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;

    if (_keyboardWasVisible && !isKeyboardVisible && !_showEmojiPicker) {
      Navigator.of(context).pop();
    }

    _keyboardWasVisible = isKeyboardVisible;
  }

  Future<void> _openGallery() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print('Image selected: ${image.path}');
    }
  }

  Future<void> _recordVideo() async {
    if (_isRecording) {
      // إيقاف التسجيل
      setState(() {
        _isRecording = false;
      });
      print('Video recording stopped');
    } else {
      try {
        final video = await _picker.pickVideo(
          source: ImageSource.camera,
          maxDuration: const Duration(minutes: 5),
        );

        if (video != null) {
          print('Video recorded: ${video.path}');
        }

        setState(() {
          _isRecording = false;
        });
      } catch (e) {
        print('Error recording video: $e');
        setState(() {
          _isRecording = false;
        });
      }
    }
  }

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;
    });

    if (_showEmojiPicker) {
      _focusNode.unfocus();
    } else {
      _focusNode.requestFocus();
    }
  }

  void _onEmojiSelected(Category? category, Emoji emoji) {
    final text = _controller.text;
    final selection = _controller.selection;
    final newText = text.replaceRange(
      selection.start,
      selection.end,
      emoji.emoji,
    );

    _controller.text = newText;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: selection.start + emoji.emoji.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_showEmojiPicker) {
          setState(() {
            _showEmojiPicker = false;
          });
          return false;
        }
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
          return false;
        }
        return true;
      },
      child: GestureDetector(
        onTap: () {
          if (!_focusNode.hasFocus && !_showEmojiPicker) {
            _focusNode.requestFocus();
          }
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: context.isDarkMode ? Colors.grey[900] : Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _emojiText("😊"),
                    _emojiText("🥰"),
                    _emojiText("😂"),
                    _emojiText("😳"),
                    _emojiText("😊"),
                    _emojiText("😅"),
                    _emojiText("🥺"),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  GestureDetector(
                    onTap: _recordVideo,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isRecording
                            ? Colors.red
                            : AppColors.PRIMARY_COLOR_DARK,
                      ),
                      child: Center(
                        child: _isRecording
                            ? const Icon(
                                Icons.stop,
                                color: Colors.white,
                                size: 18,
                              )
                            : SvgPicture.asset(Assets.addSoundIcon),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      autofocus: true,
                      minLines: 1,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: context.isArabic
                            ? "الرد على أحمد محم"
                            : "replying to ahmed mohamed",
                        filled: true,
                        fillColor: context.isDarkMode
                            ? AppColors.QUANTITY_COLOR.withAlpha(5)
                            : const Color(0xffEDEDED),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                      style: TextStyle(
                        color: context.isDarkMode ? Colors.white : Colors.black,
                      ),
                      onTap: () {
                        if (_showEmojiPicker) {
                          setState(() {
                            _showEmojiPicker = false;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    Assets.mentionIcon,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: _toggleEmojiPicker,
                    child: SvgPicture.asset(
                      Assets.emojiIcon,
                      color: _showEmojiPicker
                          ? AppColors.PRIMARY_COLOR_DARK
                          : (context.isDarkMode ? Colors.white : Colors.black),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: _openGallery,
                    child: SvgPicture.asset(
                      Assets.galleryIcon,
                      color: context.isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 35,
                    height: 30,
                    decoration: BoxDecoration(
                      color: _hasText
                          ? const Color(0xffFF3308)
                          : const Color(0xffFF3308).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_upward_outlined,
                        color: _hasText
                            ? Colors.white
                            : Colors.white.withOpacity(0.7),
                        size: 24,
                      ),
                    ),
                  )
                ],
              ),
              // Emoji Picker
              if (_showEmojiPicker)
                SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    onEmojiSelected: _onEmojiSelected,
                    config: Config(
                      checkPlatformCompatibility: true,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emojiText(String emoji) {
    return GestureDetector(
      onTap: () {
        final text = _controller.text;
        final newText = text + emoji;
        _controller.text = newText;
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: newText.length),
        );
        _focusNode.requestFocus();
      },
      child: Text(emoji, style: const TextStyle(fontSize: 24)),
    );
  }
}
