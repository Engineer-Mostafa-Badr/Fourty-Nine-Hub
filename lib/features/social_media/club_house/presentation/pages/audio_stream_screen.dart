import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/controller/club_voice_bloc.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/widgets/zego_audio_room_widget.dart';
import 'package:go_router/go_router.dart';

class AudioStreamScreen extends StatelessWidget {
  final String liveId;
  final String roomSubject;
  final bool isHost;
  const AudioStreamScreen(
      {super.key,
      required this.liveId,
      required this.roomSubject,
      required this.isHost});

  @override
  Widget build(BuildContext context) {
    print('live id is $liveId');
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        isHost
                            ? context.read<ClubVoiceCubit>().endRoom(liveId)
                            : context.read<ClubVoiceCubit>().leaveRoom(liveId);
                        context.pop();
                      },
                      child: const Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.handPeace,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Leave quitely',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          roomSubject,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 1,
                        backgroundColor: Colors.grey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '132 here now',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        radius: 1,
                        backgroundColor: Colors.grey,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        '140',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.person_outline_outlined,
                        color: Colors.grey,
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                ZegoAudioRoomWidget(
                  isHost: isHost,
                  roomId: liveId,
                  roomSubject: roomSubject,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
