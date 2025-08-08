import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/utils/logging_service.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'video_fix_helper.dart';

/// Specialized manager to fix remote video issues and ensure proper display
class RemoteVideoManager {
  static final RemoteVideoManager _instance = RemoteVideoManager._internal();
  factory RemoteVideoManager() => _instance;
  RemoteVideoManager._internal();

  // Track last known state for each stream
  final Map<String, ZegoRemoteDeviceState> _knownCameraStates = {};
  
  // Attempt count to track retry attempts
  final Map<String, int> _retryAttempts = {};
  
  // Maximum retry attempts
  static const int MAX_RETRIES = 3;
  
  /// Reset state for new call sessions
  void reset() {
    LoggingService.info("🔄 Resetting remote video manager state");
    _knownCameraStates.clear();
    _retryAttempts.clear();
  }
  
  /// Get the current camera state for a stream, with fallback default
  ZegoRemoteDeviceState getKnownState(String streamID, {ZegoRemoteDeviceState defaultState = ZegoRemoteDeviceState.Disable}) {
    return _knownCameraStates[streamID] ?? defaultState;
  }
  
  /// Update the known camera state for a stream
  void updateState(String streamID, ZegoRemoteDeviceState state) {
    final oldState = _knownCameraStates[streamID];
    _knownCameraStates[streamID] = state;
    
    if (oldState != state) {
      LoggingService.info("📹 Remote camera state changed: $oldState -> $state for stream $streamID");
    }
  }
  
  /// Handle remote camera state change with enhanced logic
  Future<Widget?> handleRemoteCameraUpdate({
    required String streamID,
    required ZegoRemoteDeviceState state,
    Widget? currentWidget,
    bool shouldRefreshVideoOnActivation = true,
  }) async {
    LoggingService.info("📹 Processing remote camera state update: $state for stream $streamID");
    
    // Update our state tracking
    updateState(streamID, state);
    
    switch (state) {
      case ZegoRemoteDeviceState.Open:
        LoggingService.info("✅ Remote camera is OPEN - should display video");
        
        // If we should refresh video when camera opens
        if (shouldRefreshVideoOnActivation) {
          LoggingService.info("🔄 Refreshing remote video view due to camera activation");
          return _refreshRemoteVideo(streamID);
        }
        return currentWidget;
        
      case ZegoRemoteDeviceState.Disable:
      case ZegoRemoteDeviceState.Mute:
        LoggingService.info("🔇 Remote camera is OFF (${state.name}) - hiding video");
        return _buildDisabledVideoWidget("Camera turned off");
        
      case ZegoRemoteDeviceState.InBackground:
        LoggingService.info("⚙️ Remote app is in BACKGROUND - waiting before hiding video");
        // For background state, don't immediately change UI
        // The calling component should implement a delay before hiding
        return currentWidget; 
        
      default:
        LoggingService.info("❓ Unknown/error remote camera state: ${state.name}");
        return _buildDisabledVideoWidget("Video unavailable");
    }
  }
  
  /// Create a placeholder widget for when camera is disabled
  Widget _buildDisabledVideoWidget(String message) {
    return Container(
      color: Colors.black45,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.videocam_off, color: Colors.white, size: 48),
            SizedBox(height: 12),
            Text(message, style: TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }
  
  /// Handle the wait-and-retry approach for background state
  Future<Widget?> handleBackgroundState({
    required String streamID, 
    required Duration waitTime,
    Widget? currentWidget,
  }) async {
    LoggingService.info("⏱️ Setting up wait-and-see for background state");
    
    // Return immediately, but kick off background timer
    Timer(waitTime, () async {
      // After waiting, check if state is still background
      final currentState = getKnownState(streamID);
      if (currentState == ZegoRemoteDeviceState.InBackground) {
        LoggingService.info("⏱️ Background timer expired, remote still in background");
        // State is still background, create disabled widget
        _buildDisabledVideoWidget("Video paused - waiting for other user");
      } else {
        LoggingService.info("✅ Background timer expired, but state is now: $currentState");
      }
    });
    
    // Don't change anything immediately
    return currentWidget;
  }
  
  /// Refresh remote video view with more reliable implementation
  Future<Widget?> _refreshRemoteVideo(String streamID) async {
    LoggingService.info("🔄 Attempting to refresh remote video for stream: $streamID");
    
    try {
      // Track retries
      final int attempts = _retryAttempts[streamID] ?? 0;
      if (attempts >= MAX_RETRIES) {
        LoggingService.warning("⚠️ Maximum refresh attempts reached for stream: $streamID");
        return _buildDisabledVideoWidget("Video connection issue");
      }
      
      _retryAttempts[streamID] = attempts + 1;
      
      // Stop existing stream playback
      await ZegoExpressEngine.instance.stopPlayingStream(streamID);
      
      // Small delay before re-starting
      await Future.delayed(Duration(milliseconds: 200));
      
      // Use the VideoFixHelper for a more reliable canvas
      final Widget? newVideoWidget = await VideoFixHelper.startPlayStreamWithReliableCanvas(streamID);
      
      if (newVideoWidget != null) {
        LoggingService.info("✅ Remote video refreshed successfully");
        _retryAttempts[streamID] = 0; // Reset attempts on success
        return newVideoWidget;
      } else {
        LoggingService.warning("⚠️ Remote video refresh failed - null widget returned");
        return _buildDisabledVideoWidget("Video issue - tap to retry");
      }
    } catch (e) {
      LoggingService.error("❌ Error refreshing remote video", error: e);
      return _buildDisabledVideoWidget("Video error - tap to retry");
    }
  }
  
  /// Force refresh remote video - for use by manual retry buttons
  Future<Widget?> forceRefreshRemoteVideo(String streamID) async {
    LoggingService.info("🔄 Manual refresh of remote video requested");
    _retryAttempts[streamID] = 0; // Reset attempts for manual refresh
    return _refreshRemoteVideo(streamID);
  }
  
  /// Handle first frame rendering of remote video
  void handleFirstFrameRendered(String streamID) {
    LoggingService.info("🎥 Remote video first frame rendered for stream: $streamID");
    
    // Update state to open when we confirm rendering
    updateState(streamID, ZegoRemoteDeviceState.Open);
    
    // Reset any retry attempts
    _retryAttempts[streamID] = 0;
  }
}
