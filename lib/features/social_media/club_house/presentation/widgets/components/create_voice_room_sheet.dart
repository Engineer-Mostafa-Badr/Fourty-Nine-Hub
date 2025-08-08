import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../common/widgets/stateless/labels/label.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../core/extensions/string_extension.dart';
import '../../../../../../core/localization/locale_keys.g.dart';
import '../../../../../../core/messages/messages.dart';
import '../../controller/club_voice_bloc.dart';
import '../../pages/audio_stream_screen.dart';
import '../../../../../../res/style/app_colors.dart';

import '../../../../../../core/widget/custom_scaffold.dart';
import '../../../../../../res/style/styles.dart';
import '../../../../../../service_locator/service_locator.dart';
import '../../controller/club_voice_state.dart';
import '../../../../../../helpers/manage_vibration.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController roomSubjectController = TextEditingController();

  @override
  void dispose() {
    roomSubjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
        body: Padding(
      padding: const EdgeInsets.only(
        // bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Sizer(height: 50.h),
          SizedBox(height: 60.h),
          Label(
            text: LocaleKeys.roomSubject.localize,
            textAlign: TextAlign.center,
            style: Styles.headerText(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30.h),
          Align(
            alignment: Alignment.topLeft,
            child: Label(
              text: LocaleKeys.pleaseEnterSimpleSubject.localize,
              style: Styles.headerText(
                fontSize: 25,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            child: TextField(
              cursorColor: AppColors.PRIMARY_COLOR,
              controller: roomSubjectController,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                // labelText: 'Room Subject',
                hintText: LocaleKeys.enterRoomSubject.localize,
                hintStyle: Styles.mediumText(),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                filled: true,
              ),
            ),
          ),
          BlocListener<ClubVoiceCubit, ClubVoiceState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state.isSuccess) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => BlocProvider(
                      create: (_) => serviceLocator<ClubVoiceCubit>(),
                      child: AudioStreamScreen(
                        liveId: state.roomId,
                        roomSubject: roomSubjectController.text.trim(),
                        isHost: true,
                      ),
                    ),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: context.isDarkMode
                            ? AppColors.SECONDARY_COLOR
                            : AppColors.PRIMARY_COLOR),
                    onPressed: () async {
      ManageVibration.vibrate();
                      String roomSub = roomSubjectController.text.trim();
                      if (roomSub.isEmpty) {
                        showErrorMessage(
                            context, LocaleKeys.roomSubjectValidation.localize);
                        return;
                      } else {
                        await addRoom(context, roomSub);
                        // debugPrint('room id is ${widget.cubit.roomId}');
                        if (context.mounted) {
                          //Navigator.pop(context);
                        }
                      }
                    },
                    child: Label(
                      text: LocaleKeys.createRoom.localize,
                      color: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: !context.isDarkMode
                            ? AppColors.SECONDARY_COLOR
                            : AppColors.PRIMARY_COLOR),
                    onPressed: () {
      ManageVibration.vibrate();
                      Navigator.of(context).pop();
                    },
                    child: Label(
                      text: LocaleKeys.cancel.localize,
                      // style: Styles.headerText(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

Future<void> addRoom(BuildContext context, String roomSub) async =>
    context.read<ClubVoiceCubit>().addRoom(roomSub);

//for passing args
class RoomArgs {
  final String liveId;
  final String subject;
  final bool isHost;
  final int usersCount;

  RoomArgs(this.liveId, this.subject, this.isHost, this.usersCount);
}