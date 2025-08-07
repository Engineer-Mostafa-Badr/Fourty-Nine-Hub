import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/utils/hex_color_helper.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets/form/text_fields/form_text_field.dart';
import '../../../../../res/assets/assets.dart';
import '../../../../../helpers/manage_vibration.dart';

class SendToBottomSheet extends StatefulWidget {
  const SendToBottomSheet({super.key});

  @override
  State<SendToBottomSheet> createState() => _SendToBottomSheetState();
}

class _SendToBottomSheetState extends State<SendToBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Text(
                context.isArabic ? 'ارسل ل' : 'Send to',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
      ManageVibration.vibrate();
                  context.pop();
                },
                child: const Icon(
                  Icons.close,
                ),
              )
            ],
          ),
          SizedBox(height: 20.h),
          FormTextField(
            controller: _searchController,
            style: TextStyle(
              color: context.isDarkMode ? Colors.white : Colors.grey.shade600,
              fontSize: 16,
            ),
            fillColor:
                context.isDarkMode ? Colors.grey[800] : Color(0xffF5F5F5),
            hint: context.isArabic ? 'البحث' : 'Search',
            // style: TextStyle(
            //   fontSize: 16,
            //   fontWeight: FontWeight.w400,
            //   color: context.isDarkMode ? Colors.white70 : Colors.grey,
            // ),
            prefix: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SvgPicture.asset(
                Assets.searchSoundIcon,
                width: 20,
                height: 20,
                color: context.isDarkMode ? Colors.white70 : Colors.grey,
              ),
            ),
            borderColor: context.isDarkMode ? Colors.white : Colors.black,
            noBorder: true,
            borderRadius: BorderRadius.circular(10),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) => UserCheckboxRow(
                imageUrl: Assets.userEx,
                name: context.isArabic
                    ? 'عبد الرحمن_لطفي'
                    : 'Abdelrahman__Lotafy',
                username: context.isArabic
                    ? 'عبد الرحمن_لطفي'
                    : 'Abdelrahman__lotafy',
              ),
              itemCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class UserCheckboxRow extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String username;

  const UserCheckboxRow({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.username,
  });

  @override
  State<UserCheckboxRow> createState() => UserCheckboxRowState();
}

class UserCheckboxRowState extends State<UserCheckboxRow> {
  bool isChecked = false;

  void _showMessageComposer(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: context.isDarkMode ? Colors.grey[900] : Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) => MessageComposerBottomSheet(
        userName: widget.name,
        userImage: widget.imageUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(widget.imageUrl),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        context.isArabic ? ' صديق' : '. Friends',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.username,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Transform.scale(
              scale: 1.2,
              child: Checkbox(
                checkColor: Colors.white,
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value!;
                  });
                  if (isChecked) {
                    _showMessageComposer(context);
                  }
                },
                shape: CircleBorder(),
                side: BorderSide(color: Colors.grey, width: 1.5),
                activeColor: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageComposerBottomSheet extends StatefulWidget {
  final String userName;
  final String userImage;

  const MessageComposerBottomSheet({
    super.key,
    required this.userName,
    required this.userImage,
  });

  @override
  State<MessageComposerBottomSheet> createState() =>
      _MessageComposerBottomSheetState();
}

class _MessageComposerBottomSheetState
    extends State<MessageComposerBottomSheet> {
  final TextEditingController _messageController = TextEditingController();
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() {
      setState(() {
        // _canSend = _messageController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.isDarkMode ? Colors.grey[800] : Colors.white,
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: context.isDarkMode ? Colors.grey[800] : Colors.white,
            ),
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                  fillColor:
                      context.isDarkMode ? Colors.grey[800] : Colors.white,
                  hintText:
                      context.isArabic ? 'اكتب رسالة...' : 'Write a message...',
                  hintStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  suffixIcon: Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(
                            Assets.songEx,
                          ),
                          fit: BoxFit.fill,
                        ),
                      ))),
              style: TextStyle(
                color: context.isDarkMode ? Colors.white : Colors.black,
                fontSize: 16,
              ),
              maxLines: 4,
              minLines: 1,
            ),
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () {
      ManageVibration.vibrate();
              setState(() {
                isChecked = !isChecked;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isChecked ? HexColor('#F33D49') : Colors.grey,
                    ),
                    color: isChecked ? HexColor('#F33D49') : Colors.transparent,
                  ),
                  child: isChecked
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 14,
                        )
                      : null,
                ),
                const SizedBox(width: 8),
                Text(
                  context.isArabic
                      ? ' انشاء مجموعة'
                      : "Create group chat with friends",
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {

      ManageVibration.vibrate();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xffF33D49),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                context.isArabic ? 'إرسال' : 'Send',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}