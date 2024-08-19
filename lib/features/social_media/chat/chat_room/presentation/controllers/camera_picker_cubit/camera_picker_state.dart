part of 'camera_picker_cubit.dart';

enum CameraPickerStatus {
  init,
  showCameraPreview,
  showPhotoButton,
  showStartVideoButton,
  showStopVideoButton,
  toggleFlashMode,
}

class CameraPickerState {
  final CameraPickerStatus status;
  final CameraController? controller;
  CameraPickerState({
    this.status = CameraPickerStatus.init,
    this.controller,
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
