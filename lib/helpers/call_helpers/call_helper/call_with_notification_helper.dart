import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/call_enums_manager.dart';
import 'package:fourtyninehub/features/call/domain/entities/call_data.dart';
import 'package:fourtyninehub/features/call/domain/usecases/get_agora_token_usecase.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_cubit.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_state.dart';
import 'package:fourtyninehub/features/call/presentation/controller/send_call_controller.dart/send_call_cubit.dart';
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
          context!.read<SendCallCubit>().setCallClosedState(' غير متاح الان');
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
      context!.read<SendCallCubit>().setStatToCallRinging(callData);
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
            ...callData.toMap(fcmToken: fcmToken, isRealCall: true.toString()),
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
          (context!.read<CallCubit>().state as HasCall).callData.channel ==
              data['channel']) {
        log('====================++++++++++++++++notification +++++++++++++++++====================');
        context!.read<CallCubit>().endCall();
      }
      _callKitHelper.stopCalling();
    } else if (data['action'] == CallActions.receiverDeclinedCall.name) {
      if (context != null) {
        context!.read<SendCallCubit>().setDeclinedCallState();
        // .setCallClosedState(data['reason'] ?? 'رفض المكالمة');
      }
    } else if (data['action'] == CallActions.receiverAcceptedCall.name) {
      print("The Data sended for calling is $data");
      _connectToCall(CallData.fromMap(data, true), false);
    }
  }

  void _connectToCall(CallData data, bool isFromCheckComingCall) async {
    if (context != null) {
      if (data.isRealCall == true.toString()) {
        if (data.isCaller) {
          context!.read<SendCallCubit>().setCallConnected();
        }
        context!.read<CallCubit>().startCall(data, isFromCheckComingCall);
      } else {
        context!.read<CallCubit>().startCall(data, isFromCheckComingCall);
        context!.read<SendCallCubit>().setFakeCallConnected();
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
          await serviceLocator<SharedPreferences>().setString('call_data',
              json.encode(data.toMap(isRealCall: true.toString())));
        } else {
          print("accept call data $data");
          _connectToCall(data, true);
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

  Future<void> sendCallNotification({
    required String isRealCall,
    required String agoraAppId,
    required String serviceType,
    required String uid,
    required int zegoAppId,
    required String zegoAppSign,
    required BuildContext context,
    required String receiverToken,
    required String callerName,
    required String callerImage,
    required String receiverImage,
    required String receiverName,
    required String callType,
  }) async {
    final cubit = context.read<SendCallCubit>();
    cubit.setCallLoading();

    final callData = CallData(
      isRealCall: isRealCall,
      callType: callType,
      agoraAppId: agoraAppId,
      serviceType: serviceType,
      uid: uid,
      zegoAppId: zegoAppId.toString(),
      zegoAppSign: zegoAppSign,
      callerName: callerName,
      callerImage: callerImage,
      receiverImage: receiverImage,
      receiverName: receiverName,
      fcmToken: '',
      isCaller: true,
      receiverId: uid,
      rtcToken: '',
      channel: '',
      channelId: '',
      permission: '',
      expiresAt: '',
      // callAction: CallActions.calling,
    );

    final myNotificationToken = await _notificationHelper.getFcmToken();
    print("Geting notification token $myNotificationToken");
    await myNotificationToken
        .fold((e) async => cubit.setCallClosedState('فشل إرسال مكالمة'),
            (notificationToken) async {
      if (isRealCall == true.toString()) {
        print('I am in real call');
        if (serviceType == 'agora') {
          final info = await _getAgoraTokenUsecase(const GetAgoraTokenParams());

          info.fold(
            (e) async => cubit.setCallClosedState('فشل إرسال مكالمة'),
            (agoraToken) async {
              print(
                  "Agora info is ${agoraToken.rtcToken} and channel name is ${agoraToken.channel} and channel id is ${agoraToken.channelId}");
              final notificationParams = SendNotificationParams(
                to: receiverToken,
                additionalData: {
                  "type": CallNotificationType.sendCallRequest.name.toString(),
                  'time': DateTime.now().toUtc().toIso8601String(),
                  ...callData.toMap(
                    isRealCall: true.toString(),
                    fcmToken: notificationToken,
                    rtcToken: agoraToken.rtcToken,
                    channel: agoraToken.channel,
                    channelId: agoraToken.channelId,
                    permission: agoraToken.permission,
                    expiresAt: agoraToken.expiresAt,
                  ),
                },
              );

              final notificationSent = await _notificationHelper
                  .sendNotification(notificationParams);

              notificationSent.fold(
                (e) async => cubit.setCallClosedState('فشل إرسال مكالمة'),
                (_) {
                  _startOfflineReceiverTimer();
                },
              );
            },
          );
        } else if (serviceType == 'zego') {
          final notificationParams = SendNotificationParams(
            to: receiverToken,
            additionalData: {
              "type": CallNotificationType.sendCallRequest.name,
              'time': DateTime.now().toUtc().toIso8601String(),
              ...callData.toMap(
                isRealCall: true.toString(),
                fcmToken: notificationToken,
              ),
            },
          );

          final notificationSent =
              await _notificationHelper.sendNotification(notificationParams);

          notificationSent.fold(
            (e) async => e,
            (_) {
              _startOfflineReceiverTimer();
            },
          );
        }
      } else {
        final notificationParams = SendNotificationParams(
          to: receiverToken,
          additionalData: {
            "type": CallNotificationType.sendCallRequest.name.toString(),
            'time': DateTime.now().toUtc().toIso8601String(),
            ...callData.toMap(
              isRealCall: false.toString(),
              fcmToken: notificationToken,
              rtcToken: '',
              channel: '',
              channelId: '',
              permission: '',
              expiresAt: '',
            ),
          },
        );

        final notificationSent =
            await _notificationHelper.sendNotification(notificationParams);

        notificationSent.fold(
          (e) async => cubit.setCallClosedState('فشل إرسال مكالمة'),
          (_) {
            _startOfflineReceiverTimer();
          },
        );
      }
    });
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
            ...callData.toMap(
              fcmToken: fcmToken,
              isRealCall: callData.isRealCall.toString(),
            ),
          },
        ),
      );
    });
  }
}
