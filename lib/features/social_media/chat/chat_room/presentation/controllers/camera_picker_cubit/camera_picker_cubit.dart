import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

part 'camera_picker_state.dart';

class CameraPickerCubit extends Cubit<CameraPickerState> {
  CameraPickerCubit() : super(CameraPickerState());

  CameraController? _controller;
  int _selectedCamera = 0;
  final List<File> _mediaList = [];
  final Duration _maxVideoLength = const Duration(minutes: 2);
  late List<CameraDescription> _cameras;
  Completer<void>? _recordingManualCompleter;

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
        _mediaList.add(File(image.path));
      }
      emit(state.copyWith(
          status: CameraPickerStatus.updateMediaList, mediaList: _mediaList));
    } catch (e) {
      CliLogger.error('Error taking picture: $e');
    }
  }

  Future<void> startVideoRecording() async {
    try {
      _recordingManualCompleter = Completer<void>();
      await _controller?.startVideoRecording();
      emit(state.copyWith(status: CameraPickerStatus.startVideo));
      CliLogger.info('Video recording started');

      await Future.any([
        Future.delayed(_maxVideoLength),
        _recordingManualCompleter!.future,
      ]);

      if (!(_recordingManualCompleter!.isCompleted)) {
        CliLogger.info('Video recording stopped automatically');
        stopVideoRecording();
      }

      _recordingManualCompleter = null;
    } catch (e) {
      CliLogger.error("Error while starting video recording: $e");
    }
  }

  Future<void> stopVideoRecording() async {
    try {
      if (_recordingManualCompleter != null &&
          !_recordingManualCompleter!.isCompleted) {
        _recordingManualCompleter!
            .complete(); // Signal that the recording has been stopped
      }

      final XFile? tmpVideo = await _controller?.stopVideoRecording();

      emit(state.copyWith(status: CameraPickerStatus.endVideo));

      if (tmpVideo != null) {
        final File video = await _renameVideoFile(File(tmpVideo.path), '.mp4');
        CliLogger.info('Video recording stopped : ${video.path}}');
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

  void refreshMediaList({List<File>? media}) {
    emit(state.copyWith(
        status: CameraPickerStatus.updateMediaList,
        mediaList: media ?? _mediaList));
  }

  Future<File> _renameVideoFile(File originalFile, String newExtension) async {
    final originalPath = originalFile.path;

    // Create a new path with the desired extension
    final newPath = originalPath.replaceAll('.temp', newExtension);

    // Copy the file to the new path
    final newFile = await originalFile.copy(newPath);

    // Optionally, delete the old file
    await originalFile.delete();

    return newFile;
  }

  Duration get maxVideoLength => _maxVideoLength;

  @override
  Future<void> close() {
    _controller?.dispose();
    return super.close();
  }
}
