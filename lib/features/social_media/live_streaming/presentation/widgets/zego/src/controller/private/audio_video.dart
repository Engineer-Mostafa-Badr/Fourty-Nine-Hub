import '../../../zego_uikit_prebuilt_live_streaming.dart';
import '../audio_video.dart';

/// @nodoc
mixin ZegoLiveStreamingControllerAudioVideoImplPrivate {
  final _private = ZegoLiveStreamingControllerAudioVideoImplPrivateImpl();

  /// Don't call that
  ZegoLiveStreamingControllerAudioVideoImplPrivateImpl get private => _private;
}

/// @nodoc
class ZegoLiveStreamingControllerAudioVideoImplPrivateImpl {
  ZegoUIKitPrebuiltLiveStreamingConfig? config;

  final _microphone = ZegoLiveStreamingControllerAudioVideoMicrophoneImpl();
  final _camera = ZegoLiveStreamingControllerAudioVideoCameraImpl();
  final _audioOutput = ZegoLiveStreamingControllerAudioVideoAudioOutputImpl();
  ZegoLiveStreamingControllerAudioVideoMicrophoneImpl get microphone =>
      _microphone;
  ZegoLiveStreamingControllerAudioVideoCameraImpl get camera => _camera;
  ZegoLiveStreamingControllerAudioVideoAudioOutputImpl get audioOutput =>
      _audioOutput;

  /// Please do not call this interface. It is the internal logic of Prebuilt.
  void initByPrebuilt({
    required ZegoUIKitPrebuiltLiveStreamingConfig? config,
  }) {
    ZegoLoggerService.logInfo(
      'init by prebuilt',
      tag: 'live-streaming',
      subTag: 'controller.audioVideo.p',
    );

    this.config = config;

    _microphone.private.initByPrebuilt(config: config);
    _camera.private.initByPrebuilt(config: config);
    _audioOutput.private.initByPrebuilt(config: config);
  }

  /// Please do not call this interface. It is the internal logic of Prebuilt.
  void uninitByPrebuilt() {
    ZegoLoggerService.logInfo(
      'un-init by prebuilt',
      tag: 'live-streaming',
      subTag: 'controller.audioVideo.p',
    );

    config = null;

    _microphone.private.uninitByPrebuilt();
    _camera.private.uninitByPrebuilt();
    _audioOutput.private.uninitByPrebuilt();
  }
}

/// @nodoc
mixin ZegoLiveStreamingControllerAudioVideoDeviceImplPrivate {
  final _private = ZegoLiveStreamingControllerAudioVideoImplDevicePrivateImpl();

  /// Don't call that
  ZegoLiveStreamingControllerAudioVideoImplDevicePrivateImpl get private =>
      _private;
}

/// @nodoc
class ZegoLiveStreamingControllerAudioVideoImplDevicePrivateImpl {
  ZegoUIKitPrebuiltLiveStreamingConfig? config;

  /// Please do not call this interface. It is the internal logic of ZegoUIKitPrebuiltLiveAudioRoom.
  void initByPrebuilt({
    required ZegoUIKitPrebuiltLiveStreamingConfig? config,
  }) {
    ZegoLoggerService.logInfo(
      'init by prebuilt',
      tag: 'live-streaming',
      subTag: 'controller.audioVideo.p',
    );

    this.config = config;
  }

  /// Please do not call this interface. It is the internal logic of ZegoUIKitPrebuiltLiveAudioRoom.
  void uninitByPrebuilt() {
    ZegoLoggerService.logInfo(
      'un-init by prebuilt',
      tag: 'live-streaming',
      subTag: 'controller.audioVideo.p',
    );

    config = null;
  }
}
