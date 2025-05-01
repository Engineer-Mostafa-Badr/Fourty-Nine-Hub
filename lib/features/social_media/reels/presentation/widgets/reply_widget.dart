import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../res/style/app_colors.dart';
import '../../../chat/chat_room/presentation/widgets/chat_room_widgets/emoji_keyboard.dart';

class ReplyWidget extends StatefulWidget {
  const ReplyWidget({super.key});

  @override
  State<ReplyWidget> createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  late final TextEditingController _messageTextController;

  @override
  void initState() {
    super.initState();
    // ده بيخلي الكيبورد يفتح تلقائيًا بعد ما الودجت يبني
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16,
          left: 16,
          right: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Emojis Row
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Text("😊", style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text("🥰", style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text("😂", style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text("😳", style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text("😊", style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text("😅", style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text("🥺", style: TextStyle(fontSize: 24)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.PRIMARY_COLOR_DARK,
                  ),
                  child: Center(
                    child: SvgPicture.asset(Assets.addSoundIcon),
                  ),
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: FormTextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    hintStyle: TextStyle(
                      color: context.isDarkMode
                          ? Colors.white
                          : Colors.grey.shade600,
                    ),
                    hint: context.isArabic
                        ? "الرد على أحمد محم"
                        : "replying to ahmed mohamed",
                    fillColor: context.isDarkMode
                        ? Colors.white
                        : const Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset(Assets.mentionIcon),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () {
                    EmojiKeyboard(textController: _messageTextController);
                  },
                  child: SvgPicture.asset(
                    Assets.emojiIcon,
                  ),
                ),
                const SizedBox(width: 16),
                SvgPicture.asset(Assets.galleryIcon),
                const SizedBox(width: 16),
                Container(
                  width: 30,
                  height: 35,
                  decoration: BoxDecoration(
                    color: const Color(0xffFF3308),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.arrow_upward_outlined,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
