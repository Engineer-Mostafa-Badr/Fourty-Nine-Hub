import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/enums/call_enums_manager.dart';
import 'package:fourtyninehub/features/authentication/data/models/user_model.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_cubit.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_state.dart';
import 'package:fourtyninehub/features/call/presentation/controller/send_call_controller.dart/send_call_cubit.dart';
import 'package:fourtyninehub/features/call/presentation/controller/send_call_controller.dart/send_call_states.dart';
import 'package:fourtyninehub/helpers/call_helpers/call_helper/call_with_notification_helper.dart';
import 'package:fourtyninehub/res/style/app_colors.dart';
import 'package:fourtyninehub/res/style/const.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';

class SendCallScreen extends StatefulWidget {
  const SendCallScreen({
    super.key,
    required this.receiver,
    required this.sender,
  });

  final UserModel receiver;
  final UserModel sender;

  @override
  State<SendCallScreen> createState() => _SendCallScreenState();
}

class _SendCallScreenState extends State<SendCallScreen> {
  Timer? timer;

  @override
  void initState() {
    serviceLocator<CallWithNotificationHelper>()
        .sendCallNotification(
          context,
          receiverToken: widget.receiver.firebaseToken!
              .trim()
              .trimLeft()
              .trimRight()
              .toString(),
          callerName: widget.sender.fullName ?? 'unknown',
          callerImage: widget.sender.profilePicture ??
              'https://cdn-icons-png.flaticon.com/512/149/149071.png',
          receiverImage: widget.receiver.profilePicture ??
              'https://cdn-icons-png.flaticon.com/512/149/149071.png',
          receiverName: widget.receiver.fullName,
          expirationTime: 1800,
          caseId: '1',
        )
        .then(
          (_) => timer = Timer(
            const Duration(seconds: UIConst.callRingingDuration),
            () {
              context
                  .read<SendCallCubit>()
                  .setCallClosedState('no answer from receiver');
            },
          ),
        );

    super.initState();
  }

  @override
  void deactivate() {
    if (context.read<SendCallCubit>().state is CallRinging &&
        context.read<CallCubit>() is! HasCall) {
      print('+++++++++++++++notification sent+++++ end call');
      final state = context.read<SendCallCubit>().state as CallRinging;
      serviceLocator<CallWithNotificationHelper>().sendActionNotification(
        state.callData,
        CallActions.callEnded,
        reason: 'caller ended call while send call',
      );
    }
    super.deactivate();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ACCENT_COLOR,
      body: BlocConsumer<SendCallCubit, SendCallState>(
        listener: (context, state) {
          if (state is CallConnected) {
            Navigator.of(context).pop();
          }
          if (state is UnableSendCall) {
            Future.delayed(const Duration(seconds: 3)).then(
              (_) => context.mounted ? Navigator.of(context).pop() : null,
            );
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  widget.receiver.profilePicture ??
                      'https://cdn-icons-png.flaticon.com/512/149/149071.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 16,
                width: double.infinity,
              ),
              Text(
                widget.receiver.fullName ?? "Unknown",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                state is CallConnected
                    ? 'Connected'
                    : state is UnableSendCall
                        ? state.reason
                        : state is CallRinging
                            ? 'يتصل...'
                            : 'جاري الإتصال...',
                style: TextStyle(
                  fontSize: 14,
                  color: state is UnableSendCall ? Colors.red : Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              CircleAvatar(
                backgroundColor: Colors.red,
                child: IconButton(
                  icon: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              const Spacer(),
            ],
          );
        },
      ),
    );
  }
}
