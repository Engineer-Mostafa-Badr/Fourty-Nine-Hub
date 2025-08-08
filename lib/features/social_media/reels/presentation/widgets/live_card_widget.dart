import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../res/assets/assets.dart';
import 'package:video_player/video_player.dart';

class LiveCardWidget extends StatefulWidget {
  final String videoUrl;

  const LiveCardWidget({super.key, required this.videoUrl});

  @override
  State<LiveCardWidget> createState() => _LiveCardWidgetState();
}

class _LiveCardWidgetState extends State<LiveCardWidget> {
  late VideoPlayerController _controller;
  bool _isMuted = true;

  @override
  void initState() {
    super.initState();
    // ignore: deprecated_member_use
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
        _controller.setVolume(_isMuted ? 0 : 1);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0 : 1);
    });
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
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
                const Positioned(
                  top: 10,
                  right: 90,
                  child: LiveViewersWidget(),
                ),
                Positioned(
                  top: -5,
                  right: 2,
                  child: IconButton(
                    icon: Icon(
                      _isMuted ? Icons.volume_off : Icons.volume_up,
                      color: Colors.white,
                      size: 40.sp,
                    ),
                    onPressed: toggleMute,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundImage: AssetImage(Assets.userEx),
            ),
            const SizedBox(width: 5),
            Text(
              context.isArabic ? 'يوسف الشازلي' : 'Usef Elshazly',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.w500,
                color: context.isDarkMode ? Colors.white : Colors.grey,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class LiveViewersWidget extends StatelessWidget {
  const LiveViewersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomRight: Radius.circular(8),
        topRight: Radius.circular(8),
        bottomLeft: Radius.circular(8),
        topLeft: Radius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Text(
              context.isArabic ? 'مباشر' : 'LIVE',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 10,
              ),
            ),
          ),
          Container(
            color: const Color(0xFF3D3C38),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: const Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 10,
                ),
                SizedBox(width: 4),
                Text(
                  '183',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
