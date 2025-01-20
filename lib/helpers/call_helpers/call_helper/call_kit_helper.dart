import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:fourtyninehub/features/call/domain/entities/call_data.dart';
import "package:fourtyninehub/res/assets/assets.dart";

abstract class CallKitHelper {
  Future<void> showCallkitIncoming({
    required CallData callData,
    required int callDuration,
    required void Function() onCallAccept,
    required void Function(String reason) onCallDecline,
  });

  Future<void> stopCalling();
}

class CallKitHelperImpl implements CallKitHelper {
  @override
  Future<void> showCallkitIncoming({
    required CallData callData,
    required int callDuration,
    required void Function() onCallAccept,
    required void Function(String reason) onCallDecline,
  }) async {
    final params = CallKitParams(
      id: callData.uid,
      nameCaller: callData.callerName,
      appName: '49',
      avatar: callData.callerImage,
      type: 0,
      duration: callDuration * 1000,
      textAccept: 'قبول',
      textDecline: 'رفض',
      extra: <String, dynamic>{'userId': '1a2b3c4d'},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android:  AndroidParams(
        isCustomNotification: true,
        isShowLogo: true,
        incomingCallNotificationChannelName:
            "Incomming call from Tqneen Customer",
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#1068A8',
        backgroundUrl: Assets.logo,
        actionColor: '#4CAF50',
        // textColor: '#ffffff',
      ),
      ios:  IOSParams(
        iconName: Assets.logo,
        handleType: '',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );

    await FlutterCallkitIncoming.showCallkitIncoming(params);

    FlutterCallkitIncoming.onEvent.listen(
      (event) async {
        switch (event!.event) {
          case Event.actionCallAccept:
            onCallAccept();
            break;
          case Event.actionCallDecline:
            onCallDecline('user declined call');
            break;
          case Event.actionCallTimeout:
            onCallDecline('No Answer ');
            break;
          default:
            break;
        }
      },
    );
  }

  @override
  Future<void> stopCalling() async {
    await FlutterCallkitIncoming.endAllCalls();
  }
}
