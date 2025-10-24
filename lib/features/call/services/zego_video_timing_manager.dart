// import 'dart:async';
// import 'dart:developer';
// import 'package:zego_express_engine/zego_express_engine.dart';
//
// /// Manages ZegoCloud video initialization timing and prevents race conditions
// class ZegoVideoTimingManager {
//   static ZegoVideoTimingManager? _instance;
//   static ZegoVideoTimingManager get instance => _instance ??= ZegoVideoTimingManager._();
//
//   ZegoVideoTimingManager._();
//   // State tracking
//   bool _isInitializing = false;
//   bool _isCameraReady = false;
//   bool _isCanvasReady = false;
//   bool _isPreviewStarted = false;
//
//   // Timing tracking
//   int? _initStartTime;
//   int? _cameraEnabledTime;
//   int? _canvasCreatedTime;
//   int? _previewStartedTime;
//   int? _firstFrameTime;
//
//   // Completers for synchronization
//   Completer<void>? _cameraReadyCompleter;
//   Completer<void>? _canvasReadyCompleter;
//   Completer<void>? _firstFrameCompleter;
//
//   /// Initializes video with proper timing sequence
//   Future<VideoInitializationResult> initializeVideo({
//     required bool enableVideo,
//     required Function(int) onCanvasCreated,
//     Duration timeout = const Duration(seconds: 5),
//   }) async {
//     if (_isInitializing) {
//       log('Video initialization already in progress');
//       return VideoInitializationResult.alreadyInProgress();
//     }
//
//     _isInitializing = true;
//     _initStartTime = DateTime.now().millisecondsSinceEpoch;
//     _resetState();
//
//     try {
//       log('🎬 Starting video initialization sequence...');
//
//       if (!enableVideo) {
//         return await _initializeAudioOnly(onCanvasCreated);
//       }
//
//       // PHASE 1: Setup event handlers for synchronization
//       _setupEventHandlers();
//
//       // PHASE 2: Configure video settings
//       await _configureVideoSettings();
//         // PHASE 3: Create canvas and wait for it to be ready
//       final canvasResult = await _createCanvasWithTimeout(onCanvasCreated, timeout);
//       if (!canvasResult.success) {
//         return VideoInitializationResult.canvasCreationFailed(canvasResult.error ?? 'Canvas creation failed');
//       }
//
//       // PHASE 4: Enable camera and wait for readiness
//       final cameraResult = await _enableCameraWithTimeout(timeout);
//       if (!cameraResult.success) {
//         return VideoInitializationResult.cameraInitializationFailed(cameraResult.error ?? 'Camera initialization failed');
//       }
//
//       // PHASE 5: Start preview and wait for first frame
//       final previewResult = await _startPreviewWithTimeout(canvasResult.viewId!, timeout);
//       if (!previewResult.success) {
//         return VideoInitializationResult.previewStartFailed(previewResult.error ?? 'Preview start failed');
//       }
//
//       // PHASE 6: Wait for first video frame
//       final firstFrameResult = await _waitForFirstFrameWithTimeout(timeout);
//       if (!firstFrameResult.success) {
//         log('⚠️ First frame timeout, but continuing...');
//       }
//
//       _logTimingResults();
//       return VideoInitializationResult.success(canvasResult.viewId!, _calculateTotalTime());
//
//     } catch (e) {
//       log('❌ Video initialization failed: $e');
//       return VideoInitializationResult.unexpectedError(e.toString());
//     } finally {
//       _isInitializing = false;
//       _cleanupCompleters();
//     }
//   }
//
//   /// Initialize audio-only mode
//   Future<VideoInitializationResult> _initializeAudioOnly(Function(int) onCanvasCreated) async {
//     try {
//       log('🎵 Initializing audio-only mode...');
//
//       final completer = Completer<int>();
//
//       await ZegoExpressEngine.instance.createCanvasView((viewId) async {
//         _canvasCreatedTime = DateTime.now().millisecondsSinceEpoch;
//
//         final canvas = ZegoCanvas(viewId, viewMode: ZegoViewMode.AspectFit);
//         await ZegoExpressEngine.instance.startPreview(canvas: canvas);
//         await ZegoExpressEngine.instance.enableCamera(false);
//         await ZegoExpressEngine.instance.mutePublishStreamVideo(true);
//
//         onCanvasCreated(viewId);
//         completer.complete(viewId);
//       });
//
//       final viewId = await completer.future;
//       return VideoInitializationResult.success(viewId, _calculateTotalTime());
//
//     } catch (e) {
//       return VideoInitializationResult.unexpectedError(e.toString());
//     }
//   }
//
//   /// Setup event handlers for timing synchronization
//   void _setupEventHandlers() {
//     ZegoExpressEngine.onPublisherCapturedVideoFirstFrame = (channel) {
//       _firstFrameTime = DateTime.now().millisecondsSinceEpoch;
//       _isCameraReady = true;
//       log('🎥 First video frame captured at ${_firstFrameTime}ms');
//
//       if (_firstFrameCompleter?.isCompleted == false) {
//         _firstFrameCompleter?.complete();
//       }
//     };
//
//     ZegoExpressEngine.onPublisherRenderVideoFirstFrame = (channel) {
//       log('🎥 First video frame rendered');
//     };
//
//     ZegoExpressEngine.onPublisherVideoSizeChanged = (width, height, channel) {
//       log('📐 Video size changed: ${width}x$height');
//     };
//   }
//
//   /// Configure video settings
//   Future<void> _configureVideoSettings() async {
//     log('⚙️ Configuring video settings...');
//     await ZegoExpressEngine.instance.setVideoConfig(
//       ZegoVideoConfig.preset(ZegoVideoConfigPreset.Preset360P),
//     );
//   }
//
//   /// Create canvas with timeout
//   Future<CanvasCreationResult> _createCanvasWithTimeout(
//     Function(int) onCanvasCreated,
//     Duration timeout,
//   ) async {
//     log('🖼️ Creating canvas view...');
//     _canvasReadyCompleter = Completer<void>();
//
//     try {
//       final completer = Completer<int>();
//
//       await ZegoExpressEngine.instance.createCanvasView((viewId) async {
//         _canvasCreatedTime = DateTime.now().millisecondsSinceEpoch;
//         _isCanvasReady = true;
//         log('✅ Canvas created with ID: $viewId at ${_canvasCreatedTime}ms');
//
//         onCanvasCreated(viewId);
//         _canvasReadyCompleter?.complete();
//         completer.complete(viewId);
//       });
//
//       final viewId = await Future.any([
//         completer.future,
//         Future.delayed(timeout).then((_) => throw TimeoutException('Canvas creation timeout')),
//       ]);
//
//       return CanvasCreationResult.success(viewId);
//
//     } catch (e) {
//       return CanvasCreationResult.failed(e.toString());
//     }
//   }
//
//   /// Enable camera with timeout
//   Future<CameraEnableResult> _enableCameraWithTimeout(Duration timeout) async {
//     log('📷 Enabling camera...');
//     _cameraReadyCompleter = Completer<void>();
//
//     try {
//       await ZegoExpressEngine.instance.enableCamera(true);
//       _cameraEnabledTime = DateTime.now().millisecondsSinceEpoch;
//       log('✅ Camera enabled at ${_cameraEnabledTime}ms');
//
//       // Wait a bit for camera to stabilize
//       await Future.delayed(Duration(milliseconds: 100));
//       _cameraReadyCompleter?.complete();
//
//       return CameraEnableResult.success();
//
//     } catch (e) {
//       return CameraEnableResult.failed(e.toString());
//     }
//   }
//
//   /// Start preview with timeout
//   Future<PreviewStartResult> _startPreviewWithTimeout(int viewId, Duration timeout) async {
//     log('▶️ Starting preview...');
//
//     try {
//       final canvas = ZegoCanvas(viewId, viewMode: ZegoViewMode.AspectFill);
//       await ZegoExpressEngine.instance.startPreview(canvas: canvas);
//
//       _previewStartedTime = DateTime.now().millisecondsSinceEpoch;
//       _isPreviewStarted = true;
//       log('✅ Preview started at ${_previewStartedTime}ms');
//
//       // Unmute video publishing
//       await ZegoExpressEngine.instance.mutePublishStreamVideo(false);
//       log('✅ Video publishing unmuted');
//
//       return PreviewStartResult.success();
//
//     } catch (e) {
//       return PreviewStartResult.failed(e.toString());
//     }
//   }
//
//   /// Wait for first frame with timeout
//   Future<FirstFrameResult> _waitForFirstFrameWithTimeout(Duration timeout) async {
//     log('⏳ Waiting for first video frame...');
//     _firstFrameCompleter = Completer<void>();
//
//     try {
//       await Future.any([
//         _firstFrameCompleter!.future,
//         Future.delayed(timeout).then((_) => throw TimeoutException('First frame timeout')),
//       ]);
//
//       return FirstFrameResult.success();
//
//     } catch (e) {
//       return FirstFrameResult.failed(e.toString());
//     }
//   }
//     /// Calculate total initialization time
//   int _calculateTotalTime() {
//     // Use state variables to track completion
//     log('State: camera ready: $_isCameraReady, canvas ready: $_isCanvasReady, preview started: $_isPreviewStarted');
//     return DateTime.now().millisecondsSinceEpoch - (_initStartTime ?? 0);
//   }
//
//   /// Log timing results for analysis
//   void _logTimingResults() {
//     final total = _calculateTotalTime();
//     log('📊 Video Initialization Timing Results:');
//     log('   Total Time: ${total}ms');
//     if (_cameraEnabledTime != null && _initStartTime != null) {
//       log('   Camera Enable: ${_cameraEnabledTime! - _initStartTime!}ms');
//     }
//     if (_canvasCreatedTime != null && _initStartTime != null) {
//       log('   Canvas Creation: ${_canvasCreatedTime! - _initStartTime!}ms');
//     }
//     if (_previewStartedTime != null && _initStartTime != null) {
//       log('   Preview Start: ${_previewStartedTime! - _initStartTime!}ms');
//     }
//     if (_firstFrameTime != null && _initStartTime != null) {
//       log('   First Frame: ${_firstFrameTime! - _initStartTime!}ms');
//     }
//   }
//
//   /// Reset internal state
//   void _resetState() {
//     _isCameraReady = false;
//     _isCanvasReady = false;
//     _isPreviewStarted = false;
//
//     _cameraEnabledTime = null;
//     _canvasCreatedTime = null;
//     _previewStartedTime = null;
//     _firstFrameTime = null;
//   }
//
//   /// Cleanup completers
//   void _cleanupCompleters() {
//     _cameraReadyCompleter = null;
//     _canvasReadyCompleter = null;
//     _firstFrameCompleter = null;
//   }
//
//   /// Cleanup resources
//   Future<void> cleanup() async {
//     log('🧹 Cleaning up video timing manager...');
//     _isInitializing = false;
//     _cleanupCompleters();
//     _resetState();
//
//     // Clear event handlers
//     ZegoExpressEngine.onPublisherCapturedVideoFirstFrame = null;
//     ZegoExpressEngine.onPublisherRenderVideoFirstFrame = null;
//     ZegoExpressEngine.onPublisherVideoSizeChanged = null;
//   }
// }
//
// // Result classes
// class VideoInitializationResult {
//   final bool success;
//   final String? error;
//   final int? viewId;
//   final int? totalTimeMs;
//   final VideoInitializationError? errorType;
//
//   VideoInitializationResult._(this.success, this.error, this.viewId, this.totalTimeMs, this.errorType);
//
//   factory VideoInitializationResult.success(int viewId, int totalTimeMs) =>
//     VideoInitializationResult._(true, null, viewId, totalTimeMs, null);
//
//   factory VideoInitializationResult.alreadyInProgress() =>
//     VideoInitializationResult._(false, 'Video initialization already in progress', null, null, VideoInitializationError.alreadyInProgress);
//
//   factory VideoInitializationResult.canvasCreationFailed(String error) =>
//     VideoInitializationResult._(false, 'Canvas creation failed: $error', null, null, VideoInitializationError.canvasCreationFailed);
//
//   factory VideoInitializationResult.cameraInitializationFailed(String error) =>
//     VideoInitializationResult._(false, 'Camera initialization failed: $error', null, null, VideoInitializationError.cameraInitializationFailed);
//
//   factory VideoInitializationResult.previewStartFailed(String error) =>
//     VideoInitializationResult._(false, 'Preview start failed: $error', null, null, VideoInitializationError.previewStartFailed);
//
//   factory VideoInitializationResult.unexpectedError(String error) =>
//     VideoInitializationResult._(false, 'Unexpected error: $error', null, null, VideoInitializationError.unexpectedError);
// }
//
// enum VideoInitializationError {
//   alreadyInProgress,
//   canvasCreationFailed,
//   cameraInitializationFailed,
//   previewStartFailed,
//   unexpectedError,
// }
//
// class CanvasCreationResult {
//   final bool success;
//   final String? error;
//   final int? viewId;
//
//   CanvasCreationResult._(this.success, this.error, this.viewId);
//
//   factory CanvasCreationResult.success(int viewId) => CanvasCreationResult._(true, null, viewId);
//   factory CanvasCreationResult.failed(String error) => CanvasCreationResult._(false, error, null);
// }
//
// class CameraEnableResult {
//   final bool success;
//   final String? error;
//
//   CameraEnableResult._(this.success, this.error);
//
//   factory CameraEnableResult.success() => CameraEnableResult._(true, null);
//   factory CameraEnableResult.failed(String error) => CameraEnableResult._(false, error);
// }
//
// class PreviewStartResult {
//   final bool success;
//   final String? error;
//
//   PreviewStartResult._(this.success, this.error);
//
//   factory PreviewStartResult.success() => PreviewStartResult._(true, null);
//   factory PreviewStartResult.failed(String error) => PreviewStartResult._(false, error);
// }
//
// class FirstFrameResult {
//   final bool success;
//   final String? error;
//
//   FirstFrameResult._(this.success, this.error);
//
//   factory FirstFrameResult.success() => FirstFrameResult._(true, null);
//   factory FirstFrameResult.failed(String error) => FirstFrameResult._(false, error);
// }
