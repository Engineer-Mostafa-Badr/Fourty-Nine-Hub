import 'package:flutter/material.dart';
import 'package:fourtyninehub/helpers/manage_vibration.dart';

class OptionItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  OptionItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });
}

class OptionsBottomSheet {
  static void showOptions({
    required BuildContext context,
    required List<OptionItem> options,
    Color backgroundColor = Colors.white,
    Color indicatorColor = const Color(0xffE4E4E4),
    double borderRadius = 10,
    EdgeInsets margin =
        const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Container(
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle indicator
            Container(
              width: 42,
              height: 4,
              margin: EdgeInsets.only(top: 8, bottom: 0),
              decoration: BoxDecoration(
                color: indicatorColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Build options dynamically
            ...options.map((option) => _buildOptionItem(
                  context: context,
                  icon: option.icon,
                  title: option.title,
                  onTap: () {
                    ManageVibration.vibrate();
                    option.onTap.call();
                  },
                  iconColor: option.iconColor,
                  textColor: option.textColor,
                )),
          ],
        ),
      ),
    );
  }

  static Widget _buildOptionItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? textColor,
  }) {
    return InkWell(
      onTap: () {
        ManageVibration.vibrate();
        onTap.call();
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(left: 13, top: 16, right: 13, bottom: 2),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: Icon(
                icon,
                size: 24,
                color: iconColor ?? Colors.black87,
              ),
            ),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: textColor ?? Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
