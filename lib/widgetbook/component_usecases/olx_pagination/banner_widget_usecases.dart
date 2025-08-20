import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../core/widget/olx_pagination/banner.dart';
import '../../utils/flutter_markdown.dart';


@widgetbook.UseCase(
  name: 'BannerAdsWidget Documentation',
  type: MarkdownViewer,
)
MarkdownViewer bannerAdsWidgetDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/banner_ads_widget_doc.md',
  );
}

@widgetbook.UseCase(
  name: 'BannerAdsWidget with Image',
  type: BannerAdsWidget,
)
Widget bannerAdsWidgetWithImage(BuildContext context) {
  final imageUrl = context.knobs.string(
    label: 'Image URL',
    initialValue: 'https://i.imgur.com/QCNbOAo.png',
  );

  final height = context.knobs.double.slider(
    label: 'Height',
    initialValue: 200.0,
    min: 100.0,
    max: 400.0,
  );

  return Scaffold(
    appBar: AppBar(title: const Text('Banner Ads - Image Demo')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: height,
                width: double.infinity,
                child: BannerAdsWidget(
                  key: const Key('image_banner'),
                  banner: BannerAdsModel(imageUrl: imageUrl),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Image Banner',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            'Height: ${height.toStringAsFixed(0)}px',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'BannerAdsWidget with Video',
  type: BannerAdsWidget,
)
Widget bannerAdsWidgetWithVideo(BuildContext context) {
  final videoUrl = context.knobs.list(
    label: 'Video URL',
    options: [
      'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    ],
    initialOption: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  );

  final height = context.knobs.double.slider(
    label: 'Height',
    initialValue: 250.0,
    min: 150.0,
    max: 400.0,
  );

  final showControls = context.knobs.boolean(
    label: 'Show Video Info',
    initialValue: true,
  );

  return Scaffold(
    appBar: AppBar(title: const Text('Banner Ads - Video Demo')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: height,
                width: double.infinity,
                child: BannerAdsWidget(
                  key: const Key('video_banner'),
                  banner: BannerAdsModel(videoUrl: videoUrl),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (showControls) ...[
            Text(
              'Video Banner',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              'Height: ${height.toStringAsFixed(0)}px',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                'Video plays automatically with visibility detection and loops continuously',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'BannerAdsWidget with Image & Video Fallback',
  type: BannerAdsWidget,
)
Widget bannerAdsWidgetWithImageAndVideo(BuildContext context) {
  final imageUrl = context.knobs.string(
    label: 'Image URL',
    initialValue: 'https://i.imgur.com/QCNbOAo.png',
  );

  final videoUrl = context.knobs.string(
    label: 'Video URL',
    initialValue: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  );

  final height = context.knobs.double.slider(
    label: 'Height',
    initialValue: 300.0,
    min: 150.0,
    max: 500.0,
  );

  return Scaffold(
    appBar: AppBar(title: const Text('Banner Ads - Image + Video Demo')),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: height,
                width: double.infinity,
                child: BannerAdsWidget(
                  key: const Key('combined_banner'),
                  banner: BannerAdsModel(
                    imageUrl: imageUrl,
                    videoUrl: videoUrl,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Combined Banner (Image + Video)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Text(
            'Height: ${height.toStringAsFixed(0)}px',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              'Shows image as background while video loads, then overlays video when ready',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'BannerAdsWidget List Demo',
  type: BannerAdsWidget,
)
Widget bannerAdsWidgetListDemo(BuildContext context) {
  final itemCount = context.knobs.int.slider(
    label: 'Number of Banners',
    initialValue: 3,
    min: 1,
    max: 10,
  );

  final bannerHeight = context.knobs.double.slider(
    label: 'Banner Height',
    initialValue: 180.0,
    min: 120.0,
    max: 300.0,
  );

  return Scaffold(
    appBar: AppBar(title: const Text('Banner Ads - List Demo')),
    body: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final banner = bannersList[index % bannersList.length];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Card(
            elevation: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: bannerHeight,
                child: BannerAdsWidget(
                  key: Key('banner_$index'),
                  banner: banner,
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}