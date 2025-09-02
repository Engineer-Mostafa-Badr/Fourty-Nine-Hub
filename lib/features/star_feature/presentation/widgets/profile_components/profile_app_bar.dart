import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

class ProfileAppBar extends StatelessWidget {
  final bool isCurrentUser;
  final VoidCallback? onEditPressed;
  final VoidCallback? onBackPressed;

  const ProfileAppBar({
    super.key,
    required this.isCurrentUser,
    this.onEditPressed,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
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
                _getTitle(context),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: _getResponsiveFontSize(context, 20),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Action Button
            _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  String _getTitle(BuildContext context) {
    if (isCurrentUser) {
      return context.isArabic ? 'ملفي الشخصي' : 'My Profile';
    }
    return 'Winners 🏆';
  }

  Widget _buildActionButton(BuildContext context) {
    if (isCurrentUser) {
      return IconButton(
        icon: Icon(
          Icons.edit,
          color: Colors.black,
          size: _getResponsiveIconSize(context, 24),
        ),
        onPressed: onEditPressed,
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
