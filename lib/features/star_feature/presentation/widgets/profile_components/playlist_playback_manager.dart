import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/user_star_entity.dart';

enum PlaybackMode { sequential, shuffle }

class PlaylistPlaybackManager extends ChangeNotifier {
  // Map to store playlist managers by playlist ID
  static final Map<String, PlaylistPlaybackManager> _instances = {};

  static PlaylistPlaybackManager getInstance(String playlistId) {
    if (!_instances.containsKey(playlistId)) {
      _instances[playlistId] = PlaylistPlaybackManager._(playlistId);
    }
    return _instances[playlistId]!;
  }

  final String playlistId;
  PlaylistPlaybackManager._(this.playlistId);

  List<StarEntity> _originalPlaylist = [];
  List<StarEntity> _currentPlaylist = [];
  int _currentIndex = 0;
  PlaybackMode _playbackMode = PlaybackMode.sequential;
  Duration _currentPosition = Duration.zero;
  bool _isPlaying = false;
  bool _hasAutoStarted = false;

  // Getters
  List<StarEntity> get playlist => _currentPlaylist;
  StarEntity? get currentVideo =>
      _currentPlaylist.isNotEmpty && _currentIndex < _currentPlaylist.length
          ? _currentPlaylist[_currentIndex]
          : null;
  int get currentIndex => _currentIndex;
  PlaybackMode get playbackMode => _playbackMode;
  Duration get currentPosition => _currentPosition;
  bool get isPlaying => _isPlaying;
  bool get hasAutoStarted => _hasAutoStarted;

  // Initialize playlist
  Future<void> initializePlaylist(List<StarEntity> videos) async {
    _originalPlaylist = List.from(videos);
    _currentPlaylist = List.from(videos);

    // Load saved state
    await _loadSavedState();

    // If no saved state and playlist not empty, start from first video
    if (_currentIndex >= _currentPlaylist.length &&
        _currentPlaylist.isNotEmpty) {
      _currentIndex = 0;
    }

    notifyListeners();
  }

  // Toggle playback mode between sequential and shuffle
  void togglePlaybackMode() {
    _playbackMode = _playbackMode == PlaybackMode.sequential
        ? PlaybackMode.shuffle
        : PlaybackMode.sequential;

    if (_playbackMode == PlaybackMode.shuffle) {
      _shufflePlaylist();
    } else {
      _restoreOriginalOrder();
    }

    _saveState();
    notifyListeners();
  }

  // Shuffle the playlist
  void _shufflePlaylist() {
    final currentVideo = this.currentVideo;
    _currentPlaylist.shuffle(Random());

    // Keep current video at current position if it exists
    if (currentVideo != null) {
      final newIndex =
          _currentPlaylist.indexWhere((video) => video.id == currentVideo.id);
      if (newIndex != -1 && newIndex != _currentIndex) {
        // Move current video to current index
        _currentPlaylist.removeAt(newIndex);
        _currentPlaylist.insert(_currentIndex, currentVideo);
      }
    }
  }

  // Restore original order
  void _restoreOriginalOrder() {
    final currentVideo = this.currentVideo;
    _currentPlaylist = List.from(_originalPlaylist);

    // Find current video position in original list
    if (currentVideo != null) {
      _currentIndex =
          _currentPlaylist.indexWhere((video) => video.id == currentVideo.id);
      if (_currentIndex == -1) _currentIndex = 0;
    }
  }

  // Play specific video by ID
  void playVideo(String videoId) {
    final index = _currentPlaylist.indexWhere((video) => video.id == videoId);
    if (index != -1) {
      _currentIndex = index;
      _currentPosition = Duration.zero;
      _isPlaying = true;
      _hasAutoStarted = true;
      _saveState();
      notifyListeners();
    }
  }

  // Play next video
  void playNext() {
    if (_currentPlaylist.isEmpty) return;

    _currentIndex = (_currentIndex + 1) % _currentPlaylist.length;
    _currentPosition = Duration.zero;
    _isPlaying = true;
    _saveState();
    notifyListeners();
  }

  // Play previous video
  void playPrevious() {
    if (_currentPlaylist.isEmpty) return;

    _currentIndex =
        (_currentIndex - 1 + _currentPlaylist.length) % _currentPlaylist.length;
    _currentPosition = Duration.zero;
    _isPlaying = true;
    _saveState();
    notifyListeners();
  }

  // Update playback state
  void updatePlaybackState({bool? isPlaying, Duration? position}) {
    if (isPlaying != null) _isPlaying = isPlaying;
    if (position != null) _currentPosition = position;
    notifyListeners();

    // Save state periodically
    _saveState();
  }

  // Auto-start first video if not started yet
  void autoStartIfNeeded() {
    if (!_hasAutoStarted && _currentPlaylist.isNotEmpty) {
      _isPlaying = true;
      _hasAutoStarted = true;
      _saveState();
      notifyListeners();
    }
  }

  // Reset auto-start flag (for testing or manual reset)
  void resetAutoStart() {
    _hasAutoStarted = false;
    _saveState();
    notifyListeners();
  }

