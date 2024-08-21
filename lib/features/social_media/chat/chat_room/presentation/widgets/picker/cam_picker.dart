import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
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
              Expanded(flex: 4, child: _CamView(onDone: onDone)),
              Expanded(flex: 1, child: _ImagesList()),
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
              BlocBuilder<CameraPickerCubit, CameraPickerState>(
                buildWhen: (previous, current) =>
                    current.pickMode == PickMode.video ||
                    current.status == CameraPickerStatus.updateVideoLength,
                builder: (context, state) {
                  if (state.currentVideoLength != null) {
                    return Text(
                      '${state.currentVideoLength!.inSeconds ~/ 60} : ${state.currentVideoLength!.inSeconds % 60}',
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
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
                  onDone?.call(controller.state.mediaList ?? []);
                  context.pop();
                },
                icon: const Icon(
                  Icons.check,
                ),
              ),
              BlocBuilder<CameraPickerCubit, CameraPickerState>(
                buildWhen: (previous, current) =>
                    current.pickMode != previous.pickMode ||
                    current.status == CameraPickerStatus.updateVideoLength,
                builder: (context, state) {
                  if (state.pickMode == PickMode.photo) {
                    return IconButton(
                      onPressed: () {
                        controller.takePicture();
                      },
                      icon: const Icon(Icons.circle, size: 100),
                    );
                  } else if (state.status == CameraPickerStatus.startVideo &&
                      state.currentVideoLength != null) {
                    return InkWell(
                      onTap: () {
                        controller.stopVideoRecording();
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: 1 -
                                (state.currentVideoLength!.inSeconds /
                                    controller.maxVideoLength.inSeconds),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.SECONDARY_COLOR),
                            backgroundColor: Colors.white,
                            strokeWidth: 8.0,
                          ),
                          const Icon(
                            Icons.square_rounded,
                            color: AppColors.SECONDARY_COLOR,
                            size: 60,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return IconButton(
                      onPressed: () {
                        controller.startVideoRecording();
                      },
                      icon: const Icon(Icons.circle, size: 100),
                    );
                  }
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
}

class _ImagesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<CameraPickerCubit>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return BlocBuilder<CameraPickerCubit, CameraPickerState>(
                  buildWhen: (previous, current) =>
                      current.status == CameraPickerStatus.updateMediaList,
                  builder: (context, state) {
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      scrollDirection: Axis.horizontal,
                      itemCount: state.mediaList?.length ?? 0,
                      separatorBuilder: (context, index) => const Sizer(),
                      itemBuilder: (context, index) {
                        return Container(
                          width: constraints.maxHeight,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: FileImage(
                                  File(state.mediaList![index].path),
                                ),
                                fit: BoxFit.cover),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<CameraPickerCubit, CameraPickerState>(
                  buildWhen: (previous, current) =>
                      current.pickMode != previous.pickMode,
                  builder: (context, state) {
                    return ElevatedAppButton(
                      label: LocaleKeys.photo,
                      backColor: state.pickMode == PickMode.photo
                          ? AppColors.SECONDARY_COLOR
                          : null,
                      onPressed: () {
                        controller.emitPhotoPickMode();
                      },
                    );
                  },
                ),
                const Sizer(),
                BlocBuilder<CameraPickerCubit, CameraPickerState>(
                  buildWhen: (previous, current) =>
                      current.pickMode != previous.pickMode,
                  builder: (context, state) {
                    return ElevatedAppButton(
                      label: LocaleKeys.video,
                      backColor: state.pickMode == PickMode.video
                          ? AppColors.SECONDARY_COLOR
                          : null,
                      onPressed: () {
                        controller.emitVideoPickMode();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
