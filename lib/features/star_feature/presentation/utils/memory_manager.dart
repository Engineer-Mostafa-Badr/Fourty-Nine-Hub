import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class MemoryManager {
  static final MemoryManager _instance = MemoryManager._internal();
  factory MemoryManager() => _instance;
  MemoryManager._internal();

  final List<VideoPlayerController> _videoControllers = [];
  Timer? _cleanupTimer;

  static const int maxVideoControllersInMemory = 10;
  static const Duration cleanupInterval = Duration(minutes: 2);

  void init() {
    _startPeriodicCleanup();
  }

  void _startPeriodicCleanup() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer.periodic(cleanupInterval, (_) {
      _performMemoryCleanup();
    });
  }

  void registerVideoController(VideoPlayerController controller) {
    _videoControllers.add(controller);

    // إذا تجاوز العدد الحد الأقصى، قم بحذف الأقدم
    if (_videoControllers.length > maxVideoControllersInMemory) {
      final oldController = _videoControllers.removeAt(0);
      _safeDisposeController(oldController);
    }
  }

  void unregisterVideoController(VideoPlayerController controller) {
    _videoControllers.remove(controller);
  }

  void _safeDisposeController(VideoPlayerController controller) {
    try {
      if (controller.value.isInitialized) {
        controller.pause();
        controller.dispose();
      }
    } catch (e) {
      debugPrint('Error disposing video controller: $e');
    }
  }

  void _performMemoryCleanup() {
    try {
      // إزالة controllers غير المستخدمة
      _videoControllers.removeWhere((controller) {
        final shouldRemove = !controller.value.isInitialized;
        if (shouldRemove) {
          _safeDisposeController(controller);
        }
        return shouldRemove;
      });

      // تنظيف الصور المخزنة مؤقتاً
      _clearImageCache();

      // إجبار garbage collection
      _forceGarbageCollection();

      debugPrint(
          'Memory cleanup completed. Active controllers: ${_videoControllers.length}');
    } catch (e) {
      debugPrint('Memory cleanup error: $e');
    }
  }

  void _clearImageCache() {
    try {
      PaintingBinding.instance.imageCache.clear();
      PaintingBinding.instance.imageCache.clearLiveImages();
    } catch (e) {
      debugPrint('Image cache clear error: $e');
    }
  }

  void _forceGarbageCollection() {
    if (!kDebugMode) return;

    try {
      // في debug mode فقط لتجنب التأثير على الأداء
      SystemChannels.platform.invokeMethod('System.gc');
    } catch (e) {
      debugPrint('GC invocation error: $e');
    }
  }

  void dispose() {
    _cleanupTimer?.cancel();

    // إغلاق جميع video controllers
    for (final controller in _videoControllers) {
      _safeDisposeController(controller);
    }
    _videoControllers.clear();
  }

  // إحصائيات الذاكرة
  Map<String, dynamic> getMemoryStats() {
    return {
      'activeVideoControllers': _videoControllers.length,
      'maxVideoControllers': maxVideoControllersInMemory,
      'imageCacheSize': PaintingBinding.instance.imageCache.currentSize,
      'imageCacheMaxSize': PaintingBinding.instance.imageCache.maximumSize,
    };
  }

  void logMemoryStats() {
    final stats = getMemoryStats();
    debugPrint('Memory Stats: $stats');
  }
}
