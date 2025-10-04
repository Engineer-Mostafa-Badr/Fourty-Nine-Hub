import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/numbers_extensions.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/presentation/controller/star_cubit/star_cubit.dart'; // إضافة import للـ cubit

class VideoActionsSection extends StatelessWidget {
  final StarEntity talent;
  final StarCubit cubit; // إضافة الـ cubit كـ parameter
  final VoidCallback onViewersPressed;
  final VoidCallback onCommentsPressed;
  final VoidCallback? onDeletePressed; // جعلها اختيارية

  const VideoActionsSection({
    super.key,
    required this.talent,
    required this.cubit, // إضافة الـ cubit
    required this.onViewersPressed,
    required this.onCommentsPressed,
    this.onDeletePressed, // جعلها اختيارية
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: _getResponsivePadding(context, 16),
        vertical: _getResponsivePadding(context, 20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            context: context,
            icon: Icons.visibility,
            label:
                '${_formatViews(talent.totalViews.toInt(), context)} ${context.isArabic ? 'مشاهدات' : 'views'}',
            onTap: onViewersPressed,
          ),
          _buildActionButton(
            context: context,
            // icon: Icons.comment,
            hasIcon: false,
            label: context.isArabic ? 'تعليقات' : 'Comments',
            onTap: onCommentsPressed,
          ),
          _buildActionButton(
            context: context,
            // icon: Icons.delete,
            hasIcon: false,
            label: context.isArabic ? 'حذف' : 'Delete',
            onTap: onDeletePressed ?? () => _handleDelete(context),
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  // دالة للتعامل مع الحذف
  void _handleDelete(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // منع الإغلاق بالضغط خارج الـ dialog
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // زوايا دائرية
        ),
        contentPadding: EdgeInsets.all(24),
        content: Column(
          // mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Text(
              'Alert!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 16),

            // Message
            Text(
              'Are you sure about deleting the Talent',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                // Delete Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // تنفيذ عملية الحذف
                      cubit.deleteMyTubeVideo(talent.id);

                      // عرض رسالة تأكيد
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            context.isArabic
                                ? 'تم حذف الفيديو بنجاح'
                                : 'Video deleted successfully',
                          ),
                          backgroundColor: Colors.green,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),

                // Close Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Color(0xFF1B365C), // نفس لون الأزرار الأخرى
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    IconData? icon,
    bool hasIcon = true,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _getResponsivePadding(context, 24.w),
          vertical: _getResponsivePadding(context, 10.h),
        ),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red : Color(0xFF1B365C),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: (isDestructive ? Colors.red : Color(0xFF1B365C))
                  .withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: hasIcon
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size:
                        _getResponsiveIconSize(context, 24), // قلل من 18 إلى 16
                  ),
                  SizedBox(
                      width:
                          _getResponsiveSpacing(context, 2)), // قلل من 8 إلى 6
                  Flexible(
                    // أضف Flexible للنص
                    child: Text(
                      label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _getResponsiveFontSize(
                            context, 12), // قلل من 14 إلى 12
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis, // أضف overflow handling
                      maxLines: 1,
                    ),
                  ),
                ],
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: _getResponsivePadding(context, 12.w),
                  vertical: _getResponsivePadding(context, 5.h),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        _getResponsiveFontSize(context, 12), // قلل من 14 إلى 12
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
      ),
    );
  }

  String _formatViews(int views, BuildContext context) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return views.toString().toArabicNumbers(context);
  }

  // Responsive helper methods
  double _getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseFontSize * 0.85;
    } else if (screenWidth > 400) {
      return baseFontSize * 1.1;
    }
    return baseFontSize;
  }

  double _getResponsivePadding(BuildContext context, double basePadding) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return basePadding * 0.8;
    } else if (screenWidth > 400) {
      return basePadding * 1.15;
    }
    return basePadding;
  }

  double _getResponsiveSpacing(BuildContext context, double baseSpacing) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSpacing * 0.75;
    }
    return baseSpacing;
  }

  double _getResponsiveIconSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSize * 0.9;
    }
    return baseSize;
  }
}
