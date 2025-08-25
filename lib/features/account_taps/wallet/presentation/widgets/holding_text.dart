import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

/// Drop-in animated text that can blink, pulse, glow, or shimmer.
///
/// Example usage:
/// ```dart
/// AnimatedFancyText(
///   'Hello',
///   mode: FancyTextMode.shimmer,
///   textStyle: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
///   baseColor: Colors.white,
///   highlightColor: Colors.amber,
/// )
/// ```
class AnimatedFancyText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration duration;
  final Curve curve;
  final bool autoStart;
  final FancyTextMode mode;
  final Color baseColor;
  final Color highlightColor;
  final Color glowColor;
  final double minOpacity;
  final double maxOpacity;
  final double minScale;
  final double maxScale;
  final double minGlowBlur;
  final double maxGlowBlur;

  const AnimatedFancyText(
      this.text, {
        super.key,
        this.textStyle,
        this.duration = const Duration(seconds: 2),
        this.curve = Curves.easeInOut,
        this.autoStart = true,
        this.mode = FancyTextMode.blink,
        this.baseColor = Colors.white,
        this.highlightColor = const Color(0xFFFFF176), // light yellow
        this.glowColor = const Color(0xFF00E5FF), // cyan
        this.minOpacity = 0.35,
        this.maxOpacity = 1.0,
        this.minScale = 0.98,
        this.maxScale = 1.04,
        this.minGlowBlur = 2,
        this.maxGlowBlur = 18,
      });

  @override
  State<AnimatedFancyText> createState() => _AnimatedFancyTextState();
}

class _AnimatedFancyTextState extends State<AnimatedFancyText>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);

    final curve = CurvedAnimation(parent: _ctrl, curve: widget.curve);
    _anim = Tween<double>(begin: 0, end: 1).animate(curve);

    if (widget.autoStart) {
      switch (widget.mode) {
        case FancyTextMode.shimmer:
          _ctrl.repeat();
          break;
        default:
          _ctrl.repeat(reverse: true);
      }
    }
  }

  @override
  void didUpdateWidget(covariant AnimatedFancyText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _ctrl.duration = widget.duration;
    }
    if (oldWidget.mode != widget.mode) {
      _ctrl.reset();
      if (widget.autoStart) {
        switch (widget.mode) {
          case FancyTextMode.shimmer:
            _ctrl.repeat();
            break;
          default:
            _ctrl.repeat(reverse: true);
        }
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        switch (widget.mode) {
          case FancyTextMode.blink:
            final opacity = lerpDouble(widget.minOpacity, widget.maxOpacity, _anim.value)!;
            return Opacity(
              opacity: opacity,
              child: _buildBaseText(),
            );

          case FancyTextMode.pulse:
            final scale = lerpDouble(widget.minScale, widget.maxScale, _anim.value)!;
            return Transform.scale(
              scale: scale,
              alignment: Alignment.center,
              child: _buildBaseText(),
            );

          case FancyTextMode.glow:
            final blur = lerpDouble(widget.minGlowBlur, widget.maxGlowBlur, _anim.value)!;
            final glowOpacity = 0.4 + 0.6 * _anim.value; // 0.4..1.0
            return _buildBaseText(
              overrideStyle: (widget.textStyle ?? const TextStyle()).copyWith(
                shadows: [
                  Shadow(color: widget.glowColor.withOpacity(glowOpacity), blurRadius: blur),
                  Shadow(color: widget.glowColor.withOpacity(glowOpacity * 0.7), blurRadius: blur * 0.6),
                ],
              ),
            );

          case FancyTextMode.shimmer:
            return _buildShimmerText(_anim.value);
        }
      },
    );
  }

  Widget _buildBaseText({TextStyle? overrideStyle}) {
    return Text(
      widget.text,
      style: (widget.textStyle ?? const TextStyle(fontSize: 24)).copyWith(
        color: widget.baseColor,
      ).merge(overrideStyle),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildShimmerText(double t) {
    // Slide a bright band across the text using a ShaderMask.
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        final width = bounds.width;
        // We create a shader rect that is wider than the text and slide it.
        final slide = (t * 2.0 - 0.5) * width; // from -0.5w .. 1.5w
        final rect = Rect.fromLTWH(-width + slide, 0, width * 3, bounds.height);
        const bandWidth = 0.2; // thickness of the bright band

        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            widget.baseColor.withOpacity(0.3),
            widget.baseColor.withOpacity(0.6),
            widget.highlightColor,
            widget.baseColor.withOpacity(0.6),
            widget.baseColor.withOpacity(0.3),
          ],
          stops: const [0.0, 0.4 - bandWidth, 0.5, 0.6 + bandWidth, 1.0],
          tileMode: TileMode.clamp,
        ).createShader(rect);
      },
      child: _buildBaseText(
        overrideStyle: (widget.textStyle ?? const TextStyle()).copyWith(
          // baseColor here acts as the base for mask (actual color is provided by shader)
          color: Colors.white,
        ),
      ),
    );
  }
}

enum FancyTextMode { blink, pulse, glow, shimmer }

/// Quick demo widget to try all modes.
class FancyTextDemo extends StatelessWidget {
  const FancyTextDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1220),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            AnimatedFancyText(
              'Blink',
              mode: FancyTextMode.blink,
              textStyle: TextStyle(fontSize: 38, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            AnimatedFancyText(
              'Pulse',
              mode: FancyTextMode.pulse,
              textStyle: TextStyle(fontSize: 38, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            AnimatedFancyText(
              'Glow',
              mode: FancyTextMode.glow,
              glowColor: Colors.cyanAccent,
              textStyle: TextStyle(fontSize: 38, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 16),
            AnimatedFancyText(
              'Shimmer',
              mode: FancyTextMode.shimmer,
              baseColor: Colors.white,
              highlightColor: Colors.amber,
              textStyle: TextStyle(fontSize: 38, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
