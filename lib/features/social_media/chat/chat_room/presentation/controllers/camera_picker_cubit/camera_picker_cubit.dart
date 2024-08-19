import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';

part 'camera_picker_state.dart';

class CameraPickerCubit extends Cubit<CameraPickerState> {
  CameraPickerCubit() : super(CameraPickerState());

  late CameraController _controller;
  int _selectedCamera = 0;
  final Duration _videoDuration = const Duration(minutes: 2);
  late List<CameraDescription> _cameras;
  List<XFile> mediaList = [];

  Future<void> init() async {
    _cameras = await availableCameras();
    _controller =
        CameraController(_cameras[_selectedCamera], ResolutionPreset.medium)
          ..setFlashMode(FlashMode.off);

    await _controller.initialize();
    emit(state.copyWith(
        controller: _controller, status: CameraPickerStatus.showCameraPreview));
  }

  void flipCamera() {
    _selectedCamera = _selectedCamera == 0 ? 1 : 0;
    _controller.setDescription(_cameras[_selectedCamera]);
    emit(state.copyWith(
        status: CameraPickerStatus.showCameraPreview, controller: _controller));
  }

  void toggleFlashMode() {
    FlashMode newFlashMode = _controller.value.flashMode == FlashMode.off
        ? FlashMode.torch
        : FlashMode.off;

    _controller.setFlashMode(newFlashMode);
    emit(state.copyWith(
        status: CameraPickerStatus.showCameraPreview, controller: _controller));
  }

  Future<void> takePicture() async {
    // emit(CameraPickerLoading());
    try {
      final XFile image = await _controller.takePicture();
      mediaList.add(image);
      // emit(CameraPickerLoaded());
    } catch (e) {
      // emit(CameraPickerError(e.toString()));
    }
  }

  Future<void> startVideoRecording() async {
    await _controller.startVideoRecording();
    await Future.delayed(_videoDuration);
    await stopVideoRecording();
  }

  Future<void> stopVideoRecording() async {
    final XFile video = await _controller.stopVideoRecording();
    mediaList.add(video);
  }

  @override
  Future<void> close() {
    _controller.dispose();
    return super.close();
  }
}
