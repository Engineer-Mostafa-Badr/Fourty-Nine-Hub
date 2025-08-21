import 'package:flutter/material.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../routes/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import '../../../../../helpers/manage_vibration.dart';

class InstagramReelCard extends StatefulWidget {
  final dynamic item;
  final bool? playVideo;

  const InstagramReelCard(
      {super.key, required this.item, this.playVideo = false});

  @override
  State<InstagramReelCard> createState() => _InstagramReelCardState();
}

class _InstagramReelCardState extends State<InstagramReelCard> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        widget.item.videoMedia ?? '',
      ),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
      ),
    );

    _controller!.addListener(() {
      setState(() {});
    });

    _controller!.setLooping(true);
    _controller!.initialize();
    if (widget.playVideo == true) _controller!.play();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Positioned.fill(
          child: Center(
            child: _controller == null
                ? const SizedBox.shrink()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: VideoPlayer(
                        _controller!,
                      ),
                    ),
                  ),
          ),
        ),
        if (_controller?.value.caption.text != null) ...[
          ClosedCaption(text: _controller!.value.caption.text),
          _ControlsOverlay(controller: _controller!),
          VideoProgressIndicator(
            _controller!,
            colors: const VideoProgressColors(playedColor: Colors.white),
            allowScrubbing: true,
          ),
        ],
      ],
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : ColoredBox(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 60.0,
                      semanticLabel: LocaleKeys.play.localize,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            ManageVibration.vibrate();
            if (controller.value.isPlaying) {
              controller.pause();
            } else {
              context.push(Routes.REELS);
              // controller.play();
            }
          },
        ),
      ],
    );
  }
}

class _PlayerVideoAndPopPage extends StatefulWidget {
  @override
  _PlayerVideoAndPopPageState createState() => _PlayerVideoAndPopPageState();
}

class _PlayerVideoAndPopPageState extends State<_PlayerVideoAndPopPage> {
  late VideoPlayerController _videoPlayerController;
  bool startedPlaying = false;

  @override
  void initState() {
    super.initState();

    _videoPlayerController =
        VideoPlayerController.asset('assets/Butterfly-209.mp4');
    _videoPlayerController.addListener(() {
      if (startedPlaying && !_videoPlayerController.value.isPlaying) {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<bool> started() async {
    await _videoPlayerController.initialize();
    await _videoPlayerController.play();
    startedPlaying = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: FutureBuilder<bool>(
          future: started(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data ?? false) {
              return AspectRatio(
                aspectRatio: _videoPlayerController.value.aspectRatio,
                child: VideoPlayer(_videoPlayerController),
              );
            } else {
              return const Text('waiting for video to load');
            }
          },
        ),
      ),
    );
  }
}
