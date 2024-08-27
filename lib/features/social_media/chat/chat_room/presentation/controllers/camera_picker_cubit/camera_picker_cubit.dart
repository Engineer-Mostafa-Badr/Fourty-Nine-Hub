import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:permission_handler/permission_handler.dart';

part 'camera_picker_state.dart';

class CameraPickerCubit extends Cubit<CameraPickerState> {
  CameraPickerCubit() : super(CameraPickerState());

  CameraController? _controller;
  int _selectedCamera = 0;
  final List<XFile> _mediaList = [];
  final Duration _maxVideoLength = const Duration(minutes: 2);
  late List<CameraDescription> _cameras;
  Completer<void>? _recordingCompleter;

  Future<void> init() async {
    try {
      emit(state.copyWith(status: CameraPickerStatus.loadingCamera));
      _cameras = await availableCameras();
      CliLogger.info(_cameras.toString());
      _controller =
          CameraController(_cameras[_selectedCamera], ResolutionPreset.medium);

      await _controller?.initialize();
      await _controller?.setFlashMode(FlashMode.off);
      emit(state.copyWith(
          controller: _controller, status: CameraPickerStatus.initialized));
    } on CameraException catch (e) {
      if (e.code.toLowerCase().contains('camera')) {
        emit(state.copyWith(status: CameraPickerStatus.needCameraPermission));
      } else if (e.code.toLowerCase().contains('microphone') ||
          e.code.toLowerCase().contains('audio')) {
        emit(state.copyWith(
            status: CameraPickerStatus.needMicrophonePermission));
      } else {
        CliLogger.error(e.toString());
      }
    } catch (e) {
      CliLogger.error(e.toString());
    }
  }

  Future<void> flipCamera() async {
    _selectedCamera = _selectedCamera == 0 ? 1 : 0;
    emit(state.copyWith(status: CameraPickerStatus.loadingCamera));
    await _controller?.setDescription(_cameras[_selectedCamera]);
    CliLogger.info('Camera flipped to ${_cameras[_selectedCamera].name}');
    emit(state.copyWith(
        status: CameraPickerStatus.flipCamera, controller: _controller));
  }

  Future<void> toggleFlashMode() async {
    FlashMode newFlashMode = _controller?.value.flashMode == FlashMode.off
        ? FlashMode.torch
        : FlashMode.off;

    await _controller?.setFlashMode(newFlashMode);
    emit(state.copyWith(
        status: CameraPickerStatus.toggleFlashMode, controller: _controller));
  }

  Future<void> takePicture() async {
    try {
      final XFile? image = await _controller?.takePicture();
      CliLogger.info(
          'Picture taken : ${image?.path}\nimage.mimeType: ${image?.mimeType}');
      if (image != null) {
        _mediaList.add(image);
      }
      emit(state.copyWith(
          status: CameraPickerStatus.updateMediaList, mediaList: _mediaList));
    } catch (e) {
      CliLogger.error('Error taking picture: $e');
    }
  }

  Future<void> startVideoRecording() async {
    try {
      _recordingCompleter = Completer<void>();
      await _controller?.startVideoRecording();
      emit(state.copyWith(status: CameraPickerStatus.startVideo));
      CliLogger.info('Video recording started');

      await Future.any([
        Future.delayed(_maxVideoLength),
        _recordingCompleter!.future,
      ]);

      if (!_recordingCompleter!.isCompleted) {
        CliLogger.info('Video recording stopped automatically');
        stopVideoRecording();
      }

      _recordingCompleter = null;
    } catch (e) {
      CliLogger.error("Error while starting video recording: $e");
    }
  }

  Future<void> stopVideoRecording() async {
    try {
      if (_recordingCompleter != null && !_recordingCompleter!.isCompleted) {
        _recordingCompleter!
            .complete(); // Signal that the recording has been stopped
      }

      final XFile? video = await _controller?.stopVideoRecording();
      CliLogger.info(
          'Video recording stopped : ${video?.path}\nvideo.mimeType: ${video?.mimeType}');
      emit(state.copyWith(status: CameraPickerStatus.endVideo));

      if (video != null) {
        _mediaList.add(video);
        emit(state.copyWith(
            status: CameraPickerStatus.updateMediaList, mediaList: _mediaList));
      }
    } catch (e) {
      CliLogger.error("Error while stopping video recording: $e");
    }
  }

  void emitPhotoPickMode() {
    emit(state.copyWith(pickMode: PickMode.photo));
  }

  void emitVideoPickMode() {
    emit(state.copyWith(pickMode: PickMode.video));
  }

  void refreshMediaList(){
    emit(state.copyWith(status: CameraPickerStatus.updateMediaList, mediaList: _mediaList));
  }

  Duration get maxVideoLength => _maxVideoLength;

  @override
  Future<void> close() {
    _controller?.dispose();
    return super.close();
  }
}
