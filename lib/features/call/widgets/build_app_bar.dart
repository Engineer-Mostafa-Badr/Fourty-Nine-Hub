import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:fourtyninehub/features/authentication/data/models/user_model.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_cubit.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_state.dart';
import 'package:fourtyninehub/features/call/presentation/controller/send_call_controller.dart/send_call_cubit.dart';
import 'package:fourtyninehub/features/call/presentation/controller/send_call_controller.dart/send_call_states.dart';
import 'package:fourtyninehub/features/call/services/call_timer_service.dart';
import 'package:fourtyninehub/features/call/widgets/call_control_button.dart';

class CallTimer extends StatefulWidget {
  const CallTimer({super.key});

  @override
  State<CallTimer> createState() => _CallTimerState();
}
class _CallTimerState extends State<CallTimer> {
  final CallTimerService _timerService = CallTimerService();

  @override
  void initState() {
    super.initState();
    print("CallTimer widget initializing");
    
    // Check if call is connected and start timer if not running
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sendCallState = context.read<SendCallCubit>().state;
      final callState = context.read<CallCubit>().state;
      
      if ((sendCallState is CallConnected || (callState is HasCall && callState.isCallConnected)) 
          && !_timerService.isRunning) {
        print("Starting timer in CallTimer widget - call is connected");
        _timerService.startTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendCallCubit, SendCallState>(
      listener: (context, state) {
        if (state is CallConnected && !_timerService.isRunning) {
          print("SendCallCubit state changed to CallConnected - starting timer");
          _timerService.startTimer();
        }
      },
      child: BlocListener<CallCubit, CallState>(
        listener: (context, state) {
          if (state is HasCall && state.isCallConnected && !_timerService.isRunning) {
            print("CallCubit state changed to connected - starting timer");
            _timerService.startTimer();
          }
        },
        child: ValueListenableBuilder<Duration>(
          valueListenable: _timerService.duration,
          builder: (context, duration, _) {
            final formattedTime = _timerService.formatDuration(duration);
            print("Building CallTimer widget with time: $formattedTime");
            return Text(
              formattedTime,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            );
          },
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    print("CallTimer widget disposed, but NOT stopping the timer");
    super.dispose();
  }
}

class BuildAppBar extends StatelessWidget {
  final UserModel receiver;
  const BuildAppBar({super.key, required this.receiver});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SendCallCubit, SendCallState>(
      builder: (context, callState) {
        print("Building app bar with call state: $callState");
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CallControlButton(
                icon: Icons.close_fullscreen_rounded,
                onPressed: () {
                  print("Call state at minimize 1 $callState");
                  
                  // First minimize the call in state
                  context.read<SendCallCubit>().minimizeCall();
                  
                  // Then show the overlay
                  // CallOverlayManager.showOverlay();
                  
                  print("Call state at minimize 2 $callState");
                  
                  // Simple navigation - just pop current screen
                  // Navigator.of(context).pop();
                },
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
