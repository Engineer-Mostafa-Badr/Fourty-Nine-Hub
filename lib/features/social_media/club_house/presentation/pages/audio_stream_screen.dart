import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/controller/club_voice_bloc.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/widgets/zego_audio_room_widget.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/components/zego_uikit/src/services/uikit_service.dart';
import 'package:go_router/go_router.dart';

class AudioStreamScreen extends StatelessWidget {
  final String liveId;
  final String roomSubject;
  final bool isHost;
  const AudioStreamScreen({
    super.key,
    required this.liveId,
    required this.roomSubject,
    required this.isHost,
  });

  @override
  Widget build(BuildContext context) {
    print('live id is $liveId');
    return SafeArea(
      child: PopScope(
        onPopInvoked: (pop) async {
          // Show the confirmation dialog
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want to leave this screen?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    isHost
                        ? _endRoom(context)
                        : context.read<ClubVoiceCubit>().leaveRoom(liveId);
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          );
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        isHost
                            ? _endRoom(context)
                            : context.read<ClubVoiceCubit>().leaveRoom(liveId);
                        context.pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8.0)
                            .add(const EdgeInsets.symmetric(horizontal: 15)),
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.redAccent),
                        child: Text(
                          isHost ? 'End' : 'Leave',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Text(
                          roomSubject,
                          style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
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

  void _endRoom(BuildContext context) async {
    final users = ZegoUIKit().getAllUsers();
    for (var user in users) {
      await ZegoUIKit().removeUserFromRoom([user.id]);
    }
    context.read<ClubVoiceCubit>().endRoom(liveId);
  }
}
