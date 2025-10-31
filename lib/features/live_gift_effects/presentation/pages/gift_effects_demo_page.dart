import 'package:flutter/material.dart';

import '../../../live_gift_effects/controller/gift_effects_controller.dart';
import '../../../live_gift_effects/models/gift_effect.dart';
import '../widgets/gift_effects_overlay.dart';

class GiftEffectsDemoPage extends StatefulWidget {
  const GiftEffectsDemoPage({super.key});

  @override
  State<GiftEffectsDemoPage> createState() => _GiftEffectsDemoPageState();
}

class _GiftEffectsDemoPageState extends State<GiftEffectsDemoPage> {
  late final GiftEffectsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GiftEffectsController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _enqueueSample(String asset, {Alignment alignment = Alignment.center}) {
    _controller.enqueue(
      GiftEffect(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        sourcePath: asset,
        sourceType: GiftEffectSourceType.asset,
        duration: const Duration(seconds: 2),
        size: const Size(240, 240),
        alignment: alignment,
        repeatCount: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gift Effects Demo')),
      body: Stack(
        children: <Widget>[
          ListView(
            padding: const EdgeInsets.all(16),
            children: <Widget>[
              ElevatedButton(
                onPressed: () => _enqueueSample('assets/lottie/angry_reaction.json'),
                child: const Text('Confetti (center)'),
              ),
              ElevatedButton(
                onPressed: () => _enqueueSample(
                  'assets/lottie/like_reaction.json',
                  alignment: Alignment.topCenter,
                ),
                child: const Text('Hearts (top)'),
              ),
              ElevatedButton(
                onPressed: () => _enqueueSample(
                  'assets/lottie/love.json',
                  alignment: Alignment.bottomRight,
                ),
                child: const Text('Gift box (bottom-right)'),
              ),
              const SizedBox(height: 600),
              const Text('Scroll content to simulate live screen...'),
            ],
          ),
          GiftEffectsOverlay(controller: _controller),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _enqueueSample('assets/lottie/sad_reaction.json'),
        label: const Text('Random Gift'),
        icon: const Icon(Icons.auto_awesome),
      ),
    );
  }
}



