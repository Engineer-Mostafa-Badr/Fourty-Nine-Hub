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

class PKMuteButton extends StatefulWidget {
  final String userID;

  const PKMuteButton({
    super.key,
    required this.userID,
  });

  @override
  State<PKMuteButton> createState() => _PKMuteButtonState();
}

class _PKMuteButtonState extends State<PKMuteButton> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<String>>(
      valueListenable:
          ZegoUIKitPrebuiltLiveStreamingController().pk.mutedUsersNotifier,
      builder: (context, muteUsers, _) {
        return GestureDetector(
          onTap: () {
            ZegoUIKitPrebuiltLiveStreamingController().pk.muteAudios(
              targetHostIDs: [widget.userID],
              isMute: !muteUsers.contains(widget.userID),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.6),
            ),
            child: Icon(
              muteUsers.contains(widget.userID)
                  ? Icons.volume_off
                  : Icons.volume_up,
              color: Colors.black,
              // size: 25,
            ),
          ),
        );
      },
    );
  }
}
