import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/extensions/string_extension.dart';
import '../controller/club_voice_bloc.dart';
import '../widgets/zego_audio_room_widget.dart';
import '../../../live_streaming/presentation/widgets/components/zego_uikit/src/services/uikit_service.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../core/widget/custom_scaffold.dart';
import '../../../../../helpers/manage_vibration.dart';

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
      child: CustomScaffold(
        body: PopScope(
          canPop: false,
          // onPopInvoked: (pop) async {
          //   await Future.delayed(Duration.zero);
          //
          //   // Show the confirmation dialog
          //   if (context.mounted) {
          //     bool? result = await showModalBottomSheet<bool>(
          //       context: context,
          //       builder: (context) => Container(
          //         padding: const EdgeInsets.all(16.0),
          //         child: Column(
          //           mainAxisSize: MainAxisSize.min,
          //           children: [
          //             const Text(
          //               'Are you sure?',
          //               style: TextStyle(
          //                   fontSize: 18, fontWeight: FontWeight.bold),
          //             ),
          //             const SizedBox(height: 10),
          //             const Text('Do you want to leave this screen?'),
          //             const SizedBox(height: 20),
          //             Row(
          //               mainAxisAlignment: MainAxisAlignment.end,
          //               children: [
          //                 TextButton(
          //                   onPressed: () {
          //                     // context
          //                     //   .pop(false);
          //                   }, // Close bottom sheet with "No"
          //                   child: const Text('No'),
          //                 ),
          //                 TextButton(
          //                   onPressed: () {
          //                     if (isHost) {
          //                       _endRoom(context);
          //                     } else {
          //                       context
          //                           .read<ClubVoiceCubit>()
          //                           .leaveRoom(liveId);
          //                     }
          //                     // context
          //                     //     .pop(true); // Close bottom sheet with "Yes"
          //                   },
          //                   child: const Text('Yes'),
          //                 ),
          //               ],
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //     if (result == true) {
          //       print('result is true');
          //       // context.pop();
          //     }
          //     print('result is $result');
          //   }
          // },
          child: SingleChildScrollView(
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
      ManageVibration.vibrate();
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
                          isHost
                              ? LocaleKeys.end.localize
                              : LocaleKeys.leave.localize,
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
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32.sp,
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