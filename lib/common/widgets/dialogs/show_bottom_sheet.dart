import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedBottomSheet extends StatefulWidget {
  const AnimatedBottomSheet({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  final Widget child;
  final Color? backgroundColor;

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
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
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
            child: Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor ??
                    Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20.r),
                ),
              ),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

bottomSheet(
    {required BuildContext context,
    required Widget widget,
    Color? backColor,
    bool isFloating = false,
    bool isScrollControlled = false}) async {
  await showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AnimatedBottomSheet(
          backgroundColor: backColor,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(30.w),
            // margin: EdgeInsets.all(kToolbarHeight),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(20.r),
            //     topRight: Radius.circular(20.r),
            //   ),
            //   color: backColor ?? Theme.of(context).scaffoldBackgroundColor,
            // ),
            child: widget,
          ),
        );
        // return Container(
        //   width: double.infinity,
        //   padding: EdgeInsets.all(30.w),
        //   // margin: EdgeInsets.all(kToolbarHeight),
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(20.r),
        //       topRight: Radius.circular(20.r),
        //     ),
        //     color: backColor ?? Theme.of(context).scaffoldBackgroundColor,
        //   ),
        //   child: widget,
        // );
      });
}
