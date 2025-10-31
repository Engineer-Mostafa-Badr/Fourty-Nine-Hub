import 'package:flutter/widgets.dart';

enum GiftEffectSourceType {
  asset,
  network,
}

class GiftEffect {
  final String id;
  final String sourcePath;
  final GiftEffectSourceType sourceType;
  final Duration duration;
  final Size size;
  final Alignment alignment;
  final int repeatCount;

  const GiftEffect({
    required this.id,
    required this.sourcePath,
    this.sourceType = GiftEffectSourceType.asset,
    this.duration = const Duration(seconds: 2),
    this.size = const Size(200, 200),
    this.alignment = Alignment.center,
    this.repeatCount = 1,
  });
}



