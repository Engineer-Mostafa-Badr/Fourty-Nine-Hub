  import 'package:flutter/material.dart';
import '../../../core/utils/logging_service.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'video_fix_helper.dart';
  
    /// Helper method to refresh remote video with better error handling
    Future<Widget?> refreshRemoteVideo(String streamID) async {
    LoggingService.info("🔄 Refreshing remote video for stream: $streamID");
    
    try {
      // Step 1: Stop existing stream playback first
      await ZegoExpressEngine.instance.stopPlayingStream(streamID);
      LoggingService.info("✅ Previous stream playback stopped");
      
      // Step 2: Small delay before restarting
      await Future.delayed(Duration(milliseconds: 200));
      
      // Step 3: Use our reliable helper method to restart the stream
      return await VideoFixHelper.startPlayStreamWithReliableCanvas(streamID);
    } catch (e) {
      LoggingService.error("❌ Error refreshing remote video", error: e);
      return null;
    }
  }
