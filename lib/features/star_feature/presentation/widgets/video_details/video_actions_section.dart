import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';

class VideoActionsSection extends StatelessWidget {
  final StarEntity talent;
  final VoidCallback onViewersPressed;
  final VoidCallback onCommentsPressed;
  final VoidCallback onDeletePressed;

  const VideoActionsSection({
    super.key,
    required this.talent,
    required this.onViewersPressed,
    required this.onCommentsPressed,
    required this.onDeletePressed,
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
                '${_formatViews(talent.totalViews.toInt())} ${context.isArabic ? 'مشاهدات' : 'views'}',
            onTap: onViewersPressed,
          ),
          _buildActionButton(
            context: context,
            icon: Icons.comment,
            label: context.isArabic ? 'تعليقات' : 'Comments',
            onTap: onCommentsPressed,
          ),
          _buildActionButton(
            context: context,
            icon: Icons.delete,
            label: context.isArabic ? 'حذف' : 'Delete',
            onTap: onDeletePressed,
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _getResponsivePadding(context, 20),
          vertical: _getResponsivePadding(context, 12),
        ),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red : Color(0xFF1B365C),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: (isDestructive ? Colors.red : Color(0xFF1B365C))
                  .withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: _getResponsiveIconSize(context, 18),
            ),
            SizedBox(width: _getResponsiveSpacing(context, 8)),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: _getResponsiveFontSize(context, 14),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatViews(int views) {
    if (views >= 1000000) {
      return '${(views / 1000000).toStringAsFixed(1)}M';
    } else if (views >= 1000) {
      return '${(views / 1000).toStringAsFixed(1)}K';
    }
    return views.toString();
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
