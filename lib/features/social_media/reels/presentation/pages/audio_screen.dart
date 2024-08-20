import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/social_media/reels/data/models/new_reels_model.dart';
import 'package:fourtyninehub/features/social_media/tinder/presentation/pages/user_profile.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:just_audio/just_audio.dart';

/// InstagramAudioScreen is a stateful widget displaying a more complex audio screen with play/pause functionality.
///
///
///

class InstagramAudioScreen extends StatefulWidget {
  final Audio audio;

  const InstagramAudioScreen({super.key, required this.audio});

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
    _player = AudioPlayer();

    // Listen to the player state stream for completion
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
      // _player.play();
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
      // Restart the audio if it has completed
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: const Icon(
          Icons.arrow_back,
          color: Colors.white,
        ),
        title: const Text('Audio',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: const [
          Icon(
            Icons.share,
            color: Colors.white,
          ),
          SizedBox(width: 16),
          Icon(Icons.bookmark, color: Colors.white),
          SizedBox(width: 16),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    widget.audio.audioPicture,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        capitalizeAndSplit2Parts(widget.audio.audioName),
                        softWrap: true,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(capitalizeAndSplit2Parts(widget.audio.username),
                          style: const TextStyle(color: Colors.white)),
                      Text('${widget.audio.reelsCount} reels',
                          style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          AppColors.PRIMARY_COLOR_DARK)),
                  onPressed: () {},
                  child: const Text(
                    'Use audio',
                    textScaler: TextScaler.linear(1.1),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          _hasError
              ? const Center(
                  child: Text(
                    'Failed to load audio!',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<PlayerState>(
                        stream: _player.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          // final processingState = playerState?.processingState;
                          final playing = playerState?.playing;
                          // if (processingState == ProcessingState.loading ||
                          //     processingState == ProcessingState.buffering) {
                          //   return const CupertinoActivityIndicator();
                          // } else
                          if (playing != true) {
                            return IconButton(
                              icon: const Icon(Icons.play_arrow,
                                  color: Colors.white),
                              onPressed: _togglePlayPause,
                            );
                          } else {
                            return IconButton(
                              icon:
                                  const Icon(Icons.pause, color: Colors.white),
                              onPressed: _togglePlayPause,
                            );
                          }
                        },
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: StreamBuilder<Duration>(
                            stream: _player.positionStream,
                            builder: (context, snapshot) {
                              final position = snapshot.data ?? Duration.zero;
                              final duration =
                                  _player.duration ?? Duration.zero;

                              // Ensure the slider value is within bounds
                              double sliderValue =
                                  position.inMilliseconds.toDouble();
                              if (sliderValue >
                                  duration.inMilliseconds.toDouble()) {
                                sliderValue =
                                    duration.inMilliseconds.toDouble();
                              }

                              return Slider(
                                value: sliderValue,
                                max: duration.inMilliseconds.toDouble(),
                                onChanged: (value) {
                                  _player.seek(
                                      Duration(milliseconds: value.toInt()));
                                },
                                activeColor: Colors.white,
                                inactiveColor: Colors.grey,
                              );
                            },
                          ),
                        ),
                      ),
                      StreamBuilder<Duration>(
                        stream: _player.positionStream,
                        builder: (context, snapshot) {
                          final position = snapshot.data ?? Duration.zero;
                          final positionText = formatDuration(position);
                          return Text(positionText,
                              style: const TextStyle(color: Colors.white));
                        },
                      ),
                    ],
                  ),
                ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.7,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: 20,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Image.network(
                        'https://images.unsplash.com/photo-1723643136002-d49a1d7309d1?q=80&w=1907&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                        fit: BoxFit.cover),
                    const Positioned(
                      bottom: 8,
                      left: 8,
                      child: Row(
                        children: [
                          Icon(Icons.play_arrow, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text('1,234', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