  // Check if video is currently playing
  bool isVideoPlaying(String videoId) {
    return currentVideo?.id == videoId && _isPlaying;
  }

  // Check if video is current (regardless of playing state)
  bool isCurrentVideo(String videoId) {
    return currentVideo?.id == videoId;
  }

  // Save state to SharedPreferences
  Future<void> _saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'playlist_${playlistId}';

      if (currentVideo != null) {
        await prefs.setString('${key}_current_video_id', currentVideo!.id);
        await prefs.setInt('${key}_current_index', _currentIndex);
        await prefs.setInt('${key}_position_ms', _currentPosition.inMilliseconds);
        await prefs.setBool('${key}_is_playing', _isPlaying);
        await prefs.setBool('${key}_has_auto_started', _hasAutoStarted);
        await prefs.setString('${key}_playback_mode', _playbackMode.toString());

        // Save playlist order for shuffle mode
        final playlistIds = _currentPlaylist.map((video) => video.id).toList();
        await prefs.setStringList('${key}_playlist_order', playlistIds);
      }
    } catch (e) {
      debugPrint('Failed to save playlist state: $e');
    }
  }

  // Load state from SharedPreferences
  Future<void> _loadSavedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'playlist_${playlistId}';

      final savedVideoId = prefs.getString('${key}_current_video_id');
      final savedIndex = prefs.getInt('${key}_current_index') ?? 0;
      final savedPositionMs = prefs.getInt('${key}_position_ms') ?? 0;
      final savedIsPlaying = prefs.getBool('${key}_is_playing') ?? false;
      final savedHasAutoStarted = prefs.getBool('${key}_has_auto_started') ?? false;
      final savedPlaybackModeStr = prefs.getString('${key}_playback_mode');
      final savedPlaylistOrder = prefs.getStringList('${key}_playlist_order');

      // Restore playback mode
      if (savedPlaybackModeStr != null) {
        _playbackMode = savedPlaybackModeStr == 'PlaybackMode.shuffle'
            ? PlaybackMode.shuffle
            : PlaybackMode.sequential;
      }

      // Restore playlist order for shuffle mode
      if (_playbackMode == PlaybackMode.shuffle &&
          savedPlaylistOrder != null &&
          savedPlaylistOrder.isNotEmpty) {
        final reorderedPlaylist = <StarEntity>[];
        for (final videoId in savedPlaylistOrder) {
          final video = _originalPlaylist.firstWhere(
            (v) => v.id == videoId,
            orElse: () => _createEmptyStarEntity(),
          );
          if (video.id.isNotEmpty) {
            reorderedPlaylist.add(video);
          }
        }

        // Add any new videos that weren't in the saved order
        for (final video in _originalPlaylist) {
          if (!reorderedPlaylist.any((v) => v.id == video.id)) {
            reorderedPlaylist.add(video);
          }
        }

        _currentPlaylist = reorderedPlaylist;
      }

      // Restore current video and position
      if (savedVideoId != null) {
        final videoIndex =
            _currentPlaylist.indexWhere((video) => video.id == savedVideoId);
        if (videoIndex != -1) {
          _currentIndex = videoIndex;
          _currentPosition = Duration(milliseconds: savedPositionMs);
          _isPlaying = savedIsPlaying;
          _hasAutoStarted = savedHasAutoStarted;
        } else {
          // Video not found, fallback to saved index
          _currentIndex = savedIndex.clamp(0, _currentPlaylist.length - 1);
        }
      } else {
        _currentIndex = savedIndex.clamp(0, _currentPlaylist.length - 1);
      }
    } catch (e) {
      debugPrint('Failed to load playlist state: $e');
      // Reset to defaults
      _currentIndex = 0;
      _currentPosition = Duration.zero;
      _isPlaying = false;
      _hasAutoStarted = false;
      _playbackMode = PlaybackMode.sequential;
    }
  }

  // Clear saved state
  Future<void> clearSavedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'playlist_${playlistId}';

      await prefs.remove('${key}_current_video_id');
      await prefs.remove('${key}_current_index');
      await prefs.remove('${key}_position_ms');
      await prefs.remove('${key}_is_playing');
      await prefs.remove('${key}_has_auto_started');
      await prefs.remove('${key}_playback_mode');
      await prefs.remove('${key}_playlist_order');

      // Reset state
      _currentIndex = 0;
      _currentPosition = Duration.zero;
      _isPlaying = false;
      _hasAutoStarted = false;
      _playbackMode = PlaybackMode.sequential;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to clear playlist state: $e');
    }
  }

  @override
  void dispose() {
    _saveState();
    super.dispose();
  }
}

// Helper function to create empty StarEntity
StarEntity _createEmptyStarEntity() {
  return StarEntity(
    id: '',
    title: '',
    description: '',
    user: UserStarEntity(
      id: '',
      firstName: '',
      lastName: '',
      email: '',
      image: '',
      viewNumber: 0,
      averageRating: 0,
    ),
    mediaUrl: [],
    totalViews: 0,
    averageRating: 0,
    isApproved: false,
    haveStories: false,
    storyCount: 0,
  );
}