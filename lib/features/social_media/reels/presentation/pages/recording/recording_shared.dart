import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/social_media/reels/presentation/controllers/explore_reels_cubit/reel_cubit.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import 'mix_voices.dart';
import 'my_voice.dart';
import 'other_voice.dart';

import 'package:easy_localization/easy_localization.dart';

class ReelsRecordingScreen extends StatefulWidget {
  final String? voiceMediaId;
  final String? voiceSignedUrl;
  final String? comeFromCompany;
  final String? totalPrice;
  final String? advertisementType;

  const ReelsRecordingScreen(
      {super.key,
      this.voiceMediaId,
        this.voiceSignedUrl,
      this.comeFromCompany,
      this.totalPrice,
      this.advertisementType});

  @override
  ReelsRecordingScreenState createState() => ReelsRecordingScreenState();
}

class ReelsRecordingScreenState extends State<ReelsRecordingScreen> {
  final PageController _controller = PageController(
    viewportFraction: 0.3,
  );

  final List<String> options = [
    LocaleKeys.reel_voices_my_voice.tr(),
    LocaleKeys.reel_voices_other_voice.tr(),
    LocaleKeys.reel_voices_mix_voices.tr()
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Builder(
              builder: (context) {
                switch (selectedIndex) {
                  case 0:
                    return MyVoiceVideoRecordingScreen(
                      // audioMediaId: widget.voiceMediaId!,
                      // audioSignedUrl: widget.voiceSignedUrl!,
                      advertisementType: widget.advertisementType,
                      comeFrom: widget.comeFromCompany,
                      totalPrice: widget.totalPrice,
                    );
                  case 1:
                    return OtherVoiceVideoRecordingScreen(
                      voiceMediaId: widget.voiceMediaId!,
                      voiceUrl: widget.voiceSignedUrl!,
                      advertisementType: widget.advertisementType,
                      comeFrom: widget.comeFromCompany,
                      totalPrice: widget.totalPrice,
                    );
                  case 2:
                    return MixVoiceVideoRecordingScreen(
                      voiceMediaId: widget.voiceMediaId!,
                      voiceUrl: widget.voiceMediaId!,
                      advertisementType: widget.advertisementType,
                      comeFrom: widget.comeFromCompany,
                      totalPrice: widget.totalPrice,
                    );
                }
                return MyVoiceVideoRecordingScreen(
                  advertisementType: widget.advertisementType,
                  comeFrom: widget.comeFromCompany,
                  totalPrice: widget.totalPrice,
                  // audioMediaId: widget.voiceMediaId!,
                  // audioSignedUrl: widget.voiceSignedUrl!,
                );
              },
            ),
          ),
          // SizedBox(
          //   height: 20.h,
          // ),
        ],
      ),
      // bottomNavigationBar: SizedBox(
      //   height: kToolbarHeight,
      //   child: PageView.builder(
      //     controller: _controller,
      //     itemCount: widget.voiceSignedUrl == null ? 1 : options.length,
      //     onPageChanged: (int index) {
      //       setState(() {
      //         selectedIndex = index;
      //       });
      //     },
      //     itemBuilder: (context, index) {
      //       bool isSelected = index == selectedIndex;
      //       return Transform.scale(
      //         scale: isSelected ? 1.2 : 1.0,
      //         child: Center(
      //           child: Text(
      //            widget.voiceSignedUrl == null ? options[0] : options[index],
      //             style: TextStyle(
      //               // color: isSelected? Colors.black:Colors.black,
      //               fontSize: isSelected ? 35.sp : 30.sp,
      //               fontWeight: FontWeight.bold,
      //             ),
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      // ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double progress;
  final Color color;

  ProgressPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 8.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 4;
    const startAngle = -3.14 / 2;
    final sweepAngle = 2 * 3.14 * progress;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
        sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class VideoPlaybackScreen extends StatefulWidget {
  final String videoPath;

  final String thumbPath;
  final bool isAudioOriginal;
  final String? audioMediaId;
  const VideoPlaybackScreen(this.videoPath, this.thumbPath,this.isAudioOriginal, {super.key,this.audioMediaId});

  @override
  VideoPlaybackScreenState createState() => VideoPlaybackScreenState();
}

class VideoPlaybackScreenState extends State<VideoPlaybackScreen> {
  late VideoPlayerController _controller;
  bool _showPlayPauseIcon = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      })
      ..setLooping(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: _controller.value.isInitialized
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GestureDetector(
                      onTap: () {
                        _togglePlayPause();
                      },
                      child: VideoPlayer(_controller)),
                  buildPlayPauseIcon(),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.w, vertical: 40.h),
                    child: BlocBuilder<ReelsCubit, ReelsState>(
                      builder: (context, state) {
                        return ElevatedButton(
                            onPressed: () async {
                              print('audioMedia ${widget.audioMediaId}');
                              // print('audioPath ${widget.videoPath}');
                             // await context.read<ReelsCubit>().uploadReel(
                             //      File(widget.videoPath),
                             //      File(widget.thumbPath),widget.isAudioOriginal,audioMediaId: widget.audioMediaId);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.PRIMARY_COLOR,
                                textStyle:
                                    Styles.mediumText(color: Colors.white),
                                minimumSize: Size(double.infinity, 60.h),
                                padding: EdgeInsets.symmetric(vertical: 30.h)),
                            child: Text(
                              'Share',
                              style: Styles.mediumText(color: Colors.white),
                            ));
                      },
                    ),
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  void _pauseVideo() {
    if (_controller.value.isPlaying) {
      _controller.pause();

      // _chewieController?.pause();
      setState(() {
        // _controller.value.isPlaying = false;
        _showPlayPauseIcon = true;
      });
      _hidePlayPauseIconAfterDelay();
    }
  }

  /// Toggles between play and pause states.
  void _togglePlayPause() {
    _controller.value.isPlaying ? _pauseVideo() : _playVideo();
  }

  void _playVideo() {
    if (!_controller.value.isPlaying) {
      _controller.play();
      // _chewieController?.play();
      setState(() {
        // _controller.value.isPlaying = true;
        _showPlayPauseIcon = true;
      });
      _hidePlayPauseIconAfterDelay();
    }
  }

  void _hidePlayPauseIconAfterDelay() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _showPlayPauseIcon = false;
        });
      }
    });
  }

  Widget buildPlayPauseIcon() {
    return AnimatedOpacity(
      opacity: _showPlayPauseIcon ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 100,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
