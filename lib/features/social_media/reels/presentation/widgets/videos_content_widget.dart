import 'package:flutter/material.dart';
import 'video_card_widget.dart';

class VideosContentWidget extends StatefulWidget {
  const VideosContentWidget({super.key});

  @override
  State<VideosContentWidget> createState() => _VideosContentWidgetState();
}

class _VideosContentWidgetState extends State<VideosContentWidget> {
  final List<String> videoUrls = const [
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  ];

  //int playingIndex = 0; // اول فيديو بس اللي هيشتغل

  // void _onVideoTap(int index) {
  //   if (playingIndex != index) {
  //     setState(() {
  //       playingIndex = index;
  //     });
  //   }
  // }

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
        itemCount: videoUrls.length,
        itemBuilder: (context, index) {
          return VideoCardWidget(
            videoUrl: videoUrls[index],
            play: true,
          );
        },
      ),
    );
  }
}
