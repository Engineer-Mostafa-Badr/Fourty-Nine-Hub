import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/call/domain/entities/call_data.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_cubit.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_state.dart';

class CallConnectedScreen extends StatefulWidget {
  const CallConnectedScreen({super.key});

  @override
  State<CallConnectedScreen> createState() => _CallConnectedScreenState();
}

class _CallConnectedScreenState extends State<CallConnectedScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    context.read<CallCubit>().checkIfThereIsCall();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleResumed();
      });
    }
    super.didChangeAppLifecycleState(state);
  }

  void _handleResumed() async {
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) context.read<CallCubit>().checkIfThereIsCall();
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallCubit, CallState>(
      builder: (context, state) {
        if (state is HasCall) {
          return VoiceCallingScreen(callData: state.callData);
        }
        return const SizedBox();
      },
    );
  }
}

class VoiceCallingScreen extends StatelessWidget {
  const VoiceCallingScreen({
    super.key,
    required this.callData,
  });

  final CallData callData;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CallCubit, CallState>(
      builder: (context, state) {
        if (state is HasCall) {
          return Scaffold(
            body: CallBg(
              image: Image.network(
                callData.isCaller
                    ? callData.receiverImage
                    : callData.callerImage,
                fit: BoxFit.cover,
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    const Spacer(),
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(16.0),
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0, 24),
                                  blurRadius: 40,
                                  color: Colors.black38,
                                ),
                              ],
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  callData.isCaller
                                      ? callData.receiverImage
                                      : callData.callerImage,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            callData.isCaller
                                ? callData.receiverName
                                : callData.callerName,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0 * 2, vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CallOption(
                            icon: Icon(state.isSpeaker
                                ? Icons.volume_up
                                : Icons.volume_down),
                            press: () {
                              context.read<CallCubit>().toggleSpeaker();
                            },
                          ),
                          CallOption(
                            icon:
                                Icon(state.isMute ? Icons.mic_off : Icons.mic),
                            press: () {
                              context.read<CallCubit>().toggleMute();
                            },
                          ),
                          // CallOption(
                          //   icon: const Icon(Icons.videocam_off),
                          //   press: () {},
                          // ),
                          CallOption(
                            icon: const Icon(
                              Icons.call_end,
                              color: Colors.white,
                            ),
                            color: const Color(0xFFF03738),
                            press: () {
                              context.read<CallCubit>().endCall();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class CallOption extends StatelessWidget {
  const CallOption({
    super.key,
    required this.icon,
    required this.press,
    this.color = Colors.white10,
  });

  final Icon icon;
  final VoidCallback press;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        height: 56,
        width: 56,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: icon,
      ),
    );
  }
}

class CallBg extends StatelessWidget {
  const CallBg({
    super.key,
    required this.image,
    required this.child,
  });

  final Widget image;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        image,
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF1D1D35),
                Colors.transparent,
                Colors.transparent,
                Color(0xFF1D1D35),
              ],
              stops: [0, 0.2, 0.5, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
