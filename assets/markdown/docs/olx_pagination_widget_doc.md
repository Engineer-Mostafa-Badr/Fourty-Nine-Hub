# OlxPaginationWidget Documentation

## Overview

The `OlxPaginationWidget` is a sophisticated pagination widget designed for OLX-style marketplace applications. It provides infinite scroll functionality with integrated banner advertisements between pages, lazy loading capabilities, and smooth user experience with loading states.

## Features

- **Infinite Scroll Pagination**: Automatically loads more content as user scrolls
- **Integrated Banner Ads**: Displays full-screen banners between pages
- **Lazy Loading**: Loads content on-demand to optimize performance
- **Loading States**: Shows loading indicators during data fetching
- **Customizable Page Size**: Configurable items per page
- **Scroll Management**: External scroll controller support

## Widget Structure

```dart
class OlxPaginationWidget extends StatefulWidget {
  final List<Widget> items;
  final List<BannerAdsModel> banners;
  final int itemsPerPage;
  final ScrollController scrollController;
  final Future<void> Function(int) loadPage;
  
  const OlxPaginationWidget({
    super.key,
    required this.items,
    required this.banners,
    required this.loadPage,
    required this.scrollController,
    this.itemsPerPage = 10,
  });
}
```

## Parameters

### Required Parameters

- **`items`**: List of widgets to display in paginated format
- **`banners`**: List of banner ads to show between pages
- **`loadPage`**: Callback function for loading new pages
- **`scrollController`**: External scroll controller for scroll management

### Optional Parameters

- **`itemsPerPage`**: Number of items per page (default: 10)

## Usage Examples

### Basic Implementation
```dart
OlxPaginationWidget(
  items: productWidgets,
  banners: bannerAds,
  itemsPerPage: 15,
  scrollController: _scrollController,
  loadPage: (page) async {
    // Load data for the specified page
    await loadProducts(page);
  },
)
```

### With Custom Banners
```dart
final customBanners = [
  BannerAdsModel(imageUrl: 'https://example.com/ad1.jpg'),
  BannerAdsModel(videoUrl: 'https://example.com/ad2.mp4'),
  BannerAdsModel(
    imageUrl: 'https://example.com/fallback.jpg',
    videoUrl: 'https://example.com/ad3.mp4',
  ),
];

OlxPaginationWidget(
  items: items,
  banners: customBanners,
  itemsPerPage: 8,
  scrollController: scrollController,
  loadPage: loadPageCallback,
)
```

## Implementation Details

### Scroll Detection
The widget automatically detects when the user approaches the bottom of the content:

```dart
void _scrollListener() {
  if (widget.scrollController.position.pixels >=
      widget.scrollController.position.maxScrollExtent - 100 &&
      !_isLoading) {
    _loadNextPage();
  }
}
```

### Page Structure
- **First Page**: Shows initial items without banner
- **Subsequent Pages**: Each page is preceded by a full-screen banner
- **Loading States**: Loading indicators between pages

### Banner Integration
```dart
SliverAppBar(
  automaticallyImplyLeading: false,
  pinned: false,
  expandedHeight: screenHeight,
  flexibleSpace: BannerAdsWidget(
    key: Key('banner_$page'),
    banner: widget.banners[(page - 1) % widget.banners.length],
  ),
),
```

## Lifecycle Management

### Initialization
1. Sets up scroll listener
2. Loads initial page if items are empty
3. Configures pagination state

### Scroll Handling
1. Monitors scroll position
2. Triggers page loading when near bottom
3. Manages loading states