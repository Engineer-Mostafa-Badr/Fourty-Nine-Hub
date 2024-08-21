part of 'camera_picker_cubit.dart';

enum CameraPickerStatus {
  notInitialized,
  initialized,
  updateCameraView,
  startVideo,
  endVideo,
  updateVideoLength,
  toggleFlashMode,
  updateMediaList,
  photoMode,
  
  videoMode,
}

enum PickMode { photo, video }

class CameraPickerState {
  final CameraPickerStatus status;
  final CameraController? controller;
  final PickMode pickMode;
  final List<XFile>? mediaList;
  final Duration? currentVideoLength;

  CameraPickerState({
    this.status = CameraPickerStatus.notInitialized,
    this.controller,
    this.mediaList,
    this.pickMode = PickMode.photo,
    this.currentVideoLength,
  });

  CameraPickerState copyWith({
    CameraPickerStatus? status,
    CameraController? controller,
    PickMode? pickMode,
    List<XFile>? mediaList,
    Duration? currentVideoLength,
  }) {
    return CameraPickerState(
      status: status ?? this.status,
      controller: controller ?? this.controller,
      mediaList: mediaList ?? this.mediaList,
      pickMode: pickMode ?? this.pickMode,
      currentVideoLength: currentVideoLength ?? this.currentVideoLength,
    );
  }
}
