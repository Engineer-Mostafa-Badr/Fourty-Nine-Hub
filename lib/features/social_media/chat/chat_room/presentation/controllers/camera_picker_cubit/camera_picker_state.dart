// part of 'camera_picker_cubit.dart';

// enum CameraPickerStatus {
//   notInitialized,
//   initialized,
//   loadingCamera,
//   flipCamera,
//   startVideo,
//   endVideo,
//   toggleFlashMode,
//   updateMediaList,
//   needCameraPermission,
//   needMicrophonePermission,
// }

// enum PickMode { photo, video }

// class CameraPickerState {
//   final CameraPickerStatus status;
//   final CameraController? controller;
//   final PickMode pickMode;
//   final List<File>? mediaList;

//   CameraPickerState({
//     this.status = CameraPickerStatus.notInitialized,
//     this.controller,
//     this.mediaList,
//     this.pickMode = PickMode.photo,
//   });

//   CameraPickerState copyWith({
//     CameraPickerStatus? status,
//     CameraController? controller,
//     PickMode? pickMode,
//     List<File>? mediaList,
//   }) {
//     return CameraPickerState(
//       status: status ?? this.status,
//       controller: controller ?? this.controller,
//       mediaList: mediaList ?? this.mediaList,
//       pickMode: pickMode ?? this.pickMode,
//     );
//   }
// }
