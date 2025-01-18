import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/dynamic/sizer.dart';
import 'package:fourtyninehub/common/widgets/stateless/buttons/app_button.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/pages/recording/recording_shared.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/widgets/comments.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
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
  late Timer _timer;
  late int _remainingTime;


  @override
  void initState() {
    super.initState();
    context.read<ReelsCubit>().fetchReelsWithSameAudio(widget.audio.id);

    _player = AudioPlayer();
    isSave = widget.reel.isSaved;
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

  bool isSave = false;

  @override
  Widget build(BuildContext context) {
    final reelCubit = context.watch<ReelsCubit>();
    return Scaffold(
      backgroundColor:
          context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.white,
      appBar: AppBar(
        backgroundColor:
            context.isDarkMode ? AppColors.QUANTITY_COLOR : Colors.white,
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
        // title: Text(
        //   LocaleKeys.audio.tr(), // Localized "Audio"
        //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.sp
        // ),
        // ),
        actions: [
          _buildActionButton(
            Icons.share,
            iconColor: !context.isDarkMode ? Colors.black : Colors.white,
            () {
              Share.share(
                widget.audio.audioSignedUrl,
                subject: LocaleKeys.check_out_reel.tr(),
              );
            },
          ),
          // BlocBuilder<ReelsCubit, ReelsState>(
          //   builder: (context, state) {
          //     return _buildActionButton(
          //       widget.reel.isSaved && widget.reel.saveCount > 0
          //           ? Icons.bookmark
          //           : Icons.bookmark_border,
          //       iconColor: widget.reel.isSaved && widget.reel.saveCount > 0
          //           ? AppColors.YELLOW_COLOR
          //           : Colors.black87,
          //       () async {
          //         try {

          //         } catch (e) {
          //           // Handle error
          //         }
          //       },
          //     );
          //   },
          // ),
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
      body: Stack(
        children: [
          Column(
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
                          borderRadius: BorderRadius.circular(8),
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
                            Row(
                              children: [
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: NetworkImage(widget.reel.user
                                                .profilePictureSignedUrl ??
                                            ""),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                const Sizer(
                                  width: 8,
                                ),
                                Text(
                                  widget.audio.username,
                                  style: Styles.mediumText(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 25),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_player.playing) {
                          _player.stop();
                        } else {
                          _player.play();
                        }
                      });
                    },
                    icon: Icon(_player.playing ? Icons.stop : Icons.play_arrow),
                  ),
                  FutureBuilder(
  future: getAudioDuration(widget.audio.audioSignedUrl),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      if (_player.playing) {
        startCountdown(snapshot.data!);
        return Text(
          "$_remainingTime",
        );
      }
      return snapshot.data != null
          ? Text(getFormattedDuration(snapshot.data!))
          : const CircularProgressIndicator();
    } else {
      return Container();
    }
  },
),

                  const Sizer(),
                  Container(
                    height: 15,
                    width: 1,
                    color: Colors.grey,
                  ),
                  const Sizer(),
                  Text(
                    "${context.isArabic ? "الصوت الأصلي بواسطة" : "Original sound by"}: ",
                    style: Styles.smallText(fontSize: 24),
                  ),
                  Text(
                    widget.audio.username,
                    style: Styles.smallText(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    " ${widget.audio.reelsCount} posts",
                    style: Styles.smallText(
                      fontSize: 25,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: AppButton(
                        label: "",
                        backColor: context.isDarkMode
                            ? const Color(0xFF2E2E2E)
                            : const Color(0xFFF1F1F2),
                        onPressed: () {
                          setState(() {
                            isSave = !isSave;
                            context
                                .read<ReelsCubit>()
                                .saveReel(widget.reel.id)
                                .then((val) => showSnackBarAfterBuild(
                                    context: context,
                                    message: val == 'unsaved successfully'
                                        ? LocaleKeys.reel_unsaved.tr()
                                        : LocaleKeys.reel_saved.tr(),
                                    icon: val != 'unsaved successfully'
                                        ? Icons.check_circle
                                        : Icons.unpublished,
                                    backgroundColor: Colors.white,
                                    textColor: AppColors.QUANTITY_COLOR));
                          });
                        },
                        widget: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isSave
                                  ? Icons.bookmark
                                  : Icons.bookmark_border_outlined,
                              size: 25,
                              color: context.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            const Sizer(),
                            Text(
                              context.isArabic
                                  ? "أضف إلى المفضلة"
                                  : "Add to Favourites",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: context.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 30.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: BlocConsumer<ReelsCubit, ReelsState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      // log(state.reelsForAudio!.length.toString());
                      if (state.globalReelsIsLoading) {
                        return const Center(
                            child: CupertinoActivityIndicator());
                      }
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.6,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                        ),
                        itemCount: state.reelsForAudio?.length,
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
                                  height: 150,
                                  state
                                      .reelsForAudio![index].audio.audioPicture,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  bottom: 49,
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
                ),
              )
            ],
          ),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _player.dispose();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReelsRecordingScreen(
                              voiceMediaId: widget.reel.audioMedia,
                              voiceSignedUrl: widget.audio.audioSignedUrl,
                            ),
                          ));

                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.2),
                                  blurRadius: 10)
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.music_note,
                              color: Colors.black,
                            ),
                            const Sizer(),
                            Text(
                              context.isArabic ? "أضف إلى القصة" : "Add to Story",
                              style: Styles.mediumText(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Sizer(),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        _player.dispose();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ReelsRecordingScreen(
                              voiceMediaId: widget.reel.audioMedia,
                              voiceSignedUrl: widget.audio.audioSignedUrl,
                            ),
                          ));

                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppColors.PRIMARY_COLOR_DARK),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.video_library_sharp,
                              color: Colors.white,
                            ),
                            const Sizer(),
                            Text(
                              context.isArabic ? "استخدم الصوت" : "Use sound",
                              style: Styles.mediumText(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<Duration?> getAudioDuration(String url) async {
    final AudioPlayer player = AudioPlayer();

    // تحميل الملف الصوتي من الرابط
    await player.setUrl(url);

    // الحصول على مدة الصوت
    final duration = player.duration;
    return duration;
  }

  String getFormattedDuration(Duration duration) {
    if (duration.inMinutes < 1) {
      // أقل من دقيقة، عرض الثواني
      return "${duration.inSeconds} s";
    } else if (duration.inHours < 1) {
      // أقل من ساعة، عرض الدقائق
      return "${duration.inMinutes} m";
    } else if (duration.inDays < 1) {
      // أقل من يوم، عرض الساعات
      return "${duration.inHours} h";
    } else {
      // أكثر من يوم، عرض الأيام
      return "${duration.inDays} d";
    }
  }

void startCountdown(Duration duration) {
  _remainingTime = duration.inSeconds;
  _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (_remainingTime > 0) {
      setState(() {
        _remainingTime--;
      });
    } else {
      _timer.cancel();
    }
  });
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
