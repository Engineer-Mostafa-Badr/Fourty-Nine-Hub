import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/minimizing/defines.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/duration_time_board.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/message/view.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/live_page.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/preview_page.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/utils/permissions.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/utils/toast.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/core_managers.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/internal/events.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/minimizing/data.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/minimizing/overlay_machine.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/live_status_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/plugins.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/live_duration_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/components.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/controller.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/connect_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/host_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/utils/pop_up_manager.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/defines.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/inner_text.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/effects/beauty_effect_button.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/effects/sound_effect_button.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/leave_button.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/message/disable_chat_button.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/components/message/input_board_button.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/config.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/config.defines.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/core/co_host_control_button.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/events.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/events.defines.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/internal/defines.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/internal/pk_combine_notifier.dart';
import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/minimizing/mini_button.dart';

class PKQuitButton extends StatefulWidget {
  final ValueNotifier<Map<String, List<String>>>
      requestingHostsMapRequestIDNotifier;
  final ValueNotifier<ZegoLiveStreamingState> liveStateNotifier;

  const PKQuitButton({
    super.key,
    required this.liveStateNotifier,
    required this.requestingHostsMapRequestIDNotifier,
  });

  @override
  State<PKQuitButton> createState() => _PKQuitButtonState();
}

class _PKQuitButtonState extends State<PKQuitButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.liveStateNotifier,
      builder: (context, state, _) {
        return Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
          height: 30,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: ZegoLiveStreamingState.inPKBattle == state
                ? () => quitPKBattle(context)
                : null,
            child: const Text(
              'Quit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }

  void quitPKBattle(context) {
    if (!ZegoUIKitPrebuiltLiveStreamingController().pk.isInPK) {
      return;
    }

    ZegoUIKitPrebuiltLiveStreamingController().pk.quit().then((ret) {
      if (ret.error != null) {
        showDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('quitPKBattle failed'),
              content: Text('Error: ${ret.error}'),
              actions: [
                CupertinoDialogAction(
                  onPressed: Navigator.of(context).pop,
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        widget.requestingHostsMapRequestIDNotifier.value = {};
      }
    });
  }
}
