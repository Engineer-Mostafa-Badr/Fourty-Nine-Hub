import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/call_enums_manager.dart';
import 'package:fourtyninehub/features/call/domain/entities/call_data.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_cubit.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_state.dart';
import 'package:fourtyninehub/features/call/widgets/call_control_button.dart';
import 'package:fourtyninehub/helpers/call_helpers/call_helper/call_with_notification_helper.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';

class BuildBottomBtns extends StatelessWidget {
  final HasCall? state;
  final CallData? callData;
  const BuildBottomBtns({super.key, this.state, this.callData});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
      margin: const EdgeInsets.only(bottom: 34, left: 18, right: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF11191C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CallControlButton(
            icon: Icons.more_horiz_rounded,
            onPressed: () {},
          ),
          _fixedWidth(),
          CallControlButton(
            icon: state?.isVideoEnabled ?? false
                ? Icons.videocam
                : Icons.videocam_off,
            onPressed: () async {
              if (state?.engine != null) {
                if (await Permission.camera.request() !=
                    PermissionStatus.granted) {
                  await Permission.camera.request();
                }
                context.read<CallCubit>().toggleVideo();
              }
            },
            backgroundColor: state?.isVideoEnabled ?? false
                ? Colors.green
                : Colors.transparent,
            iconColor: Colors.white,
          ),
          _fixedWidth(),
          CallControlButton(
            icon:
                state?.isSpeaker ?? false ? Icons.volume_up : Icons.volume_down,
            onPressed: () {
              if (state?.engine != null) {
                context.read<CallCubit>().toggleSpeaker();
              }
            },
          ),
          _fixedWidth(),
          CallControlButton(
            icon: state?.isMute ?? false
                ? Icons.mic_off_rounded
                : Icons.mic_rounded,
            onPressed: () {
              if (state?.engine != null) {
                context.read<CallCubit>().toggleMute();
              }
            },
          ),
          _fixedWidth(),
          CallControlButton(
            icon: Icons.call_end,
            onPressed: () {
              print('Click to End Call');
              if (callData != null) {
                serviceLocator<CallWithNotificationHelper>()
                    .sendActionNotification(
                  callData!,
                  CallActions.callEnded,
                  reason: 'caller ended call while send call',
                );
                Navigator.of(context).pop();
              } else {
                context.read<CallCubit>().endCall();
                Navigator.of(context).pop();
              }
            },
            backgroundColor: Colors.red,
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _fixedWidth() {
    return const SizedBox(width: 12);
  }
}
