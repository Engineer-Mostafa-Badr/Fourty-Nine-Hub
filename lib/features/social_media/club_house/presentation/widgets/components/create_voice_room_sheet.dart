import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/string_extension.dart';
import 'package:fourtyninehub/core/localization/locale_keys.g.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                  LocaleKeys.roomSubject.localize,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    LocaleKeys.pleaseEnterSimpleSubject.localize,
                    style: TextStyle(
                      fontSize: 25.sp,
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
                      hintText: LocaleKeys.enterRoomSubject.localize,
                      prefixIcon: const Icon(Icons.headset_mic_rounded),
                      border: const OutlineInputBorder(
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
                            showErrorMessage(
                                context, LocaleKeys.roomSubjectValidation.localize);
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
                        child: Label(
                          text: LocaleKeys.createRoom.localize,
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          LocaleKeys.cancel.localize,
                          style:
                              const TextStyle(color: AppColors.SECONDARY_COLOR),
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
