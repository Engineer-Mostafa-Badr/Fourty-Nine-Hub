import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/utils/toast.dart';

import '../../../../../../../routes/pages.dart';

part 'camera_picker_state.dart';

class CameraPickerCubit extends Cubit<CameraPickerState> {
  CameraPickerCubit() : super(CameraPickerState());

  late CameraController _controller;
  int _selectedCamera = 0;
  final List<XFile> _mediaList = [];
  final Duration _videoDuration = const Duration(minutes: 2);
  List<CameraDescription> _cameras = [];

  @override
  void onChange(Change<CameraPickerState> change) {
    log('state is ${change.currentState}');
    log('state next ${change.nextState}');
    super.onChange(change);
  }

  Future<void> init() async {
    try {
      _cameras = await availableCameras();
      _controller =
          CameraController(_cameras[_selectedCamera], ResolutionPreset.medium);

      await _controller.initialize();
      await _controller.setFlashMode(FlashMode.off);
      emit(state.copyWith(
          controller: _controller, status: CameraPickerStatus.initialized));
    } catch (e) {
      showErrorMessage(
          AppPages.router.configuration.navigatorKey.currentContext!, ' $e');
      throw '$e';
    }
  }

  void flipCamera() {
    _selectedCamera = _selectedCamera == 0 ? 1 : 0;
    _controller.setDescription(_cameras[_selectedCamera]);
    emit(state.copyWith(
        status: CameraPickerStatus.updateCameraView, controller: _controller));
  }

  Future<void> toggleFlashMode() async {
    FlashMode newFlashMode = _controller.value.flashMode == FlashMode.off
        ? FlashMode.torch
        : FlashMode.off;

    await _controller.setFlashMode(newFlashMode);
    emit(state.copyWith(
        status: CameraPickerStatus.toggleFlashMode, controller: _controller));
  }

  Future<void> takePicture() async {
    // emit(CameraPickerLoading());
    try {
      final XFile image = await _controller.takePicture();
      _mediaList.add(image);
      emit(state.copyWith(
          status: CameraPickerStatus.updateMediaList, mediaList: _mediaList));
      // emit(CameraPickerLoaded());
    } catch (e) {
      debugPrint(
          '==================================== Error taking picture: $e');
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
    _mediaList.add(video);
  }

  @override
  Future<void> close() {
    _controller.dispose();
    return super.close();
  }
}
