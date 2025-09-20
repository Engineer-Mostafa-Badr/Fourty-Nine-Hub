# Video Player Components

This directory contains modular video player components that were refactored from the original `youtube_style_video_player.dart` file.

## Components

### 1. `talent_video_player.dart`
**Main video player widget**
- Handles video initialization with fallback strategies
- Manages fullscreen mode
- Integrates all other components
- Handles system UI changes

**Usage:**
```dart
TalentVideoPlayer(
  videoUrl: 'https://example.com/video.m3u8',
  talent: starEntity,
  starCubit: starCubit,
  commentCubit: commentCubit,
)
```

### 2. `video_player_controls.dart`
**Video control overlay widget**
- Play/pause/seek controls
- Volume and fullscreen toggles
- Progress bar with drag support
- Auto-hide functionality

**Features:**
- Responsive design
- Touch-friendly controls
- Keyboard accessibility
- Custom styling support

### 3. `video_info_section.dart`
**Video information and actions widget**
- Video title, views, and date
- Like/Dislike buttons with real-time updates
- Channel information
- Description with expand/collapse
- Action buttons (share, download, etc.)

**Features:**
- Real-time like/dislike updates using BlocBuilder
- Optimistic UI updates
- Dark/light theme support
- Localization support

### 4. `comments_modal.dart`
**Comments section as modal bottom sheet**
- Comments list with pagination
- Add new comment functionality
- Like/dislike comments
- User profile integration

**Features:**
- Infinite scroll loading
- Real-time comment updates
- User interaction (like/dislike)
- Report/block functionality

### 5. `floating_video_player.dart`
**Picture-in-picture style floating player**
- Draggable mini player
- Continue playback while browsing
- Quick controls overlay
- Expand to fullscreen

**Usage:**
```dart
// Show floating player
FloatingVideoPlayerService.show(
  controller: videoController,
  title: 'Video Title',
  videoUrl: videoUrl,
  isPlaying: true,
);

// Hide floating player
FloatingVideoPlayerService.hide();
```

### 6. `video_player_utils.dart`
**Utilities and helper functions**
- Video initialization strategies
- Duration formatting
- Error handling
- Progress calculations
- Quality and speed settings

**Key Classes:**
- `VideoPlayerUtils`: Static utility methods
- `VideoInitializer`: Robust video initialization
- `VideoPlayerStateManager`: Controller management
- `VideoPlayerSettings`: Configuration options

## Architecture Benefits

### 1. **Modularity**
- Each component has a single responsibility
- Easy to test individual components
- Reusable across different video contexts

### 2. **Maintainability**
- Smaller, focused files (200-400 lines each)
- Clear separation of concerns
- Easy to locate and fix issues

### 3. **Scalability**
- New features can be added to specific components
- Components can be extended without affecting others
- Easy to add new video player types

### 4. **Performance**
- Components only rebuild when necessary
- Optimized BlocBuilder usage
- Efficient state management

## Migration from Old Implementation

The original `youtube_style_video_player.dart` (3385 lines) has been split into:

| Component | Lines | Responsibility |
|-----------|-------|----------------|
| `talent_video_player.dart` | ~300 | Main player logic |
| `video_player_controls.dart` | ~250 | Control overlay |
| `video_info_section.dart` | ~300 | Video info & actions |
| `comments_modal.dart` | ~350 | Comments system |
| `floating_video_player.dart` | ~200 | PiP functionality |
| `video_player_utils.dart` | ~400 | Utilities & helpers |

**Total: ~1800 lines** (47% reduction in complexity)

## Usage Examples

### Basic Video Player
```dart
import 'package:your_app/features/star_feature/presentation/widgets/video_player/index.dart';

TalentVideoPlayer(
  videoUrl: videoUrl,
  talent: talent,
)
```

### With Custom Cubits
```dart
TalentVideoPlayer(
  videoUrl: videoUrl,
  talent: talent,
  starCubit: customStarCubit,
  commentCubit: customCommentCubit,
)
```

### Show Comments Modal
```dart
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (context) => CommentsModal(
    videoId: videoId,
    onAddComment: (content) {
      // Handle comment addition
    },
  ),
);
```

## Future Enhancements

1. **Video Quality Selection**
2. **Playback Speed Controls**
3. **Subtitle Support**
4. **Offline Download**
5. **Chromecast Integration**
6. **360° Video Support**
7. **Live Streaming Features**

## Testing

Each component can be tested independently:

```dart
testWidgets('Video controls should show/hide', (tester) async {
  await tester.pumpWidget(
    VideoPlayerControls(
      controller: mockController,
      showControls: true,
      // ... other params
    ),
  );

  expect(find.byIcon(Icons.play_arrow), findsOneWidget);
});
```

## Contributing

When adding new features:

1. Keep components focused and small
2. Use BlocBuilder for state updates
3. Support both dark and light themes
4. Add localization support
5. Include proper error handling
6. Write unit tests for new components