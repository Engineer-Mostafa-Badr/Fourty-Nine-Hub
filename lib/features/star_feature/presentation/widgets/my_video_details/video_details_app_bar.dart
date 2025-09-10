import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';

class VideoDetailsAppBar extends StatelessWidget {
  final String title;
  final VoidCallback onBack;

  const VideoDetailsAppBar({
    super.key,
    required this.title,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: _getResponsivePadding(context, 16),
        vertical: _getResponsivePadding(context, 8),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: _getResponsiveIconSize(context, 24),
            ),
            onPressed: onBack,
          ),
          Text(
            context.isArabic ? 'الملف الشخصي' : title,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: _getResponsiveFontSize(context, 18),
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

  double _getResponsivePadding(BuildContext context, double basePadding) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return basePadding * 0.8;
    } else if (screenWidth > 400) {
      return basePadding * 1.15;
    }
    return basePadding;
  }

  double _getResponsiveIconSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 360) {
      return baseSize * 0.9;
    }
    return baseSize;
  }
}
