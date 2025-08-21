import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../core/widget/olx_pagination/banner.dart';
import '../../../core/widget/olx_pagination/olx_pagination_widget.dart';
import '../../utils/flutter_markdown.dart';


@widgetbook.UseCase(
  name: 'OlxPaginationWidget Documentation',
  type: MarkdownViewer,
)
MarkdownViewer olxPaginationWidgetDocumentation(BuildContext context) {
  return const MarkdownViewer(
    markdownFilePath: 'assets/markdown/docs/olx_pagination_widget_doc.md',
  );
}

@widgetbook.UseCase(
  name: 'OlxPaginationWidget Basic Demo',
  type: OlxPaginationWidget,
)
Widget olxPaginationWidgetBasicDemo(BuildContext context) {
  final itemsPerPage = context.knobs.int.slider(
    label: 'Items Per Page',
    initialValue: 5,
    min: 3,
    max: 15,
  );

  final totalItems = context.knobs.int.slider(
    label: 'Total Items',
    initialValue: 50,
    min: 10,
    max: 200,
  );

  final loadingDelay = context.knobs.double.slider(
    label: 'Loading Delay (seconds)',
    initialValue: 1.0,
    min: 0.5,
    max: 3.0,
  );

  // Generate mock items
  final List<Widget> items = List.generate(
    totalItems,
    (index) => Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text('${index + 1}'),
        ),
        title: Text('Item ${index + 1}'),
        subtitle: Text('Description for item ${index + 1}'),
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    ),
  );

  Future<void> mockLoadPage(int page) async {
    await Future.delayed(Duration(milliseconds: (loadingDelay * 1000).toInt()));
    // Simulate loading more items
  }

  return Scaffold(
    appBar: AppBar(
      title: const Text('OLX Pagination - Basic Demo'),
      backgroundColor: Colors.green,
    ),
    body: OlxPaginationWidget(
      items: items,
      banners: bannersList,
      itemsPerPage: itemsPerPage,
      scrollController: ScrollController(),
      loadPage: mockLoadPage,
    ),
  );
}

@widgetbook.UseCase(
  name: 'OlxPaginationWidget Advanced Demo',
  type: OlxPaginationWidget,
)
Widget olxPaginationWidgetAdvancedDemo(BuildContext context) {
  final itemsPerPage = context.knobs.int.slider(
    label: 'Items Per Page',
    initialValue: 8,
    min: 5,
    max: 20,
  );

  final cardStyle = context.knobs.list(
    label: 'Card Style',
    options: ['Simple', 'Detailed', 'Grid-like'],
    initialOption: 'Detailed',
  );

  final bannerStyle = context.knobs.list(
    label: 'Banner Style',
    options: ['Image Only', 'Video Only', 'Mixed'],
    initialOption: 'Mixed',
  );

  // Generate different types of items based on selection
  Widget buildItem(int index) {
    switch (cardStyle) {
      case 'Simple':
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.image, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product ${index + 1}', 
                           style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('\$${(index + 1) * 10}', 
                           style: const TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

      case 'Grid-like':
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Center(
                  child: Icon(Icons.image, size: 40, color: Colors.grey[600]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Product ${index + 1}', 
                         style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Category: Electronics'),
                    Text('\$${(index + 1) * 15}', 
                         style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        );

      default: // Detailed
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.image, size: 30, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Product ${index + 1}', 
                           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('Description for product ${index + 1}', 
                           style: TextStyle(color: Colors.grey[600])),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text('\$${(index + 1) * 12}', 
                               style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          const Spacer(),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                              Text('City ${(index % 5) + 1}', style: TextStyle(color: Colors.grey[600])),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.favorite_border),
              ],
            ),
          ),
        );
    }
  }

  // Generate different banners based on selection
  List<BannerAdsModel> getBanners() {
    switch (bannerStyle) {
      case 'Image Only':
        return [
          BannerAdsModel(imageUrl: 'https://i.imgur.com/QCNbOAo.png'),
          BannerAdsModel(imageUrl: 'https://via.placeholder.com/800x200/FF6B6B/FFFFFF?text=Banner+2'),
          BannerAdsModel(imageUrl: 'https://via.placeholder.com/800x200/4ECDC4/FFFFFF?text=Banner+3'),
        ];
      case 'Video Only':
        return [
          BannerAdsModel(videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
          BannerAdsModel(videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
        ];
      default: // Mixed
        return bannersList;
    }
  }

  final List<Widget> items = List.generate(100, buildItem);

  Future<void> mockLoadPage(int page) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  return Scaffold(
    appBar: AppBar(
      title: const Text('OLX Pagination - Advanced Demo'),
      backgroundColor: Colors.green,
    ),
    body: OlxPaginationWidget(
      items: items,
      banners: getBanners(),
      itemsPerPage: itemsPerPage,
      scrollController: ScrollController(),
      loadPage: mockLoadPage,
    ),
  );
}

@widgetbook.UseCase(
  name: 'OlxPaginationWidget Performance Demo',
  type: OlxPaginationWidget,
)
Widget olxPaginationWidgetPerformanceDemo(BuildContext context) {
  final itemsPerPage = context.knobs.int.slider(
    label: 'Items Per Page',
    initialValue: 10,
    min: 5,
    max: 50,
  );

  final simulateSlowLoading = context.knobs.boolean(
    label: 'Simulate Slow Loading',
    initialValue: false,
  );

  final showImagePlaceholders = context.knobs.boolean(
    label: 'Show Image Placeholders',
    initialValue: true,
  );

  Widget buildPerformanceItem(int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            if (showImagePlaceholders)
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image),
              )
            else
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Item ${index + 1}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Generated at ${DateTime.now().toString().substring(11, 19)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: (index % 10) / 10,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation(Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  final List<Widget> items = List.generate(500, buildPerformanceItem);

  Future<void> mockLoadPage(int page) async {
    if (simulateSlowLoading) {
      await Future.delayed(const Duration(seconds: 2));
    } else {
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  return Scaffold(
    appBar: AppBar(
      title: const Text('OLX Pagination - Performance Demo'),
      backgroundColor: Colors.green,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              '${items.length} items',
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
      ],
    ),
    body: OlxPaginationWidget(
      items: items,
      banners: bannersList,
      itemsPerPage: itemsPerPage,
      scrollController: ScrollController(),
      loadPage: mockLoadPage,
    ),
  );
}