import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/authentication/data/models/user_model.dart';
import 'package:fourtyninehub/features/call/presentation/controller/send_call_controller.dart/send_call_cubit.dart';
import 'package:fourtyninehub/features/call/presentation/controller/send_call_controller.dart/send_call_states.dart';
import 'package:fourtyninehub/features/call/widgets/call_control_button.dart';

class CallTimer extends StatefulWidget {
  const CallTimer({super.key});

  @override
  State<CallTimer> createState() => _CallTimerState();
}

class _CallTimerState extends State<CallTimer> {
  Duration duration = Duration.zero;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        duration = Duration(seconds: timer.tick);
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours =
        duration.inHours > 0 ? '${twoDigits(duration.inHours)}:' : '';
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatDuration(duration),
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 14,
      ),
    );
  }
}

class BuildAppBar extends StatelessWidget {
  final UserModel receiver;
  const BuildAppBar({super.key, required this.receiver});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendCallCubit, SendCallState>(
      builder: (context, callState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CallControlButton(
                icon: Icons.close_fullscreen_rounded,
                onPressed: () {},
                size: 57,
              ),
              Column(
                children: [
                  Text(
                    receiver.fullName ?? "Unknown",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      if (callState is! CallConnected &&
                          callState is! UnableSendCall &&
                          callState is! FakeCallConnected)
                        const Row(
                          children: [
                            Icon(
                              Icons.lock_outline_rounded,
                              color: Colors.grey,
                              size: 15,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                          ],
                        ),
                      if (callState is CallConnected)
                        const CallTimer()
                      else
                        Text(
                          callState is UnableSendCall
                              ? callState.reason
                              : callState is CallRinging
                                  ? 'Ringing...'
                                  : callState is FakeCallConnected
                                      ? 'Connecting...'
                                      : 'End-to-end encrypted',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                    ],
                  )
                ],
              ),
              // CallControlButton(
              //   icon: Icons.person_add_alt_rounded,
              //   onPressed: () {},
              //   size: 57,
              // ),
              const SizedBox(
                width: 57,
                height: 57,
              ),
            ],
          ),
        );
      },
    );
  }
}
