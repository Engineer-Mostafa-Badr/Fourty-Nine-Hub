import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/models/chat_model.dart';
import '../../../../res/style/app_colors.dart';

class ChatItemWidget extends StatelessWidget {
  final ChatModel chat;
  final VoidCallback? onTap;

  const ChatItemWidget({
    super.key,
    required this.chat,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // Profile Image
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade300,
              ),
              child: chat.profileImage.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(25.r),
                      child: Image.asset(
                        chat.profileImage,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      size: 30.sp,
                      color: Colors.grey.shade600,
                    ),
            ),
            SizedBox(width: 12.w),
            
            // Chat Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.name,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat.isVerified)
                        Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 16.sp,
                        ),
                      SizedBox(width: 4.w),
                      Text(
                        chat.time,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.lastMessage,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: chat.isTyping ? AppColors.PRIMARY_COLOR : Colors.grey.shade600,
                            fontWeight: chat.isTyping ? FontWeight.w500 : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (chat.unreadCount > 0) ...[
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.PRIMARY_COLOR,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            '${chat.unreadCount}',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            
            // Action Icons
            if (chat.isMuted || chat.isPinned)
              Column(
                children: [
                  if (chat.isMuted)
                    Icon(
                      Icons.volume_off,
                      size: 16.sp,
                      color: Colors.grey.shade600,
                    ),
                  if (chat.isPinned)
                    Icon(
                      Icons.push_pin,
                      size: 16.sp,
                      color: Colors.grey.shade600,
                    ),
                  if (chat.unreadCount > 0)
                    Icon(
                      Icons.visibility,
                      size: 16.sp,
                      color: Colors.grey.shade600,
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
