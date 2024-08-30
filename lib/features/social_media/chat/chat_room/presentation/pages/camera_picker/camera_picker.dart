import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/elevated_button.dart';
import 'package:fourtyninehub/core/enums/club_house_layout_mode_enum.dart';
import 'package:fourtyninehub/core/extensions/file_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/presentation/controllers/camera_picker_cubit/camera_picker_cubit.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/zego_uikit_prebuilt_live_streaming.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:fourtyninehub/routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pro_image_editor/pro_image_editor.dart';
import 'package:shimmer/shimmer.dart';
import 'package:image/image.dart' as img;
import 'package:video_trimmer/video_trimmer.dart';

part 'media_slider.dart';

class CameraPickerView extends StatelessWidget {
  final void Function(List<XFile> media)? onDone;

  const CameraPickerView({super.key, this.onDone});

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

class _CamView extends StatefulWidget {
  final void Function(List<XFile> media)? onDone;

  const _CamView({required this.onDone});

  @override
  State<_CamView> createState() => _CamViewState();
}

class _CamViewState extends State<_CamView> {
  @override
  Widget build(BuildContext context) {
    final controller = context.read<CameraPickerCubit>();
    return Stack(
      children: [
        Positioned.fill(
          child: BlocBuilder<CameraPickerCubit, CameraPickerState>(
            builder: (context, state) {
              if (state.controller != null &&
                  state.status != CameraPickerStatus.loadingCamera) {
                return CameraPreview(state.controller!);
              } else if (state.status ==
                  CameraPickerStatus.needCameraPermission) {
                return _permissionButton(LocaleKeys.allowAccessToYourCamera);
              } else if (state.status ==
                  CameraPickerStatus.needMicrophonePermission) {
                return _permissionButton(
                    LocaleKeys.allowAccessToYourMicrophone);
              } else {
                return const Icon(Icons.camera,
                    color: AppColors.GREY_DARK_COLOR, size: 150);
              }
            },
          ),
        ),
        Positioned(
          top: 20.zH,
          right: 0,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<CameraPickerCubit, CameraPickerState>(
                  builder: (context, state) {
                    if (state.status != CameraPickerStatus.startVideo) {
                      return _BaseIcon(
                        icon: Icons.close,
                        onTap: () => context.pop(),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                BlocBuilder<CameraPickerCubit, CameraPickerState>(
                  builder: (context, state) {
                    if (state.status == CameraPickerStatus.startVideo) {
                      return _VideoTimer(duration: controller.maxVideoLength);
                    } else if (state.pickMode == PickMode.video &&
                        state.controller != null) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.GREY_DARK_COLOR.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '00 : 00',
                          style: Styles.mediumText(color: Colors.white),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                BlocBuilder<CameraPickerCubit, CameraPickerState>(
                  builder: (context, state) {
                    if (state.controller != null &&
                        state.status != CameraPickerStatus.startVideo) {
                      return _BaseIcon(
                        icon: _flashIcon(
                          state.controller!.value.flashMode,
                        ),
                        onTap: () => controller.toggleFlashMode(),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 20.zH,
          right: 0,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<CameraPickerCubit, CameraPickerState>(
                  builder: (context, state) {
                    if (state.status != CameraPickerStatus.startVideo &&
                        state.controller != null) {
                      return _BaseIcon(
                        icon: Icons.check,
                        onTap: () {
                          final media =
                              context.read<CameraPickerCubit>().state.mediaList;
                          if (media != null && media.isNotEmpty) {
                            context
                                .push(Routes.MEDIASLIDER,
                                    extra: MediaSliderViewParams(media: media))
                                .then((value) => context
                                    .read<CameraPickerCubit>()
                                    .refreshMediaList());
                          } else {
                            showErrorMessage(
                                context, LocaleKeys.pickPhotoOrVideo);
                          }
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                BlocBuilder<CameraPickerCubit, CameraPickerState>(
                  builder: (context, state) {
                    if (state.controller != null &&
                        state.controller!.value.isInitialized) {
                      if (state.pickMode == PickMode.photo) {
                        return IconButton(
                          onPressed: () {
                            controller.takePicture();
                          },
                          icon: _pickIcon,
                        );
                      } else if (state.status ==
                          CameraPickerStatus.startVideo) {
                        return InkWell(
                          onTap: () {
                            controller.stopVideoRecording();
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              _VideoCircularIndicator(
                                  duration: controller.maxVideoLength),
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
                          icon: _pickIcon,
                        );
                      }
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                BlocBuilder<CameraPickerCubit, CameraPickerState>(
                  builder: (context, state) {
                    if (state.controller != null &&
                        state.status != CameraPickerStatus.startVideo) {
                      return _BaseIcon(
                        onTap: () {
                          CliLogger.info('Flip camera');
                          controller.flipCamera();
                        },
                        icon: Icons.rotate_left_rounded,
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
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

  Widget get _pickIcon =>
      const Icon(Icons.circle, size: 80, color: Colors.white);

  Widget _permissionButton(String label) {
    return InkWell(
        onTap: () async {
          openAppSettings().then((value) {
            if (value) {
              context.read<CameraPickerCubit>().init();
            }
          });
        },
        child: Center(
          child: Text(label, style: Styles.headerText()),
        ));
  }
}

class _BaseIcon extends StatelessWidget {
  final Color? color;
  final IconData icon;
  final double? iconSize;
  final void Function()? onTap;

  const _BaseIcon({super.key, this.color, required this.icon, this.onTap, this.iconSize});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding:  EdgeInsets.all(15.zH),
        decoration: BoxDecoration(
          color: (color ?? AppColors.GREY_DARK_COLOR).withOpacity(0.5),
          borderRadius: BorderRadius.circular(50.zR),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: iconSize,
        ),
      ),
    );
  }
}

class _ImagesList extends StatefulWidget {
  @override
  State<_ImagesList> createState() => _ImagesListState();
}

class _ImagesListState extends State<_ImagesList> {
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
                        final file = File(state.mediaList![index].path);
                        if (file.isImage) {
                          return _mediaContainer(
                              image: FileImage(file),
                              width: constraints.maxHeight,
                              index: index,
                              media: state.mediaList!);
                        } else {
                          return FutureBuilder<Uint8List?>(
                            future: generateThumbnail(path: file.path),
                            builder:
                                (context, AsyncSnapshot<Uint8List?> snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data != null &&
                                  snapshot.data!.isNotEmpty) {
                                return _mediaContainer(
                                    image: MemoryImage(snapshot.data!),
                                    width: constraints.maxHeight,
                                    isPhoto: false,
                                    index: index,
                                    media: state.mediaList!);
                              } else {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: constraints.maxHeight,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        }
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
                        if (controller.state.status !=
                            CameraPickerStatus.startVideo) {
                          controller.emitPhotoPickMode();
                        }
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

  Widget _mediaContainer(
      {required ImageProvider image,
      required double width,
      required int index,
      required List<File> media,
      bool isPhoto = true}) {
    return InkWell(
      onTap: () {
        if (mounted) {
          context
              .push(Routes.MEDIASLIDER,
                  extra:
                      MediaSliderViewParams(media: media, initialIndex: index))
              .then((value) =>
                  context.read<CameraPickerCubit>().refreshMediaList());
        }
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(image: image, fit: BoxFit.cover),
        ),
        child: !isPhoto
            ? const Center(
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                ),
              )
            : null,
      ),
    );
  }
}

class _VideoTimer extends StatefulWidget {
  final Duration duration;

  const _VideoTimer({required this.duration});

  @override
  State<_VideoTimer> createState() => __VideoTimerState();
}

class __VideoTimerState extends State<_VideoTimer> {
  Timer? _timer;
  String _timerText = '00 : 00';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick <= widget.duration.inSeconds) {
        int minutes = (timer.tick ~/ 60);
        int seconds = (timer.tick % 60);
        setState(() {
          _timerText =
              '${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
        });
        CliLogger.info(_timerText);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.SECONDARY_COLOR.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _timerText,
        style: Styles.mediumText(color: Colors.white),
      ),
    );
  }
}

class _VideoCircularIndicator extends StatefulWidget {
  final Duration duration;

  const _VideoCircularIndicator({required this.duration});

  @override
  State<_VideoCircularIndicator> createState() =>
      __VideoCircularIndicatorState();
}

class __VideoCircularIndicatorState extends State<_VideoCircularIndicator> {
  Timer? _timer;
  int _time = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick <= widget.duration.inSeconds) {
        setState(() {
          _time = timer.tick;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: CircularProgressIndicator(
        value: 1 - (_time / widget.duration.inSeconds),
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        backgroundColor: AppColors.SECONDARY_COLOR,
      ),
    );
  }
}
