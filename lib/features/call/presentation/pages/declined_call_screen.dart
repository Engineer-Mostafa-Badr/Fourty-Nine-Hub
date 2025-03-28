import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/authentication/data/models/user_model.dart';
import 'package:fourtyninehub/features/call/widgets/declined_app_bar.dart';
import 'package:fourtyninehub/features/call/widgets/declined_btns.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

class DeclinedCallScreen extends StatefulWidget {
  final UserModel receiver;
  const DeclinedCallScreen({super.key, required this.receiver});

  @override
  State<DeclinedCallScreen> createState() => _DeclinedCallScreenState();
}

class _DeclinedCallScreenState extends State<DeclinedCallScreen> {
  late AudioPlayer _audioPlayer;
  Future<void> _playCallingSound() async {
    // Load the sound from assets
    await _audioPlayer.setSource(AssetSource('sounds/end_call.mp3'));
    // Loop the sound until call is answered or declined
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    // Play the sound
    await _audioPlayer.resume();
    Future.delayed(const Duration(seconds: 1), () {
      _stopCallingSound();
    });
  }

  void _stopCallingSound() {
    _audioPlayer.stop();
  }

  @override
  void initState() {
    _audioPlayer = AudioPlayer();
    _playCallingSound();
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 10)).then(
      (_) => context.mounted ? Navigator.of(context).pop() : null,
    );
    return Scaffold(
        backgroundColor: AppColors.PRIMARY_COLOR,
        body: Stack(children: [
          Image.asset(
            'assets/images/whatsapp_bacground.png',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 180),
                child: Column(
                  children: [
                    DeclinedAppBar(receiverName: widget.receiver.firstName),
                    const SizedBox(height: 20),
                    CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(widget
                              .receiver.profilePicture ??
                          'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
                    ),
                  ],
                ),
              )),
          Positioned(
              bottom: 25,
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const DeclinedBtns()))
        ]));
  }
}
