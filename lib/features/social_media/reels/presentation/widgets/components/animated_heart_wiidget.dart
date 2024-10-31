import 'package:flutter/material.dart';

class _AnimatedHeartOverlay extends StatefulWidget {
  final Offset position;
  final IconData icon;
  final double size;
  final Color color;
  final Duration duration;
  final Function(_AnimatedHeartOverlay) onAnimationComplete;

  const _AnimatedHeartOverlay({
    super.key,
    required this.position,
    required this.icon,
    required this.size,
    required this.color,
    required this.duration,
    required this.onAnimationComplete,
  });

  @override
  __AnimatedHeartOverlayState createState() => __AnimatedHeartOverlayState();
}

class __AnimatedHeartOverlayState extends State<_AnimatedHeartOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward().then((_) {
      widget.onAnimationComplete(widget);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - widget.size / 2,
      top: widget.position.dy - widget.size / 2,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Icon(
            widget.icon,
            color: widget.color,
            size: widget.size,
          ),
        ),
      ),
    );
  }
}

class DoubleTapHeart extends StatefulWidget {
  final Widget child;
  final VoidCallback? onDoubleTap;
  final IconData heartIcon;
  final double iconSize;
  final Color iconColor;
  final Duration animationDuration;

  const DoubleTapHeart({
    super.key,
    required this.child,
    this.onDoubleTap,
    this.heartIcon = Icons.favorite,
    this.iconSize = 80.0,
    this.iconColor = Colors.redAccent,
    this.animationDuration = const Duration(milliseconds: 700),
  });

  @override
  _DoubleTapHeartState createState() => _DoubleTapHeartState();
}

class _DoubleTapHeartState extends State<DoubleTapHeart>
    with SingleTickerProviderStateMixin {
  Offset _tapPosition = Offset.zero;
  final List<_AnimatedHeartOverlay> _heartOverlays = [];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: (TapDownDetails details) {
        final renderBox = context.findRenderObject() as RenderBox;
        _tapPosition = renderBox.globalToLocal(details.globalPosition);
      },
      onDoubleTap: () {
        _showHeart();
        if (widget.onDoubleTap != null) {
          widget.onDoubleTap!();
        }
      },
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          widget.child,
          ..._heartOverlays,
        ],
      ),
    );
  }

  void _showHeart() {
    final overlay = _AnimatedHeartOverlay(
      key: UniqueKey(),
      position: _tapPosition,
      icon: widget.heartIcon,
      size: widget.iconSize,
      color: widget.iconColor,
      duration: widget.animationDuration,
      onAnimationComplete: _removeOverlay,
    );

    setState(() {
      _heartOverlays.add(overlay);
    });
  }

  void _removeOverlay(_AnimatedHeartOverlay overlay) {
    setState(() {
      _heartOverlays.remove(overlay);
    });
  }
}