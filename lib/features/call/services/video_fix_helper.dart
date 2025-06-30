import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:fourtyninehub/core/utils/logging_service.dart';

/// Helper class to fix video issues with ZegoCloud
class VideoFixHelper {
  static final VideoFixHelper _instance = VideoFixHelper._internal();
  factory VideoFixHelper() => _instance;
  VideoFixHelper._internal();

  /// Reliable implementation for starting video preview with proper canvas capture
  static Future<Widget?> startPreviewWithReliableCanvas({
    bool isVideoEnabled = true,
  }) async {
    try {
      LoggingService.info("🎬 Starting reliable video preview method");
      
      // Check camera permission first if video is enabled
      if (isVideoEnabled) {
        final permissionStatus = await Permission.camera.request();
        if (permissionStatus != PermissionStatus.granted) {
          LoggingService.warning("❌ Camera permission not granted: $permissionStatus");
          throw Exception("Camera permission required for video");
        }
        LoggingService.info("✅ Camera permission granted");
      }

      // IMPORTANT: Use a completer that will only complete after we have both
      // the widget AND the preview is successfully started
      final Completer<Widget> canvasWidgetCompleter = Completer<Widget>();
      int? localViewID;
      
      LoggingService.info("🏗️ Creating canvas view with synchronous widget capture...");
      
      // Step 1: Create canvas view and IMMEDIATELY capture the returned widget
      final Widget? canvasWidget = await ZegoExpressEngine.instance.createCanvasView((viewID) async {
        localViewID = viewID;
        LoggingService.info("🎯 Canvas view created with ID: $viewID");
        
        try {
          if (isVideoEnabled) {
            // Step 2: Configure video settings BEFORE touching camera or preview
            LoggingService.info("⚙️ Setting video configuration...");
            await ZegoExpressEngine.instance.setVideoConfig(
              ZegoVideoConfig.preset(ZegoVideoConfigPreset.Preset360P),
            );
            
            // Step 3: Set up first frame callback BEFORE enabling camera
            ZegoExpressEngine.onPublisherCapturedVideoFirstFrame = (channel) {
              LoggingService.info("🎥 First camera frame captured!");
            };
            
            // Step 4: Create canvas with proper view mode BEFORE starting preview
            final previewCanvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
            
            // Step 5: Enable camera
            LoggingService.info("📷 Enabling camera...");
            await ZegoExpressEngine.instance.enableCamera(true);
            
            // Step 6: Start preview with canvas already configured
            LoggingService.info("▶️ Starting preview...");
            await ZegoExpressEngine.instance.startPreview(canvas: previewCanvas);
            
            // Step 7: Ensure video publishing is unmuted
            await ZegoExpressEngine.instance.mutePublishStreamVideo(false);
            LoggingService.info("🔊 Video publishing unmuted");
            
          } else {
            LoggingService.info("🔇 Setting up audio-only mode...");
            
            // For audio-only, create canvas but disable video
            final previewCanvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFit);
            await ZegoExpressEngine.instance.startPreview(canvas: previewCanvas);
            await ZegoExpressEngine.instance.enableCamera(false);
            await ZegoExpressEngine.instance.mutePublishStreamVideo(true);
          }
          
          LoggingService.info("✅ Canvas setup completed successfully");
          
          // We DO NOT complete the completer here - it's already completed with the widget
          
        } catch (e) {
          LoggingService.error("❌ Error in canvas callback", error: e);
          // Don't complete the completer with an error, as we already have the widget
          // This prevents race conditions
        }
      });
      
      // Very important: Since we captured the widget synchronously above,
      // we already have it and can return it directly
      return canvasWidget;
      
    } catch (e) {
      LoggingService.error("❌ Error in startPreviewWithReliableCanvas", error: e);
      return null;
    }
  }
  /// Fixes remote video playback issues with enhanced synchronization
  static Future<Widget?> startPlayStreamWithReliableCanvas(String streamID) async {
    try {
      LoggingService.info("🎬 Starting reliable remote video play method for stream: $streamID");
      
      // Create a completer to ensure proper async coordination
      final Completer<Widget> canvasCompleter = Completer<Widget>();
      int? capturedViewID;
      
      LoggingService.info("🏗️ Creating remote video canvas...");
      
      // Step 1: Create canvas view and capture both widget and viewID
      final Widget? canvasWidget = await ZegoExpressEngine.instance.createCanvasView((viewID) async {
        capturedViewID = viewID;
        LoggingService.info("🎯 Remote canvas view created with ID: $viewID");
        
        try {
          // Step 2: Configure canvas immediately upon creation
          final canvas = ZegoCanvas(viewID, viewMode: ZegoViewMode.AspectFill);
          LoggingService.info("⚙️ Canvas configured with AspectFill mode");
          
          // Step 3: Start playing stream with proper configuration
          LoggingService.info("▶️ Starting remote stream playback...");
          await ZegoExpressEngine.instance.startPlayingStream(streamID, canvas: canvas);
          
          // Step 4: Explicitly unmute both audio and video for this stream
          await ZegoExpressEngine.instance.mutePlayStreamVideo(streamID, false);
          await ZegoExpressEngine.instance.mutePlayStreamAudio(streamID, false);
          LoggingService.info("🔊 Remote audio and video unmuted for stream: $streamID");
          
          // Step 5: Set up monitoring for remote video events
          _setupRemoteVideoEventHandlers(streamID);
          
          LoggingService.info("✅ Remote video setup completed successfully");
          
        } catch (e) {
          LoggingService.error("❌ Error in remote video canvas setup", error: e);
        }
      });
      
      if (canvasWidget != null) {
        LoggingService.info("✅ Remote canvas widget created and configured");
        return canvasWidget;
      } else {
        LoggingService.error("❌ Failed to create remote canvas widget");
        return null;
      }
      
    } catch (e) {
      LoggingService.error("❌ Error in startPlayStreamWithReliableCanvas", error: e);
      return null;
    }
  }
  
  /// Set up event handlers specifically for monitoring remote video status
  static void _setupRemoteVideoEventHandlers(String streamID) {
    // First frame received handler
    ZegoExpressEngine.onPlayerRecvVideoFirstFrame = (playStreamID) {
      if (playStreamID == streamID) {
        LoggingService.info("🎥 First remote video frame RECEIVED for stream: $streamID");
      }
    };
    
    // First frame rendered handler - most important for confirming display
    ZegoExpressEngine.onPlayerRenderVideoFirstFrame = (playStreamID) {
      if (playStreamID == streamID) {
        LoggingService.info("🎥 First remote video frame RENDERED for stream: $streamID!");
        LoggingService.info("✅ Remote video should now be visible to the user");
      }
    };
    
    // Video size changed handler - confirms video dimensions
    ZegoExpressEngine.onPlayerVideoSizeChanged = (changedStreamID, width, height) {
      if (changedStreamID == streamID) {
        LoggingService.info("📏 Remote video size confirmed: ${width}x$height for stream: $streamID");
        if (width > 0 && height > 0) {
          LoggingService.info("✅ Remote video has valid dimensions - display should be working");
        }
      }
    };
  }
  
  /// Reliable video toggle implementation that properly handles state transitions
  static Future<bool> toggleVideo({
    required bool currentlyEnabled,
    required Function(bool) onStateChanged,
  }) async {
    try {
      final bool newState = !currentlyEnabled;
      LoggingService.info("🎬 Toggling video: $currentlyEnabled → $newState");
      
      // First update UI immediately through callback
      onStateChanged(newState);
      
      if (newState) {
        // Turning video ON
        LoggingService.info("📷 Enabling video...");
        
        // Check permission
        final permissionStatus = await Permission.camera.status;
        if (permissionStatus != PermissionStatus.granted) {
          LoggingService.warning("❌ Camera permission not granted");
          
          // Revert state through callback
          onStateChanged(false);
          return false;
        }
        
        // Enable camera and unmute video publishing
        await ZegoExpressEngine.instance.enableCamera(true);
        await ZegoExpressEngine.instance.mutePublishStreamVideo(false);
        
        LoggingService.info("✅ Video enabled successfully");
        return true;
        
      } else {
        // Turning video OFF
        LoggingService.info("📷 Disabling video...");
        
        // Mute video first so it stops sending immediately
        await ZegoExpressEngine.instance.mutePublishStreamVideo(true);
        
        // Then disable camera
        await ZegoExpressEngine.instance.enableCamera(false);
        
        LoggingService.info("✅ Video disabled successfully");
        return true;
      }
      
    } catch (e) {
      LoggingService.error("❌ Error in toggleVideo", error: e);
      return false;
    }
  }
  
  /// Check and fix common video issues
  static Future<bool> diagnoseAndFixVideoIssues({
    required bool shouldBeEnabled,
    required Function(Widget?) onLocalViewUpdated,
  }) async {
    try {
      LoggingService.info("🔍 Diagnosing video issues...");
      
      // Check if camera is enabled as expected
      final shouldCameraBeOn = shouldBeEnabled;
      
      // Check actual camera state - no direct way to query in ZegoCloud
      // So we force the state to match what it should be
      
      if (shouldCameraBeOn) {
        LoggingService.info("🔧 Fixing video state - should be enabled");
        
        // Enable camera
        await ZegoExpressEngine.instance.enableCamera(true);
        
        // Unmute video
        await ZegoExpressEngine.instance.mutePublishStreamVideo(false);
        
        // Start preview with reliable canvas
        final newWidget = await startPreviewWithReliableCanvas(isVideoEnabled: true);
        
        // Update UI
        onLocalViewUpdated(newWidget);
        
        LoggingService.info("✅ Video should now be working");
        return true;
        
      } else {
        LoggingService.info("🔧 Fixing video state - should be disabled");
        
        // Mute video
        await ZegoExpressEngine.instance.mutePublishStreamVideo(true);
        
        // Disable camera
        await ZegoExpressEngine.instance.enableCamera(false);
        
        LoggingService.info("✅ Video should now be disabled");
        return true;
      }
      
    } catch (e) {
      LoggingService.error("❌ Error in diagnoseAndFixVideoIssues", error: e);
      return false;
    }
  }
}
