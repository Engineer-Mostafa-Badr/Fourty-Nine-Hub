import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../res/style/app_colors.dart';
import '../../../../../helpers/manage_vibration.dart';

class HelpTooltip extends StatefulWidget {
  final String message;
  final double width;

  const HelpTooltip({
    super.key,
    required this.message,
    this.width = 300,
  });

  @override
  State<HelpTooltip> createState() => _HelpTooltipState();
}

class _HelpTooltipState extends State<HelpTooltip> {
  OverlayEntry? _overlayEntry;
  bool _isTooltipVisible = false;
  final LayerLink _layerLink = LayerLink();

  @override
  void dispose() {
    _removeTooltip();
    super.dispose();
  }

  void _removeTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isTooltipVisible = false;
  }

  void _showTooltip(BuildContext context) {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    _isTooltipVisible = true;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          width: widget.width,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: Offset(-(widget.width - 10.w), 45.h),
            child: Material(
              elevation: 4.0,
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.message,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
      ManageVibration.vibrate();
          if (_isTooltipVisible) {
            _removeTooltip();
          } else {
            _showTooltip(context);
          }
        },
        child: Container(
          width: 50.w,
          height: 50.h,
          decoration:  BoxDecoration(
           // shape: BoxShape.rectangle,
           borderRadius: BorderRadius.circular(10),
            color: AppColors.PRIMARY_COLOR,
          ),
          child:  Center(
            child: Text(
              '?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}