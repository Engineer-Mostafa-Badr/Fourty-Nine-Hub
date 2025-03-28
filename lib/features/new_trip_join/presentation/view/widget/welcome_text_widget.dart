import 'package:flutter/material.dart';
import '../../../../../res/style/app_colors.dart';

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
          // لإغلاق التولتيب عند الضغط في أي مكان خارجها
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeTooltip,
              behavior: HitTestBehavior.opaque,
            ),
          ),
          Positioned(
            top: 220,
            left: position.dx + size.width / 2 - 125,
            right: 50,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 350,
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
                child: const Text(
                  "Initiate route & wait for 1 hour to give user time to book a seat in the same car with the same captain.",
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
        const Text(
          'Welcome to Captain Share!',
          style: TextStyle(
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
            decoration: const BoxDecoration(
              color: AppColors.PRIMARY_COLOR,
              shape: BoxShape.circle,
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
