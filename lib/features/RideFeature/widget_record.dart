import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class RecordPlayerWidget extends StatefulWidget {
  final String mp3Path; // Path to the MP3 file (asset or local)

  const RecordPlayerWidget({Key? key, required this.mp3Path}) : super(key: key);

  @override
  _RecordPlayerWidgetState createState() => _RecordPlayerWidgetState();
}

class _RecordPlayerWidgetState extends State<RecordPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Listen for duration changes
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        _duration = d;
      });
    });

    // Listen for position changes
    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        _position = p;
      });
    });

    // Listen for audio completion
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      if (state == PlayerState.completed) {
        setState(() {
          _isPlaying = false;
          _position = Duration.zero;
        });
      }
    });

    // Listen for errors
    // _audioPlayer.onPlayerError.listen((String error) {
    //   debugPrint('AudioPlayer Error: $error');
    //   setState(() {
    //     _isPlaying = false;
    //   });
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Error playing audio: $error')),
    //   );
    // });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    try {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        // Check if mp3Path is an asset or local file
        if (widget.mp3Path.startsWith('assets/') || widget.mp3Path.contains('/audio/')) {
          await _audioPlayer.play(AssetSource(widget.mp3Path.replaceFirst('assets/', '')));
        } else {
          await _audioPlayer.play(DeviceFileSource(widget.mp3Path));
        }
      }
      setState(() {
        _isPlaying = !_isPlaying;
      });
    } catch (e) {
      debugPrint('Error in _togglePlayPause: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to play audio. Check file path or format.')),
      );
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause button
          IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              color: const Color(0xFF075E54), // WhatsApp green
              size: 36.0,
            ),
            onPressed: _togglePlayPause,
          ),
          // Progress bar
          Expanded(
            child: Slider(
              value: _position.inSeconds.toDouble(),
              max: _duration.inSeconds.toDouble() > 0
                  ? _duration.inSeconds.toDouble()
                  : 1.0,
              activeColor: const Color(0xFF075E54),
              inactiveColor: Colors.grey[400],
              onChanged: (value) async {
                try {
                  final position = Duration(seconds: value.toInt());
                  await _audioPlayer.seek(position);
                  setState(() {
                    _position = position;
                  });
                } catch (e) {
                  debugPrint('Error seeking audio: $e');
                }
              },
            ),
          ),
          // Duration display
          Text(
            '${_formatDuration(_position)} / ${_formatDuration(_duration)}',
            style: const TextStyle(fontSize: 12.0, color: Colors.black54),
          ),
          const SizedBox(width: 8.0),
          // Microphone icon for WhatsApp aesthetic
          const Icon(
            Icons.mic,
            size: 20.0,
            color: Color(0xFF075E54),
          ),
        ],
      ),
    );
  }
}