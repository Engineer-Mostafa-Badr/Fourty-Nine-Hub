import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'mix_voices.dart';
import 'my_voice.dart';
import 'other_voice.dart';

class ReelsRecordingScreen extends StatefulWidget {
  final String? voiceUrl;
  final String? comeFromCompany;
  final String? totalPrice;
  final String? advertisementType;

  const ReelsRecordingScreen({super.key, this.voiceUrl, this.comeFromCompany, this.totalPrice, this.advertisementType});

  @override
  ReelsRecordingScreenState createState() => ReelsRecordingScreenState();
}

class ReelsRecordingScreenState extends State<ReelsRecordingScreen> {
  final PageController _controller = PageController(
    viewportFraction: 0.3,
  );

  final List<String> options = ['My Voice', 'Other Voice', 'Mix Voices'];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          const SizedBox(
            height: 20,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: kToolbarHeight,
        color: Colors.black,
        child: PageView.builder(
          controller: _controller,
          itemCount: options.length,
          onPageChanged: (int index) {
            setState(() {
              selectedIndex = index;
            });
            // _navigateToScreen(index);
          },
          itemBuilder: (context, index) {
            bool isSelected = index == selectedIndex;
            return Transform.scale(
              scale: isSelected ? 1.2 : 1.0,
              child: Center(
                child: Text(
                  options[index],
                  style: TextStyle(
                    fontSize: 18,
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle, sweepAngle, false, paint);
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
      appBar: AppBar(title: const Text('Video Playback')),
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

class HorizontalTextWheelPicker extends StatefulWidget {
  final List<String> options;
  final Function(int) onSelectedItemChanged;

  const HorizontalTextWheelPicker({
    super.key,
    required this.options,
    required this.onSelectedItemChanged,
  });

  @override
  HorizontalTextWheelPickerState createState() => HorizontalTextWheelPickerState();
}

class HorizontalTextWheelPickerState extends State<HorizontalTextWheelPicker> {
  late int selectedItemIndex;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    selectedItemIndex = 1; // Set the second item as initially selected
    _scrollController = FixedExtentScrollController(initialItem: selectedItemIndex);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: RotatedBox(
        quarterTurns: 3,
        child: ListWheelScrollView.useDelegate(
          controller: _scrollController,
          itemExtent: 100,
          // Adjust this for the size of each item
          diameterRatio: 1.5,
          onSelectedItemChanged: (index) {
            setState(() {
              selectedItemIndex = index;
            });
            widget.onSelectedItemChanged(index);
          },
          physics: const FixedExtentScrollPhysics(),
          childDelegate: ListWheelChildBuilderDelegate(
            builder: (context, index) {
              final isSelected = index == selectedItemIndex;
              return RotatedBox(
                quarterTurns: 1,
                child: Center(
                  child: FittedBox(
                    child: Text(
                      widget.options[index],
                      style: TextStyle(
                        fontSize: 20,
                        color: isSelected ? Colors.white : Colors.white38,
                      ),
                    ),
                  ),
                ),
              );
            },
            childCount: widget.options.length,
          ),
        ),
      ),
    );
  }
}
