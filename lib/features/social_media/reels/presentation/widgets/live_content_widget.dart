import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/live_card_widget.dart';

class LiveContentWidget extends StatelessWidget {
  const LiveContentWidget({super.key});
  final List<String> videoUrls = const [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  ];
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 8,
          childAspectRatio: 9 / 20,
        ),
        itemBuilder: (context, index) =>
            LiveCardWidget(videoUrl: videoUrls[index]),
        itemCount: videoUrls.length,
      ),
    );
  }
}
