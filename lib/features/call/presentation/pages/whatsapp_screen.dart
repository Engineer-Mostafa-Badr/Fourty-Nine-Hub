import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/features/authentication/data/models/user_model.dart';
import 'package:fourtyninehub/features/call/domain/entities/call_data.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_cubit.dart';
import 'package:fourtyninehub/features/call/presentation/controller/call_controller/call_state.dart';
import 'package:fourtyninehub/features/call/widgets/build_app_bar.dart';
import 'package:fourtyninehub/features/call/widgets/build_bottom_btns.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/call/widgets/ui_fake_call.dart';

class WhatsAppCallScreen extends StatefulWidget {
  const WhatsAppCallScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WhatsAppCallScreen> createState() => _WhatsAppCallScreenState();
}

class _WhatsAppCallScreenState extends State<WhatsAppCallScreen>
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
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("WhatsAppCallScreen call state ${context.watch<CallCubit>().state}");
    return BlocBuilder<CallCubit, CallState>(
      builder: (context, state) {
        if (state is HasCall) {
          return Positioned.fill(
              child: VoiceCallingScreen(callData: state.callData));
        }

        return const SizedBox();
      },
    );
  }
}

class VoiceCallingScreen extends StatefulWidget {
  const VoiceCallingScreen({
    super.key,
    required this.callData,
  });

  final CallData callData;

  @override
  State<VoiceCallingScreen> createState() => _VoiceCallingScreenState();
}

class _VoiceCallingScreenState extends State<VoiceCallingScreen> {
  int? _remoteUid;
  bool _isRemoteVideoEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      extendBody: true,
      body: BlocBuilder<CallCubit, CallState>(
        builder: (context, state) {
          if (state is HasCall) {
            print("VoiceCallingScreen call state1 $state");
            if (state.callData.isRealCall == true.toString()) {
              print("VoiceCallingScreen call state2 $state");
              if (state.engine != null) {
                // Setup event handler for remote user
                state.engine!.registerEventHandler(
                  RtcEngineEventHandler(
                    onJoinChannelSuccess: (connection, elapsed) {
                      print(
                          "Local user joined channel: ${connection.channelId}");
                    },
                    onUserJoined: (connection, remoteUid, elapsed) {
                      print("Remote user joined: $remoteUid");
                      setState(() {
                        _remoteUid = remoteUid;
                      });
                    },
                    onUserOffline: (connection, remoteUid, reason) {
                      print("Remote user left: $remoteUid");
                      setState(() {
                        _remoteUid = null;
                        _isRemoteVideoEnabled = false;
                      });
                    },
                    onRemoteVideoStateChanged:
                        (connection, remoteUid, state, reason, elapsed) {
                      print(
                          "Remote video state changed: uid=$remoteUid, state=$state, reason=$reason");
                      setState(() {
                        _remoteUid = remoteUid;
                        _isRemoteVideoEnabled = state ==
                                RemoteVideoState.remoteVideoStateStarting ||
                            state == RemoteVideoState.remoteVideoStateDecoding;
                        print(
                            '_isRemoteVideoEnabled $_isRemoteVideoEnabled and remoteUid $_remoteUid');
                      });
                    },
                  ),
                );
              }

              return Stack(
                children: [
                  // Video Layer or Background
                  state.isVideoEnabled
                      ? _buildAgoraVideoLayer(state)
                      : Image.asset(
                          'assets/images/whatsapp_bacground.png',
                          fit: BoxFit.cover,
                          height: double.infinity,
                          width: double.infinity,
                        ),

                  // UI Layer with controls and info
                  _buildUILayer(state),
                ],
              );
            } else {
             
              print("VoiceCallingScreen call state3 $state");
              return UIFakeCall(
                receiver: UserModel(
                  id: widget.callData.receiverId,
                  firstName: widget.callData.receiverName,
                  lastName: '',
                  profilePicture: widget.callData.receiverImage,
                ),
              );
            }
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildAgoraVideoLayer(HasCall state) {
    if (state.engine == null) return Container(color: Colors.black);

    return Stack(
      children: [
        // Background color
        Container(color: Colors.black),

        // Remote Video (if available and enabled)
        if (_remoteUid != null && _isRemoteVideoEnabled)
          Positioned.fill(
            child: AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: state.engine!,
                canvas: VideoCanvas(
                  uid: _remoteUid,
                  renderMode: RenderModeType.renderModeFit,
                  sourceType: VideoSourceType.videoSourceRemote,
                ),
                connection: RtcConnection(
                  channelId:
                      //  "8a5e17cd-d07c-4b2c-83ba-9e59a0dfd864"
                      state.callData.channel,
                ),
              ),
            ),
          ),

        // Local Video
        if (state.isVideoEnabled)
          Positioned(
            right: 16,
            top: 100,
            child: Container(
              width: 150,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: state.engine!,
                    canvas: const VideoCanvas(
                      uid: 0,
                      renderMode: RenderModeType.renderModeFit,
                      mirrorMode: VideoMirrorModeType.videoMirrorModeEnabled,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildUILayer(HasCall state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        BuildAppBar(
          receiver: UserModel(
            id: widget.callData.receiverId,
            firstName: widget.callData.receiverName,
            lastName: '',
            profilePicture: widget.callData.receiverImage,
          ),
        ),

        // Profile Picture (only show when video is off)
        if (!state.isVideoEnabled && !_isRemoteVideoEnabled)
          CircleAvatar(
            radius: 100,
            backgroundImage: NetworkImage(
              state.callData.receiverImage ??
                  'https://cdn-icons-png.flaticon.com/512/149/149071.png',
            ),
          ),

        // Bottom Buttons
        BuildBottomBtns(state: state),
      ],
    );
  }

  @override
  void dispose() {
    if (context.read<CallCubit>().state is HasCall) {
      final state = context.read<CallCubit>().state as HasCall;
      if (state.engine != null) {
        state.engine!.registerEventHandler(RtcEngineEventHandler());
      }
    }
    super.dispose();
  }
}
