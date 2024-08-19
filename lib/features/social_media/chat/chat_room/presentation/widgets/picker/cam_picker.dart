import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/camera_picker_cubit/camera_picker_cubit.dart';
import 'package:go_router/go_router.dart';

class CameraPicker extends StatelessWidget {
  const CameraPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CameraPickerCubit()..init(),
      child: SafeArea(
          child: Scaffold(
        body: Column(
          children: [
            Expanded(flex: 5, child: _CamView()),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.amber,
              ),
            ),
          ],
        ),
      )),
    );
  }
}

class _CamView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<CameraPickerCubit>();
    return Stack(
      children: [
        Positioned.fill(
          child: BlocBuilder<CameraPickerCubit, CameraPickerState>(
            buildWhen: (previous, current) =>
                current.status == CameraPickerStatus.init ||
                current.status == CameraPickerStatus.showCameraPreview,
            builder: (context, state) {
              if (state.controller != null) {
                return CameraPreview(state.controller!);
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
        Positioned(
          top: 20,
          right: 0,
          left: 0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(
                  Icons.close,
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.toggleFlashMode();
                },
                icon: BlocBuilder<CameraPickerCubit, CameraPickerState>(
                  buildWhen: (previous, current) =>
                      current.status == CameraPickerStatus.init ||
                      current.status == CameraPickerStatus.toggleFlashMode,
                  builder: (context, state) {
                    return Icon(
                      _flashIcon(state.controller!.value.flashMode),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 20,
          right: 0,
          left: 0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.close,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.fiber_manual_record,
                  color: Colors.white,
                  size: 100,
                ),
              ),
              IconButton(
                onPressed: () {
                  controller.flipCamera();
                },
                icon: const Icon(
                  Icons.rotate_left_rounded,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _flashIcon(FlashMode flashMode) {
    switch (flashMode) {
      case FlashMode.off:
        return Icons.flash_off;
      case FlashMode.auto:
        return Icons.flash_auto;
      case FlashMode.always:
        return Icons.flash_on;
      case FlashMode.torch:
        return Icons.flashlight_on_rounded;
    }
  }
}
