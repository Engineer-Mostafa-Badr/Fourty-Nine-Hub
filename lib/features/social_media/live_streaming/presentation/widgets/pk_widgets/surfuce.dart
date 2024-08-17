import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fourtyninehub/features/social_media/live_streaming/presentation/widgets/zego/src/defines.dart';

import 'quit_button.dart';
import 'request_widget.dart';
import 'requesting_id_value_listenable_widget.dart';
import 'requesting_list.dart';
import 'stop_button.dart';

class PKV2Surface extends StatefulWidget {
  final ValueNotifier<Map<String, List<String>>>
      requestingHostsMapRequestIDNotifier;
  final ValueNotifier<String> requestIDNotifier;
  final ValueNotifier<ZegoLiveStreamingState> liveStateNotifier;

  const PKV2Surface({
    super.key,
    required this.requestIDNotifier,
    required this.liveStateNotifier,
    required this.requestingHostsMapRequestIDNotifier,
  });

  @override
  State<PKV2Surface> createState() => _PKV2SurfaceState();
}

class _PKV2SurfaceState extends State<PKV2Surface> {
  // @override
  // void dispose() {
  //   widget.requestingHostsMapRequestIDNotifier.dispose();
  //   widget.liveStateNotifier.dispose();
  //   widget.requestIDNotifier.dispose();
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ZegoLiveStreamingState>(
      valueListenable: widget.liveStateNotifier,
      builder: (context, state, _) {
        const baseYPos = 50;

        final canPK = state != ZegoLiveStreamingState.idle;
        return canPK
            ? Stack(children: [
                Positioned(
                  bottom: baseYPos + 3 * 30 + 3 * 5,
                  right: 1,
                  child: PKQuitButton(
                    liveStateNotifier: widget.liveStateNotifier,
                    requestingHostsMapRequestIDNotifier:
                        widget.requestingHostsMapRequestIDNotifier,
                  ),
                ),
                Positioned(
                  bottom: baseYPos + 2 * 30 + 2 * 5,
                  right: 1,
                  child: PKStopButton(
                    liveStateNotifier: widget.liveStateNotifier,
                    requestingHostsMapRequestIDNotifier:
                        widget.requestingHostsMapRequestIDNotifier,
                  ),
                ),
                Positioned(
                  bottom: baseYPos + 30 + 5,
                  right: 1,
                  child: PKRequestWidget(
                    requestIDNotifier: widget.requestIDNotifier,
                    requestingHostsMapRequestIDNotifier:
                        widget.requestingHostsMapRequestIDNotifier,
                  ),
                ),
                // Positioned(
                //   bottom: baseYPos,
                //   right: 1,
                //   child: PKJoinWidget(
                //     liveController: widget.liveController,
                //     requestingHostsMapRequestIDNotifier:
                //         widget.requestingHostsMapRequestIDNotifier,
                //   ),
                // ),
                Positioned(
                  left: 1,
                  bottom: baseYPos + 150 + 60,
                  child: PKRequestingIDValueListenableWidget(
                    requestIDNotifier: widget.requestIDNotifier,
                  ),
                ),
                Positioned(
                  left: 1,
                  bottom: baseYPos + 60,
                  child: PKRequestingList(
                    requestingHostsMapRequestIDNotifier:
                        widget.requestingHostsMapRequestIDNotifier,
                  ),
                ),
              ])
            : Container();
      },
    );
  }
}
