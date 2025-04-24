import 'package:flutter/material.dart';

class AnimatedBottomSheet extends StatefulWidget {
  const AnimatedBottomSheet({
    super.key,
    required this.child,
    this.backgroundColor,
    required this.asAlertDialog,
  });

  final Widget child;
  final Color? backgroundColor;
  final bool asAlertDialog;

  @override
  _AnimatedBottomSheetState createState() => _AnimatedBottomSheetState();
}

class _AnimatedBottomSheetState extends State<AnimatedBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Apply fastEaseInToSlowEaseOut effect
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuad, // Starts fast and slows down
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * 200),
          child: Opacity(
            opacity: _animation.value,
            child: Padding(
              padding: EdgeInsets.all(widget.asAlertDialog ? 16 : 0),
              child: Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor ??
                      Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.vertical(
                      top: const Radius.circular(20),
                      bottom: Radius.circular(widget.asAlertDialog ? 20 : 0)),
                ),
                child: widget.child,
              ),
            ),
          ),
        );
      },
    );
  }
}

bottomSheet({
  required BuildContext context,
  required Widget widget,
  Color? backColor,
  bool isFloating = false,
  bool isScrollControlled = false,
  bool asAlertDialog = false,
  bool isDismissible = true,
  double padding = 16,
}) async {
  await showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AnimatedBottomSheet(
          backgroundColor: backColor,
          asAlertDialog: asAlertDialog,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(padding),
            // margin: const EdgeInsets.all(kToolbarHeight),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(asAlertDialog ? 20 : 0),
                bottomRight: Radius.circular(asAlertDialog ? 20 : 0),
              ),
              color: backColor ?? Theme.of(context).scaffoldBackgroundColor,
            ),
            child: widget,
          ),
        );
      });
}
