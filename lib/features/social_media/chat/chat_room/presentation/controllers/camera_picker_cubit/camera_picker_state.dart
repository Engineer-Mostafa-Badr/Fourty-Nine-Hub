part of 'camera_picker_cubit.dart';

enum CameraPickerStatus {
  notInitialized,
  initialized,
  updateCameraView,
  showPhotoButton,
  showStartVideoButton,
  showStopVideoButton,
  toggleFlashMode,
  updateMediaList,
}

class CameraPickerState {
  final CameraPickerStatus status;
  final CameraController? controller;
  final List<XFile>? mediaList;

  CameraPickerState({
    this.status = CameraPickerStatus.notInitialized,
    this.controller,
    this.mediaList,
  });

  CameraPickerState copyWith({
    CameraPickerStatus? status,
    CameraController? controller,
    FlashMode? flashMode,
    List<XFile>? mediaList,
  }) {
    return CameraPickerState(
      status: status ?? this.status,
      controller: controller ?? this.controller,
      mediaList: mediaList ?? this.mediaList,
    );
  }
}
