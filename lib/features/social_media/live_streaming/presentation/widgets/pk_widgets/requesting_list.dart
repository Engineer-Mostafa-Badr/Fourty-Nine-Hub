import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../components/zego_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class PKRequestingList extends StatefulWidget {
  final ValueNotifier<Map<String, List<String>>>
      requestingHostsMapRequestIDNotifier;

  const PKRequestingList({
    super.key,
    required this.requestingHostsMapRequestIDNotifier,
  });

  @override
  State<PKRequestingList> createState() => _PKRequestingListState();
}

class _PKRequestingListState extends State<PKRequestingList> {
  final requestTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 120,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: const Text(
            'Requesting Host, \nClick to Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Container(
          width: 120.w,
          height: 100.h,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: ValueListenableBuilder<Map<String, List<String>>>(
            valueListenable: widget.requestingHostsMapRequestIDNotifier,
            builder: (context, requestingHostsMapRequestID, _) {
              final uniqueItems = <String>{};
              for (var list in requestingHostsMapRequestID.values) {
                uniqueItems.addAll(list);
              }
              final invitingHostIDs = uniqueItems.toList();

              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: invitingHostIDs.length,
                  itemBuilder: (context, index) {
                    final hostID = invitingHostIDs.elementAt(index);

                    return ValueListenableBuilder<
                            ZegoLiveStreamingPKBattleState>(
                        valueListenable:
                            ZegoUIKitPrebuiltLiveStreamingController()
                                .pk
                                .stateNotifier,
                        builder: (context, pkState, _) {
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              // background (button) color
                              foregroundColor:
                                  Colors.white, // foreground (text) color
                            ),
                            onPressed: pkState ==
                                    ZegoLiveStreamingPKBattleState.inPK

                                /// couldn't cancel after in-pk(anyone accepted)
                                ? null
                                : () {
                                    ZegoUIKitPrebuiltLiveStreamingController()
                                        .pk
                                        .cancelRequest(
                                      targetHostIDs: [hostID],
                                    ).then((ret) {
                                      if (ret.error == null) {
                                        requestingHostsMapRequestID
                                            .forEach((requestID, hostIDs) {
                                          if (hostIDs.contains(hostID)) {
                                            removeRequestingHostsMapWhenRemoteHostDone(
                                              requestID,
                                              hostID,
                                            );

                                            return;
                                          }
                                        });
                                      }
                                    });
                                  },
                            child: Text(hostID),
                          );
                        });
                  });
            },
          ),
        ),
      ],
    );
  }

  void removeRequestingHostsMapWhenRemoteHostDone(
    String requestID,
    String fromHostID,
  ) {
    widget.requestingHostsMapRequestIDNotifier.value[requestID]
        ?.removeWhere((requestHostID) => fromHostID == requestHostID);
    if (widget.requestingHostsMapRequestIDNotifier.value[requestID]?.isEmpty ??
        false) {
      widget.requestingHostsMapRequestIDNotifier.value.remove(requestID);
    }
    widget.requestingHostsMapRequestIDNotifier.notifyListeners();
  }
}
