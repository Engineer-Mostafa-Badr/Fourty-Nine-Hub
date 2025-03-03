import 'package:flutter/material.dart';

abstract class CallService {
  Future<void> initializeService();
  Future<void> joinCall(String channelName, int uid);
  Future<void> leaveCall();
  Future<void> toggleMute();
  Future<void> toggleVideo();
  Future<void> switchCamera();
  Widget buildCallView();
}
