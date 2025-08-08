import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../res/style/app_colors.dart';
import '../../../../../../helpers/manage_vibration.dart';

class WelcomeTextWidget extends StatefulWidget {
  const WelcomeTextWidget({super.key, required this.title, required this.infoMessage});
  final String title;
  final String infoMessage;
  @override
  _WelcomeTextWidgetState createState() => _WelcomeTextWidgetState();
}

class _WelcomeTextWidgetState extends State<WelcomeTextWidget> {
  OverlayEntry? _overlayEntry;

  void _toggleTooltip(BuildContext context, RenderBox renderBox) {
    if (_overlayEntry != null) {
      _removeTooltip();
    } else {
      _showTooltip(context, renderBox);
    }
  }

  void _showTooltip(BuildContext context, RenderBox renderBox) {
    final overlay = Overlay.of(context);
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeTooltip,
              behavior: HitTestBehavior.opaque,
            ),
          ),
          Positioned(
            top: 110,
            left: position.dx + size.width / 2 - 125,
            right: 50,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.isDarkMode?AppColors.fill_Color_DARK:Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child:  Text(
                  widget.infoMessage ,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: context.isDarkMode?Colors.white:Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _removeTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color:AppColors.getRedColor(context),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
      ManageVibration.vibrate();
            final renderBox = context.findRenderObject() as RenderBox;
            _toggleTooltip(context, renderBox);
          },
          child: Container(
            width: 30,
            height: 30,
            decoration:  BoxDecoration(
              color: AppColors.getButtonPrimaryColor(context),
              borderRadius: BorderRadius.circular(20.h)
            ),
            child: Icon(
              size: 18,
              Icons.question_mark,
              color:context.isDarkMode?Colors.black: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}