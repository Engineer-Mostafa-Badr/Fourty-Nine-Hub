import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/enums/call_enums_manager.dart';
import 'package:fourtyninehub/features/call/domain/entities/call_data.dart';
import 'package:fourtyninehub/features/call/domain/usecases/get_agora_token_usecase.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_cubit.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_state.dart';
import 'package:fourtyninehub/helpers/call_helpers/call_helper/call_kit_helper.dart';
import 'package:fourtyninehub/helpers/call_helpers/notifications_helper/fcm_notification_helper.dart';
import 'package:fourtyninehub/helpers/call_helpers/notifications_helper/send_notification_params.dart';
import 'package:fourtyninehub/main.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CallWithNotificationHelper {
  final FcmNotificationHelper _notificationHelper;
  final GetAgoraTokenUsecase _getAgoraTokenUsecase;
  final CallKitHelper _callKitHelper;

  CallWithNotificationHelper(
    this._notificationHelper,
    this._getAgoraTokenUsecase,
    this._callKitHelper,
  );

  Timer? _isOfflineTimer;
  final context = navigatorKey.currentContext;

  void _startOfflineReceiverTimer() {
    _isOfflineTimer?.cancel();
    _isOfflineTimer = Timer(
      const Duration(seconds: UIConst.callOfflineCheckDuration),
      () {
        if (context != null) {
         
        }
      },
    );
  }

  void handleIncomingCallNotification(Map<String, dynamic> data) {
    if (data['type'] == CallNotificationType.receiverIsOnline.name) {
      _handleReceiverResponseOnline(CallData.fromMap(data, true));
    } else if (data['type'] == CallNotificationType.sendCallRequest.name) {
      _handleIncomingCall(data);
    } else if (data['type'] == CallNotificationType.callAction.name) {
      _handleIncomingCallAction(data);
    }
  }

  void _handleReceiverResponseOnline(CallData callData) {
    _isOfflineTimer?.cancel();
    if (context != null) {
     
    }
  }

  void _handleIncomingCall(Map<String, dynamic> data) async {
    final callData = CallData.fromMap(data, false);
    if (context != null && (context!.read<CallCubit>().state is HasCall)) {
      sendActionNotification(
        callData,
        CallActions.receiverDeclinedCall,
        reason: 'user in another call',
      );
      return;
    }
    final time = DateTime.parse(data['time']).toLocal();
    final duration = DateTime.now().difference(time);

    if (duration.inSeconds > (UIConst.callOfflineCheckDuration - 2)) {
      _handleMissedCall();
      return;
    }
    final fcmToken = await _notificationHelper.getFcmToken();

    fcmToken.map((fcmToken) async {
      final result = await _notificationHelper.sendNotification(
        SendNotificationParams(
          to: callData.fcmToken,
          additionalData: {
            'type': CallNotificationType.receiverIsOnline.name,
            'time': DateTime.now().toUtc().toIso8601String(),
            ...callData.toMap(fcmToken: fcmToken),
          },
        ),
      );
      result.map(
        (_) => _showIncomingCallUI(callData),
      );
    });
  }

  void _handleIncomingCallAction(Map<String, dynamic> data) {
    if (data['action'] == CallActions.callEnded.name) {
      if (context != null &&
          context!.read<CallCubit>().state is HasCall &&
          (context!.read<CallCubit>().state as HasCall).callData.channelName ==
              data['channel_name']) {
        log('====================++++++++++++++++notification +++++++++++++++++====================');
       
      }
      _callKitHelper.stopCalling();
    } else if (data['action'] == CallActions.receiverDeclinedCall.name) {
      if (context != null) {
       
      }
    } else if (data['action'] == CallActions.receiverAcceptedCall.name) {
      _connectToCall(CallData.fromMap(data, true));
    }
  }

  void _connectToCall(CallData data) async {
    if (context != null) {
      if (data.isCaller) {
      }
    }
  }

  void _showIncomingCallUI(CallData data) {
    _callKitHelper.showCallkitIncoming(
      callData: data,
      callDuration: UIConst.callRingingDuration,
      onCallAccept: () async {
        if (context == null) {
          if (!serviceLocator.isRegistered<SharedPreferences>()) {
            await DI.execute();
          }
          await serviceLocator<SharedPreferences>()
              .setString('call_data', json.encode(data.toMap()));
        } else {
          _connectToCall(data);
        }
        sendActionNotification(
          data,
          CallActions.receiverAcceptedCall,
        );
      },
      onCallDecline: (reason) async {
        await _callKitHelper.stopCalling();
        sendActionNotification(
          data,
          CallActions.receiverDeclinedCall,
          reason: reason,
        );
      },
    );
  }

  Future sendCallNotification(
    BuildContext context, {
    required String callerName,
    required String callerImage,
    required String receiverName,
    required String receiverImage,
    required String receiverToken,
    required int expirationTime,
    required String caseId,
  }) async {
  
    try {
      final myNotificationToken = await _notificationHelper.getFcmToken();
      await myNotificationToken.fold(
        (e) async =>e,
        (notificationToken) async {
          final info = await _getAgoraTokenUsecase(GetAgoraTokenParams(
              expirationTime: expirationTime, caseId: caseId));

          print('+++++++++++++ $info');
          info.fold(
            (e) async => e,
            (agoraToken) async {
              final callData = CallData(
                fcmToken: notificationToken,
                isCaller: true,
                callerName: callerName,
                callerImage: callerImage,
                receiverName: receiverName,
                receiverImage: receiverImage,
                rtcToken: agoraToken.rtcToken,
                channelName: agoraToken.channelName,
                uid: agoraToken.uid,
              );

              final notificationParams = SendNotificationParams(
                to: receiverToken,
                additionalData: {
                  "type": CallNotificationType.sendCallRequest.name,
                  'time': DateTime.now().toUtc().toIso8601String(),
                  ...callData.toMap(),
                },
              );

              final notificationSent = await _notificationHelper
                  .sendNotification(notificationParams);

              notificationSent.fold(
                (e) async => e,
                (_) {
                  _startOfflineReceiverTimer();
                },
              );
            },
          );
        },
      );
    } catch (e) {
      
    }
  }

  void _handleMissedCall() {}

  void sendActionNotification(CallData callData, CallActions action,
      {String? reason}) async {
    final myNotificationToken = await _notificationHelper.getFcmToken();

    myNotificationToken.map((fcmToken) {
      _notificationHelper.sendNotification(
        SendNotificationParams(
          to: callData.fcmToken,
          additionalData: {
            'type': CallNotificationType.callAction.name,
            'action': action.name,
            'reason': reason ?? '',
            'time': DateTime.now().toUtc().toIso8601String(),
            ...callData.toMap(fcmToken: fcmToken),
          },
        ),
      );
    });
  }
}
