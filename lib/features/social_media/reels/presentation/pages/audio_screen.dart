import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/main_reel_view.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/recording/recording_shared.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../routes/routes.dart';
import '../../../tinder/data/shared/shared.dart';
import '../../../twitter/presentation/widgets/report_view.dart';
import '../../data/models/new_reels_model.dart';
import '../controllers/explore_reels_cubit/reel_cubit.dart';
import '../widgets/components/snackbars.dart';
import 'audio_reel_view.dart';
import 'package:easy_localization/easy_localization.dart';

class InstagramAudioScreen extends StatefulWidget {
  final Audio audio;
  final Reel reel;

  const InstagramAudioScreen(
      {super.key, required this.audio, required this.reel});

  @override
  State<InstagramAudioScreen> createState() => _InstagramAudioScreenState();
}

class _InstagramAudioScreenState extends State<InstagramAudioScreen> {
  late AudioPlayer _player;
  bool _hasError = false;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    context.read<ReelsCubit>().fetchReelsWithSameAudio(widget.audio.id);

    _player = AudioPlayer();

    _player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        setState(() {
          _isCompleted = true;
          _player.seek(Duration.zero).then((value) => _player.pause());
        });
      }
    });

    _initializeAudio();
  }

  Future<void> _initializeAudio() async {
    try {
      await _player.setUrl(widget.audio.audioSignedUrl);
    } catch (e) {
      setState(() {
        _hasError = true;
      });
      log('Error loading audio: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_isCompleted) {
      _player.seek(Duration.zero);
      setState(() {
        _isCompleted = false;
      });
    }

    setState(() {
      if (_player.playing) {
        _player.pause();
      } else {
        _player.play();
      }
    });
  }

  Widget _buildActionButton(IconData icon, VoidCallback function,
      {Color? iconColor}) {
    return IconButton(
      onPressed: function,
      icon: Icon(
        icon,
        size: 50.h,
        color: iconColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reelCubit = context.watch<ReelsCubit>();
    return Scaffold(
      backgroundColor: context.isDarkMode ? Colors.black87 : Colors.white,
      appBar: AppBar(
        backgroundColor: context.isDarkMode ? Colors.black87 : Colors.white,
        toolbarHeight: kToolbarHeight * 0.8,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 50.h,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          LocaleKeys.audio.tr(), // Localized "Audio"
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.sp),
        ),
        actions: [
          _buildActionButton(
            Icons.send,
            iconColor: Colors.black87,
            () {
              Share.share(
                widget.audio.audioSignedUrl,
                subject: LocaleKeys.check_out_reel.tr(),
              );
            },
          ),
          BlocBuilder<ReelsCubit, ReelsState>(
            builder: (context, state) {
              return _buildActionButton(
                widget.reel.isSaved && widget.reel.saveCount > 0
                    ? Icons.bookmark
                    : Icons.bookmark_border,
                iconColor: widget.reel.isSaved && widget.reel.saveCount > 0
                    ? AppColors.YELLOW_COLOR
                    : Colors.black87,
                () async {
                  try {
                    context.read<ReelsCubit>().saveReel(widget.reel.id).then(
                        (val) => showSnackBarAfterBuild(
                            context: context,
                            message: val == 'unsaved successfully'
                                ? LocaleKeys.reel_unsaved.tr()
                                : LocaleKeys.reel_saved.tr(),
                            icon: val != 'unsaved successfully'
                                ? Icons.check_circle
                                : Icons.unpublished,
                            backgroundColor: Colors.white,
                            textColor: AppColors.QUANTITY_COLOR));
                  } catch (e) {
                    // Handle error
                  }
                },
              );
            },
          ),
          _buildActionButton(
            Icons.report_outlined,
            iconColor: AppColors.PRIMARY_COLOR_DARK,
            () async {
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                builder: (context) {
                  return SizedBox(
                    height: isKeyboardVisible(context) ? 0.8.sh : 0.6.sh,
                    child: ReportView(
                      id: widget.reel.id,
                      categoryId: '66684135dbb427ee42aa0141',
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => context.push(Routes.OTHERSACCOUNT,
                  extra: widget.reel.user.id),
              child: Row(
                children: [
                  Container(
                    width: 150.h,
                    height: 150.h,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.audio.audioPicture),
                          fit: BoxFit.cover),
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          capitalizeAndSplit(widget.audio.username),
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 35.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          reelText(widget.audio.reelsCount),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 30.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(AppColors.PRIMARY_COLOR)),
                    onPressed: () {
                      _player.dispose();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReelsRecordingScreen(
                              voiceUrl: widget.audio.audioSignedUrl,
                            ),
                          ));
                    },
                    child: Text(
                      LocaleKeys.use_audio.tr(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 35.sp),
                    ),
                  ),
                ),
              ),
            ),
          ),
          _hasError
              ? Center(
                  child: Text(
                    LocaleKeys.audio_load_fail.tr(),
                    style: const TextStyle(),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<PlayerState>(
                        stream: _player.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final playing = playerState?.playing;
                          if (playing != true) {
                            return IconButton(
                              icon: const Icon(
                                Icons.play_arrow,
                              ),
                              onPressed: _togglePlayPause,
                            );
                          } else {
                            return IconButton(
                              icon: const Icon(
                                Icons.pause,
                              ),
                              onPressed: _togglePlayPause,
                            );
                          }
                        },
                      ),
                      Expanded(
                        child: StreamBuilder<Duration>(
                          stream: _player.positionStream,
                          builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            final duration = _player.duration ?? Duration.zero;

                            double sliderValue =
                                position.inMilliseconds.toDouble();
                            if (sliderValue >
                                duration.inMilliseconds.toDouble()) {
                              sliderValue = duration.inMilliseconds.toDouble();
                            }

                            return Slider(
                              value: sliderValue,
                              max: duration.inMilliseconds.toDouble(),
                              onChanged: (value) {
                                _player.seek(
                                    Duration(milliseconds: value.toInt()));
                              },
                            );
                          },
                        ),
                      ),
                      StreamBuilder<Duration>(
                        stream: _player.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;
                          final positionText = formatDuration(position);
                          return Text(
                            positionText,
                            style: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                    ],
                  ),
                ),
          Expanded(
            child: BlocConsumer<ReelsCubit, ReelsState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state.globalReelsIsLoading) {
                  return const Center(child: CupertinoActivityIndicator());
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.6,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: state.reelsForAudio!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: serviceLocator<ReelsCubit>(),
                                child: ReelsScreenForAudio(
                                  navigateTo: index,
                                  reels: state.reelsForAudio!,
                                ),
                              ),
                            ));
                      },
                      child: Stack(
                        children: [
                          Image.network(
                            width: double.infinity,
                            height: double.infinity,
                            state.reelsForAudio![index].thumbnailSignedUrl,
                            errorBuilder: (context, error, stackTrace) =>
                                const Center(
                              child: CupertinoActivityIndicator(),
                            ),
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 8,
                            left: 2,
                            child: Row(
                              children: [
                                const Icon(Icons.play_arrow, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  state.reelsForAudio![index].viewCount
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  String reelText(int reelCount) {
    if (reelCount == 0) {
      return LocaleKeys.no_reels.tr();
    } else if (reelCount == 1) {
      return LocaleKeys.one_reel.tr();
    } else {
      return "$reelCount ${LocaleKeys.multiple_reels.tr()}";
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
