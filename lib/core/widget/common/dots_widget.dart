import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class DotsWidget extends StatefulWidget {
  const DotsWidget({super.key, required this.length, required this.currentIndex});
  final int length;
  final int currentIndex;
  @override
  State<DotsWidget> createState() => _DotsWidgetState();
}

class _DotsWidgetState extends State<DotsWidget> {
  List<Widget> _buildDotsIndicator() {
    int maxVisibleDots = widget.length;
    final int totalDots = widget.length;

    if (totalDots <= maxVisibleDots) {
      return List.generate(totalDots, (index) => _buildDot(index));
    }

    List<Widget> dots = [];

    int startIndex, endIndex;

    if (widget.currentIndex <= 4) {
      startIndex = 0;
      endIndex = 8;
    } else if (widget.currentIndex >= totalDots - 5) {
      startIndex = totalDots - 9;
      endIndex = totalDots - 1;
    } else {
      startIndex = widget.currentIndex - 4;
      endIndex = widget.currentIndex + 4;
    }

    for (int i = startIndex; i <= endIndex; i++) {
      dots.add(_buildDot(i));
    }

    return dots;
  }
  Widget _buildDot(int index) {
    bool isActive = index == widget.currentIndex;

    // تحديد حجم النقطة بناءً على المسافة من النقطة النشطة
    double dotSize = 8.0;
    double dotScale = 1.0;

    if (isActive) {
      dotScale = 1.3; // النقطة النشطة
    } else {
      int distance = (index - widget.currentIndex).abs();
      if (distance == 1) {
        dotScale = 1.0; // النقاط المجاورة
      } else if (distance == 2) {
        dotScale = 0.7; // النقاط قبل الأخيرة
      } else {
        dotScale = 0.5; // النقاط البعيدة
      }
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 2.5),
      width: dotSize * dotScale,
      height: dotSize * dotScale,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive
            ? (context.isDarkMode ? Colors.white : AppColors.SECONDARY_COLOR)
            : (context.isDarkMode
            ? const Color(0x26FFFFFF)
            : Colors.grey.withOpacity(0.3 + (dotScale * 0.4))),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _buildDotsIndicator(),
    );
  }
}
