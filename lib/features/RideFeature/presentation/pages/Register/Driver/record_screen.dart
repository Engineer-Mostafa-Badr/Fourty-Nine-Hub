import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_cubit.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class VoiceNoteRecorder extends StatefulWidget {
  const VoiceNoteRecorder({super.key});

  @override
  _VoiceNoteRecorderState createState() => _VoiceNoteRecorderState();
}

class _VoiceNoteRecorderState extends State<VoiceNoteRecorder> {
  final _record = AudioRecorder();
  bool _isRecording = false;
  String? _audioPath;

  Future<void> _startRecording() async {
    if (await _record.hasPermission()) {
      final directory = await getApplicationDocumentsDirectory();

      // Generate a unique file name using Uuid
      final uniqueId = const Uuid().v4();
      _audioPath = '${directory.path}/voice_note_$uniqueId.m4a';

 
        
        await _record.start(const RecordConfig(),path: _audioPath!,
      );

      setState(() => _isRecording = true);
    }
  }

  Future<void> _stopRecording() async {
    await _record.stop();
    setState(() => _isRecording = false);

    if (_audioPath != null) {
      print('Recording saved at: $_audioPath');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Note Recorder')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 80,
              icon: Icon(
                _isRecording ? Icons.stop : Icons.mic,
                color: _isRecording ? Colors.red : Colors.blue,
              ),
              onPressed: () async {
                if (_isRecording) {
                  await context.read<RideCubit>().stopRecord(
                    subcategoryId: '62c8ba9f8e28a58a3edf57eb',
                    tripId: '67db76b6152a4bdcde6df905',
                  );
                  await _stopRecording();
                } else {
                  await _startRecording();
                  await context.read<RideCubit>().startRecord();
                }
              },
            ),
            if (_audioPath != null)
              Text(
                'Recording saved at: $_audioPath',
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
