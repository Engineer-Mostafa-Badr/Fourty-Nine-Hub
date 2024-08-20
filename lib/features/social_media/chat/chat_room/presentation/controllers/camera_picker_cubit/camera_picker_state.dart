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
  final List<XFile> mediaList;

  CameraPickerState({
    this.status = CameraPickerStatus.notInitialized,
    this.controller,
    this.mediaList = const [],
  });

  CameraPickerState copyWith({
    CameraPickerStatus? status,
    CameraController? controller,
    FlashMode? flashMode,
  }) {
    return CameraPickerState(
      status: status ?? this.status,
      controller: controller ?? this.controller,
    );
  }
}
