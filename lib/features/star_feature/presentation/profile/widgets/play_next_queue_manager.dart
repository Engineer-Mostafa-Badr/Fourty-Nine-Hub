import 'package:flutter/foundation.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';

/// Play Next Queue Manager
/// Manages a queue of videos to be played next
class PlayNextQueueManager extends ChangeNotifier {
  static final PlayNextQueueManager _instance = PlayNextQueueManager._internal();

  factory PlayNextQueueManager() {
    return _instance;
  }

  PlayNextQueueManager._internal();

  // Queue of videos to play next
  final List<StarEntity> _queue = [];

  // Currently playing video
  StarEntity? _currentVideo;

  // Getters
  List<StarEntity> get queue => List.unmodifiable(_queue);
  StarEntity? get currentVideo => _currentVideo;
  bool get hasNext => _queue.isNotEmpty;
  int get queueLength => _queue.length;

  /// Add a video to play next (insert at the beginning of queue)
  void addToPlayNext(StarEntity video) {
    // Check if video already exists in queue
    if (_queue.any((v) => v.id == video.id)) {
      debugPrint('🎵 Video already in queue: ${video.title}');
      return;
    }

    // Insert at the beginning of the queue
    _queue.insert(0, video);
    debugPrint('🎵 Added to play next queue: ${video.title}');
    debugPrint('🎵 Queue length: ${_queue.length}');
    notifyListeners();
  }

  /// Add multiple videos to play next
  void addMultipleToPlayNext(List<StarEntity> videos) {
    for (final video in videos.reversed) {
      if (!_queue.any((v) => v.id == video.id)) {
        _queue.insert(0, video);
      }
    }
    debugPrint('🎵 Added ${videos.length} videos to play next queue');
    debugPrint('🎵 Total queue length: ${_queue.length}');
    notifyListeners();
  }

  /// Add a video to the end of the queue
  void addToQueue(StarEntity video) {
    if (_queue.any((v) => v.id == video.id)) {
      debugPrint('🎵 Video already in queue: ${video.title}');
      return;
    }

    _queue.add(video);
    debugPrint('🎵 Added to end of queue: ${video.title}');
    notifyListeners();
  }

  /// Get the next video in the queue
  StarEntity? getNextVideo() {
    if (_queue.isEmpty) {
      debugPrint('🎵 Queue is empty, no next video');
      return null;
    }

    final nextVideo = _queue.removeAt(0);
    _currentVideo = nextVideo;
    debugPrint('🎵 Playing next from queue: ${nextVideo.title}');
    debugPrint('🎵 Remaining in queue: ${_queue.length}');
    notifyListeners();
    return nextVideo;
  }

  /// Peek at the next video without removing it
  StarEntity? peekNext() {
    if (_queue.isEmpty) return null;
    return _queue.first;
  }

  /// Remove a video from the queue
  void removeFromQueue(String videoId) {
    final initialLength = _queue.length;
    _queue.removeWhere((video) => video.id == videoId);
    if (_queue.length < initialLength) {
      debugPrint('🎵 Removed video from queue: $videoId');
      notifyListeners();
    }
  }

  /// Clear the entire queue
  void clearQueue() {
    _queue.clear();
    debugPrint('🎵 Queue cleared');
    notifyListeners();
  }

  /// Set the current video
  void setCurrentVideo(StarEntity video) {
    _currentVideo = video;
    notifyListeners();
  }

  /// Check if a video is in the queue
  bool isInQueue(String videoId) {
    return _queue.any((video) => video.id == videoId);
  }

  /// Get queue position of a video (returns -1 if not in queue)
  int getQueuePosition(String videoId) {
    return _queue.indexWhere((video) => video.id == videoId);
  }

  /// Move a video to a different position in the queue
  void reorderQueue(int oldIndex, int newIndex) {
    if (oldIndex < _queue.length && newIndex < _queue.length) {
      final video = _queue.removeAt(oldIndex);
      _queue.insert(newIndex, video);
      notifyListeners();
    }
  }

  /// Get queue summary for debugging
  String getQueueSummary() {
    if (_queue.isEmpty) return 'Queue is empty';

    final summary = StringBuffer('Play Next Queue (${_queue.length} videos):\n');
    for (int i = 0; i < _queue.length; i++) {
      summary.writeln('  ${i + 1}. ${_queue[i].title}');
    }
    return summary.toString();
  }
}
