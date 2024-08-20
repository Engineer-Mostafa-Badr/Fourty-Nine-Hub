import 'dart:io';

import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/camera_picker_cubit/camera_picker_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:go_router/go_router.dart';

class CameraPicker extends StatelessWidget {
  final void Function(List<XFile> media)? onDone;
  const CameraPicker({super.key, this.onDone});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CameraPickerCubit()..init(),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(flex: 5, child: _CamView(onDone: onDone)),
              Expanded(
                flex: 1,
                child: _ImagesList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CamView extends StatelessWidget {
  final void Function(List<XFile> media)? onDone;
  const _CamView({required this.onDone});
  @override
  Widget build(BuildContext context) {
    final controller = context.read<CameraPickerCubit>();
    return Stack(
      children: [
        Positioned.fill(
          child: BlocBuilder<CameraPickerCubit, CameraPickerState>(
            buildWhen: (previous, current) =>
                current.status == CameraPickerStatus.initialized ||
                current.status == CameraPickerStatus.updateCameraView,
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
                      current.status == CameraPickerStatus.initialized ||
                      current.status == CameraPickerStatus.toggleFlashMode,
                  builder: (context, state) {
                    if (state.controller != null) {
                      return Icon(
                        _flashIcon(state.controller!.value.flashMode),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 20,
          right: 0,
          left: 0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  onDone?.call(controller.state.mediaList);
                  context.pop();
                },
                icon: const Icon(
                  Icons.check,
                ),
              ),
              BlocBuilder<CameraPickerCubit, CameraPickerState>(
                buildWhen: (previous, current) =>
                    current.status == CameraPickerStatus.initialized ||
                    current.status == CameraPickerStatus.showPhotoButton ||
                    current.status == CameraPickerStatus.showStopVideoButton ||
                    current.status == CameraPickerStatus.showStartVideoButton,
                builder: (context, state) {
                  return IconButton(
                    onPressed: () {},
                    icon: _pickIcon(state.status),
                  );
                },
              ),
              BlocBuilder<CameraPickerCubit, CameraPickerState>(
                buildWhen: (previous, current) =>
                    current.status == CameraPickerStatus.initialized,
                builder: (context, state) {
                  return IconButton(
                    onPressed: () {
                      controller.flipCamera();
                    },
                    icon: const Icon(
                      Icons.rotate_left_rounded,
                    ),
                  );
                },
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

  Widget _pickIcon(CameraPickerStatus status) {
    if (status == CameraPickerStatus.showStopVideoButton) {
      return const SizedBox(
        height: 100,
        width: 100,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Icon(
                  Icons.circle_outlined,
                  size: 100,
                ),
              ),
              Positioned.fill(
                child: Icon(
                  Icons.square_rounded,
                  size: 50,
                  color: AppColors.SECONDARY_COLOR,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox(
        height: 100,
        width: 100,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Icon(
                  Icons.circle_outlined,
                  size: 100,
                  color: Colors.white,
                ),
              ),
              Positioned.fill(
                child: Icon(
                  Icons.circle,
                  size: 50,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

class _ImagesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: BlocBuilder<CameraPickerCubit, CameraPickerState>(
            buildWhen: (previous, current) =>
                current.status == CameraPickerStatus.updateMediaList,
            builder: (context, state) {
              return ListView.builder(
                itemCount: state.mediaList.length,
                itemBuilder: (context, index) {
                  return Image.file(
                    File(state.mediaList[index].path),
                    height: 100,
                    width: 100,
                  );
                },
              );
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            children: [
              ElevatedAppButton(label: LocaleKeys.photo.tr(), onPressed: () {}),
              ElevatedAppButton(label: LocaleKeys.video.tr(), onPressed: () {}),
            ],
          ),
        ),
      ],
    );
  }
}
