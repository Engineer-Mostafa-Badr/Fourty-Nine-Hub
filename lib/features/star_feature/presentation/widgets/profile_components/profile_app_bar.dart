import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

import '../../../domain/entity/user_star_entity.dart';
import '../../../domain/entity/profile_entity.dart';
import '../../controller/profile_cubit/profile_cubit.dart';

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
    return SafeArea(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, profileState) {
            // تحديد إذا كان المستخدم الحالي هو صاحب الحساب باستخدام ProfileEntity
            final bool isCurrentUser = _isCurrentUserProfile(profileState);

            return Row(
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
                AutoSizeText(
                  _getTitle(context, isCurrentUser, profileState),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: _getResponsiveFontSize(context, 20),
                    fontWeight: FontWeight.w600,
                  ),

                  // child: Text(
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     color: Colors.black,
                  //     fontSize: _getResponsiveFontSize(context, 20),
                  //     fontWeight: FontWeight.w600,
                  //   ),
                  // ),
                ),
                Spacer(),
                // Action Button - إظهار زرار التعديل فقط للمستخدم الحالي
                _buildActionButton(context, isCurrentUser),
              ],
            );
          },
        ),
      ),
    );
  }

  // دالة للتحقق من إذا كان المستخدم الحالي هو صاحب الحساب باستخدام ProfileEntity
  bool _isCurrentUserProfile(ProfileState profileState) {
    print("🔍 ProfileAppBar Debug:");
    print("   Current User ID: $currentUserId");
    print("   Profile User ID: ${profileUser?.id}");

    if (profileState.profile != null && currentUserId != null) {
      // استخدام ProfileEntity.userId للمقارنة الدقيقة
      final profileUserId = profileState.profile!.userId;
      final isCurrentUser = currentUserId == profileUserId;

      print("   ProfileEntity User ID: $profileUserId");
      print("   Is Current User (ProfileEntity): $isCurrentUser");

      return isCurrentUser;
    }

    // Fallback للطريقة القديمة إذا لم يتم تحميل ProfileEntity بعد
    if (currentUserId == null || profileUser?.id == null) {
      print("   Missing IDs - using fallback: false");
      return false;
    }

    final isMatch = currentUserId == profileUser!.id;
    print(
        "   Fallback ID Comparison: '$currentUserId' == '${profileUser!.id}' = $isMatch");

    return isMatch;
  }

  String _getTitle(
      BuildContext context, bool isCurrentUser, ProfileState profileState) {
    if (isCurrentUser) {
      // إظهار "ملف شخصي" للمستخدم الحالي
      return context.isArabic ? 'ملفي الشخصي' : 'My Profile';
    } else {
      // استخدام اسم من ProfileEntity إذا متاح، وإلا من UserStarEntity
      if (profileState.profile != null &&
          profileState.profile!.channelName.isNotEmpty) {
        return profileState.profile!.channelName;
      } else if (profileUser != null) {
        final fullName =
            '${profileUser!.firstName} ${profileUser!.lastName}'.trim();
        return fullName.isNotEmpty ? fullName : 'Profile';
      }
      return context.isArabic ? 'الملف الشخصي' : 'Profile';
    }
  }

  Widget _buildActionButton(BuildContext context, bool isCurrentUser) {
    if (isCurrentUser && onEditPressed != null) {
      // إظهار زرار التعديل فقط للمستخدم الحالي
      return IconButton(
        icon: Icon(
          Icons.edit,
          color: Colors.black,
          size: _getResponsiveIconSize(context, 24),
        ),
        onPressed: onEditPressed,
        tooltip: context.isArabic ? 'تعديل الملف الشخصي' : 'Edit Profile',
      );
    }

    // للمستخدمين الآخرين، يمكن إضافة زرار للمتابعة أو الإعدادات
    if (!isCurrentUser) {
      return PopupMenuButton<String>(
        icon: Icon(
          Icons.more_vert,
          color: Colors.black,
          size: _getResponsiveIconSize(context, 24),
        ),
        onSelected: (value) {
          switch (value) {
            case 'follow':
              _handleFollowUser(context);
              break;
            case 'share':
              _handleShareProfile(context);
              break;
            case 'report':
              _handleReportUser(context);
              break;
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem<String>(
            value: 'follow',
            child: Row(
              children: [
                Icon(Icons.person_add, size: 20),
                SizedBox(width: 8),
                Text(context.isArabic ? 'متابعة' : 'Follow'),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'share',
            child: Row(
              children: [
                Icon(Icons.share, size: 20),
                SizedBox(width: 8),
                Text(context.isArabic ? 'مشاركة' : 'Share'),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'report',
            child: Row(
              children: [
                Icon(Icons.flag, size: 20, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  context.isArabic ? 'إبلاغ' : 'Report',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      );
    }

    // لو مفيش actions متاحة، نعرض مساحة فارغة للحفاظ على التوازن
    return SizedBox(width: 48.w);
  }

  void _handleFollowUser(BuildContext context) {
    // تنفيذ منطق المتابعة
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.isArabic ? 'تم إرسال طلب المتابعة' : 'Follow request sent',
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleShareProfile(BuildContext context) {
    // تنفيذ منطق مشاركة الملف الشخصي
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          context.isArabic ? 'تم نسخ رابط الملف الشخصي' : 'Profile link copied',
        ),
      ),
    );
  }

  void _handleReportUser(BuildContext context) {
    // تنفيذ منطق الإبلاغ عن المستخدم
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.isArabic ? 'إبلاغ عن المستخدم' : 'Report User',
        ),
        content: Text(
          context.isArabic
              ? 'هل تريد الإبلاغ عن هذا المستخدم؟'
              : 'Do you want to report this user?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(context.isArabic ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    context.isArabic ? 'تم الإبلاغ بنجاح' : 'Report submitted',
                  ),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(
              context.isArabic ? 'إبلاغ' : 'Report',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
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
