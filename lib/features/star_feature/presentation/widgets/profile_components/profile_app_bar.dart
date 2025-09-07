import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../domain/entity/user_star_entity.dart';

class ProfileAppBar extends StatelessWidget {
  final UserStarEntity? profileUser; // المستخدم اللي بنعرض profile بتاعه
  final String? currentUserId; // ID المستخدم الحالي
  final VoidCallback? onEditPressed;
  final VoidCallback? onBackPressed;

  const ProfileAppBar({
    super.key,
    this.profileUser,
    this.currentUserId,
    this.onEditPressed,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد إذا كان المستخدم الحالي هو صاحب الحساب
    final bool isCurrentUser = _isCurrentUserProfile();

    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Row(
          children: [
            // Back Button
            IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: _getResponsiveIconSize(context, 24),
              ),
              onPressed: onBackPressed,
            ),

            // Title
            Expanded(
              child: Text(
                _getTitle(context, isCurrentUser),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: _getResponsiveFontSize(context, 20),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Action Button
            _buildActionButton(context, isCurrentUser),
          ],
        ),
      ),
    );
  }

  // دالة للتحقق من إذا كان المستخدم الحالي هو صاحب الحساب

  bool _isCurrentUserProfile() {
    if (currentUserId == null || profileUser?.id == null) {
      return false;
    }
    return currentUserId == profileUser!.id;
  }

  String _getTitle(BuildContext context, bool isCurrentUser) {
    if (isCurrentUser) {
      return context.isArabic ? 'ملفي الشخصي' : 'My Profile';
    } else {
      // عرض اسم المستخدم أو عنوان عام
      if (profileUser != null) {
        return '${profileUser!.firstName} ${profileUser!.lastName}';
      }
      return 'Profile';
    }
  }

  Widget _buildActionButton(BuildContext context, bool isCurrentUser) {
    // إظهار زر التعديل فقط للمستخدم الحالي
    if (isCurrentUser && onEditPressed != null) {
      return IconButton(
        icon: Icon(
          Icons.edit,
          color: Colors.black,
          size: _getResponsiveIconSize(context, 24),
        ),
        onPressed: onEditPressed,
      );
    }

    // إذا لم يكن المستخدم الحالي، ممكن تضيف أزرار أخرى زي Follow/Subscribe
    if (isCurrentUser) {
      return IconButton(
        icon: Icon(
          Icons.person_add,
          color: Colors.blue,
          size: _getResponsiveIconSize(context, 24),
        ),
        onPressed: () {
          // Logic للـ follow/subscribe
        },
      );
    }

    return SizedBox(width: 48.w);
  }

  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseFontSize * 0.85;
    } else if (screenWidth > 400) {
      return baseFontSize * 1.1;
    }
    return baseFontSize;
  }

  double _getResponsiveIconSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSize * 0.9;
    }
    return baseSize;
  }
}
