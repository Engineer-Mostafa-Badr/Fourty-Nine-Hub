import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class WelcomeTextWidget extends StatefulWidget {
  const WelcomeTextWidget({super.key});

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
            top: 120,
            left: position.dx + size.width / 2 - 125,
            right: 50,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child:const  Text(
                  "Create Ad for a trip with your car, wait users to contact you. Share trip & gain money!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
          LocaleKeys.welcomeToTripjoin.localize,
          style:const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.SECONDARY_COLOR,
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            final renderBox = context.findRenderObject() as RenderBox;
            _toggleTooltip(context, renderBox);
          },
          child: Container(
            width: 30,
            height: 30,
            decoration:  BoxDecoration(
              color: AppColors.PRIMARY_COLOR,
              borderRadius: BorderRadius.circular(20.h)
            ),
            child: const Icon(
              size: 18,
              Icons.question_mark,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}