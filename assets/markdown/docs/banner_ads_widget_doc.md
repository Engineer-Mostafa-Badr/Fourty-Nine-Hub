# BannerAdsWidget Documentation

## Overview

The `BannerAdsWidget` is a flexible Flutter widget designed to display banner advertisements with support for both image and video content. It provides automatic video playback management, visibility detection for performance optimization, and seamless content switching.

## Features

- **Multi-format Support**: Displays both image and video banners
- **Automatic Video Management**: Auto-plays/pauses videos based on visibility
- **Loading States**: Shows loading indicators during video initialization
- **Performance Optimized**: Uses visibility detection to manage video playback
- **Responsive Design**: Adapts to container dimensions with proper aspect ratios

## Widget Structure

### BannerAdsModel
```dart
class BannerAdsModel {
  final String? imageUrl;
  final String? videoUrl;
  
  BannerAdsModel({this.imageUrl, this.videoUrl});
}
```

### BannerAdsWidget
```dart
class BannerAdsWidget extends StatefulWidget {
  final BannerAdsModel banner;
  
  const BannerAdsWidget({super.key, required this.banner});
}
```

## Usage Examples

### Basic Image Banner
```dart
BannerAdsWidget(
  banner: BannerAdsModel(
    imageUrl: 'https://example.com/banner.jpg',
  ),
)
```

### Video Banner
```dart
BannerAdsWidget(
  banner: BannerAdsModel(
    videoUrl: 'https://example.com/video.mp4',
  ),
)
```

### Combined Image + Video Banner
```dart
BannerAdsWidget(
  banner: BannerAdsModel(
    imageUrl: 'https://example.com/fallback.jpg',
    videoUrl: 'https://example.com/video.mp4',
  ),
)
```

## Key Features

### 1. Visibility Detection
- Automatically plays video when banner is >50% visible
- Pauses video when banner goes out of view
- Optimizes performance and battery usage

### 2. Video Management
- Automatic looping for video content
- Muted playback by default
- Loading indicators during initialization

### 3. Fallback Support
- Shows image while video loads
- Graceful handling of failed video loads
- Seamless content switching

### 4. Visual Enhancements
- Semi-transparent overlay for better text readability
- Proper aspect ratio handling
- Stack-based content layering

## Implementation Details

### Video Initialization
```dart
_controller = VideoPlayerController.network(widget.banner.videoUrl!)
  ..setLooping(true)
  ..setVolume(0.0)
  ..initialize().then((_) {
    if (mounted) setState(() {});
    _controller!.play();
  });
```

### Visibility Handling
```dart
VisibilityDetector(
  key: widget.key!,
  onVisibilityChanged: (info) {
    final visible = info.visibleFraction > 0.5;
    if (visible) {
      _controller?.play();
    } else {
      _controller?.pause();
    }
  },
  child: _buildContent(),
)
```

## Best Practices

### Performance
1. Use unique keys for each banner instance
2. Dispose of video controllers properly
3. Monitor visibility for automatic playback control

### Content Guidelines
1. Use optimized video formats (MP4 recommended)
2. Keep video file sizes reasonable for mobile
3. Provide fallback images for better UX

### Accessibility
1. Ensure sufficient contrast for any overlay text
2. Consider autoplay policies for video content
3. Test with various screen sizes and orientations

## Dependencies

- `flutter/material.dart`: Core Flutter widgets
- `video_player`: Video playback functionality
- `visibility_detector`: Viewport visibility detection

## Common Issues & Solutions

### Video Not Playing
- Ensure video URL is accessible and valid
- Check network connectivity
- Verify video format compatibility

### Performance Issues
- Use visibility detection to manage playback
- Optimize video file sizes
- Consider lazy loading for multiple banners

### Layout Issues
- Use proper constraints and aspect ratios
- Test on different screen sizes
- Ensure proper disposal of controllers

## Widget Lifecycle

1. **Initialization**: Check for video URL and create controller
2. **Loading**: Show loading indicator while video initializes
3. **Content Display**: Show image and/or video content
4. **Visibility Management**: Auto-play/pause based on visibility
5. **Disposal**: Clean up video controller resources