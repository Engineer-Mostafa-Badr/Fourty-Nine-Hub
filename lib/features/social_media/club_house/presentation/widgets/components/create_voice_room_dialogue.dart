import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/controller/club_voice_bloc.dart';
import 'package:fourtyninehub/features/social_media/club_house/presentation/pages/audio_stream_screen.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';

import '../../../../../../service_locator/service_locator.dart';

void showVoiceLiveBottomSheet({
  required BuildContext context,
  required ClubVoiceCubit cubit,
}) {
  TextEditingController roomSubjectController = TextEditingController();

  showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      useSafeArea: true,
      shape:  const RoundedRectangleBorder(
        borderRadius:  BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return BlocProvider(
          create: (context) => serviceLocator<ClubVoiceCubit>(),
          child: Padding(
            padding: const EdgeInsets.only(
              // bottom: MediaQuery.of(context).viewInsets.bottom + 32,
              left: 16,
              right: 16,
              top: 24,
            ),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                 Text(
                  'Room Subject',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                 Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Please enter a simple description',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  child: TextField(
                    controller: roomSubjectController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      // labelText: 'Room Subject',
                      hintText: 'Enter room subject',
                      prefixIcon:  const Icon(Icons.headset_mic_rounded),
                      border:  const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0).add(EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.PRIMARY_COLOR),
                        onPressed: () async {
                          String roomSub = roomSubjectController.text.trim();
                          if (roomSub.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(
                                content: Text('Room subject cannot be empty'),
                              ),
                            );
                            return;
                          } else {
                            await addRoom(cubit, roomSub);
                            debugPrint('room id is ${cubit.roomId}');
                            if (context.mounted) {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (ctx) => BlocProvider.value(
                                    value: serviceLocator<ClubVoiceCubit>(),
                                    child: AudioStreamScreen(
                                      liveId: cubit.roomId,
                                      roomSubject: roomSub,
                                      isHost: true,
                                    ),
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child:  const Label(
                          text: 'Create Room',
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child:  const Text(
                          'Cancel',
                          style: TextStyle(color: AppColors.SECONDARY_COLOR),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

Future<void> addRoom(ClubVoiceCubit cubit, String roomSub) async =>
    cubit.addRoom(roomSub);

//for passing args
class RoomArgs {
  final String liveId;
  final String subject;
  final bool isHost;
  final int usersCount;
  RoomArgs(this.liveId, this.subject, this.isHost, this.usersCount);
}
