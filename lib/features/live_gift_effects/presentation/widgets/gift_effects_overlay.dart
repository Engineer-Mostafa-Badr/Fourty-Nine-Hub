import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../live_gift_effects/controller/gift_effects_controller.dart';
import '../../../live_gift_effects/models/gift_effect.dart';

class GiftEffectsOverlay extends StatefulWidget {
  final GiftEffectsController controller;

  const GiftEffectsOverlay({super.key, required this.controller});

  @override
  State<GiftEffectsOverlay> createState() => _GiftEffectsOverlayState();
}

class _GiftEffectsOverlayState extends State<GiftEffectsOverlay> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onUpdate);
  }

  @override
  void didUpdateWidget(covariant GiftEffectsOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onUpdate);
      widget.controller.addListener(_onUpdate);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final GiftEffect? effect = widget.controller.current;
    if (effect == null) return const SizedBox.shrink();

    final Widget content;
    switch (effect.sourceType) {
      case GiftEffectSourceType.asset:
        content = Lottie.asset(
          effect.sourcePath,
          width: effect.size.width,
          height: effect.size.height,
          fit: BoxFit.contain,
          repeat: true,
        );
        break;
      case GiftEffectSourceType.network:
        content = Lottie.network(
          effect.sourcePath,
          width: effect.size.width,
          height: effect.size.height,
          fit: BoxFit.contain,
          repeat: true,
        );
        break;
    }

    return IgnorePointer(
      ignoring: true,
      child: Align(
        alignment: effect.alignment,
        child: content,
      ),
    );
  }
}



