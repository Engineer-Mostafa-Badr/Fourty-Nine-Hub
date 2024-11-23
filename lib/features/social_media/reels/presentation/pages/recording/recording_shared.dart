import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import 'mix_voices.dart';
import 'my_voice.dart';
import 'other_voice.dart';

import 'package:easy_localization/easy_localization.dart';

class ReelsRecordingScreen extends StatefulWidget {
  final String? voiceUrl;
  final String? comeFromCompany;
  final String? totalPrice;
  final String? advertisementType;

  const ReelsRecordingScreen(
      {super.key,
      this.voiceUrl,
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
                      advertisementType: widget.advertisementType,
                      comeFrom: widget.comeFromCompany,
                      totalPrice: widget.totalPrice,
                    );
                  case 1:
                    return OtherVoiceVideoRecordingScreen(
                      voiceUrl: widget.voiceUrl ?? '',
                      advertisementType: widget.advertisementType,
                      comeFrom: widget.comeFromCompany,
                      totalPrice: widget.totalPrice,
                    );
                  case 2:
                    return MixVoiceVideoRecordingScreen(
                      voiceUrl: widget.voiceUrl ?? '',
                      advertisementType: widget.advertisementType,
                      comeFrom: widget.comeFromCompany,
                      totalPrice: widget.totalPrice,
                    );
                }
                return MyVoiceVideoRecordingScreen(
                  advertisementType: widget.advertisementType,
                  comeFrom: widget.comeFromCompany,
                  totalPrice: widget.totalPrice,
                );
              },
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: kToolbarHeight,
        child: PageView.builder(
          controller: _controller,
          itemCount: options.length,
          onPageChanged: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          itemBuilder: (context, index) {
            bool isSelected = index == selectedIndex;
            return Transform.scale(
              scale: isSelected ? 1.2 : 1.0,
              child: Center(
                child: Text(
                  options[index],
                  textScaleFactor: 1.0,
                  style: TextStyle(
                    // color: isSelected? Colors.black:Colors.black,
                    fontSize: isSelected ? 35.sp : 30.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ),
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

  const VideoPlaybackScreen(this.videoPath, {super.key});

  @override
  VideoPlaybackScreenState createState() => VideoPlaybackScreenState();
}

class VideoPlaybackScreenState extends State<VideoPlaybackScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        'Video Playback',
        textScaleFactor: 1.0,
        style: TextStyle(fontSize: 45.sp),
      )),
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
