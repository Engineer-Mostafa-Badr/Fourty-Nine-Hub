import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/res/assets/assets.dart';
import 'package:video_player/video_player.dart';

class VideoCardWidget extends StatefulWidget {
  final String videoUrl;
  final bool play; // معناها هل الفيديو المختار (علشان الصوت)

  const VideoCardWidget({
    super.key,
    required this.videoUrl,
    required this.play,
  });

  @override
  State<VideoCardWidget> createState() => _VideoCardWidgetState();
}

class _VideoCardWidgetState extends State<VideoCardWidget> {
  late VideoPlayerController _controller;
  bool _isMuted = true; // الصوت مقفول افتراضياً

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
        // جميع الفيديوهات تبدأ بدون صوت
        _controller.setVolume(0);
      });
  }

  void toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 9 / 16,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                _controller.value.isInitialized
                    ? SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _controller.value.size.width,
                            height: _controller.value.size.height,
                            child: VideoPlayer(_controller),
                          ),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
                Positioned(
                  bottom: 8,
                  left: 12,
                  child: Text(
                    context.isArabic ? '2 ابريل 2023' : "Apr 2, 2023",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                Positioned(
                  top: 250,
                  bottom: -5,
                  right: -4,
                  child: IconButton(
                    icon: Icon(
                      _isMuted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                    ),
                    onPressed: toggleMute,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          context.isArabic ? 'فيجما' : 'Figma',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage(Assets.userEx),
            ),
            const SizedBox(width: 4),
            Text(
              context.isArabic ? 'عبد الرحمن_لطفي' : 'Usef Elshazly',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: context.isDarkMode ? Colors.white : Colors.grey,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.favorite_border,
              color: context.isDarkMode ? Colors.white : Colors.grey,
              size: 30.sp,
            ),
            SizedBox(width: 2),
            Text(
              '1067',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color:
                    context.isDarkMode ? Colors.white : const Color(0xff7C7C7C),
              ),
            ),
          ],
        )
      ],
    );
  }
}
