import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/enums/call_enums_manager.dart';
import '../../../authentication/data/models/user_model.dart';
import '../../domain/entities/call_data.dart';
import '../controller/call_controller/call_cubit.dart';
import '../controller/call_controller/call_state.dart';
import '../controller/send_call_controller.dart/send_call_cubit.dart';
import '../controller/send_call_controller.dart/send_call_states.dart';
import 'declined_call_screen.dart';
import '../../widgets/build_app_bar.dart';
import '../../widgets/build_bottom_btns.dart';
import '../../../../helpers/call_helpers/call_helper/call_with_notification_helper.dart';
import '../../../../res/style/app_colors.dart';
import '../../../../res/style/const.dart';
import '../../../../service_locator/service_locator.dart';

class SendWhatsappCallScreen extends StatefulWidget {
  const SendWhatsappCallScreen({
    super.key,
    required this.receiver,
    required this.sender,
    required this.callType,
    required this.isRealCall,
  });
  final CallType callType;
  final UserModel receiver;
  final UserModel sender;
  final bool isRealCall;

  @override
  State<SendWhatsappCallScreen> createState() => _SendWhatsappCallScreenState();
}

class _SendWhatsappCallScreenState extends State<SendWhatsappCallScreen> {
  Timer? timer;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    serviceLocator<CallWithNotificationHelper>()
        .sendCallNotification(
          isRealCall: widget.isRealCall.toString(),
          callType: widget.callType.name.toString(),
          agoraAppId: UIConst.agoraAppId,
          serviceType: "zegocloud",
          // "agora",
          uid: widget.sender.id,
          zegoAppId: UIConst.zegoAppId,
          zegoAppSign: UIConst.zegoAppSign,
          context: context,
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
        )
        .then(
          (_) => timer = Timer(
            const Duration(seconds: UIConst.callRingingDuration),
            () {
              if (widget.isRealCall) {
                context
                    .read<SendCallCubit>()
                    .setCallClosedState('no answer from receiver');
              } else {}
            },
          ),
        );
    _audioPlayer = AudioPlayer();
    _playCallingSound();
    super.initState();
  }

  Future<void> _playCallingSound() async {
    // Load the sound from assets
    await _audioPlayer.setSource(AssetSource('sounds/send_call.mp3'));
    // Loop the sound until call is answered or declined
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    // Play the sound
    await _audioPlayer.resume();
  }

  void _stopCallingSound() {
    _audioPlayer.stop();
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
      _stopCallingSound();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    timer?.cancel();
    _stopCallingSound();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.PRIMARY_COLOR,
      extendBody: true,
      body: BlocConsumer<SendCallCubit, SendCallState>(
        listener: (context, state) {
          print("SendCallCubit state $state");
          if (state is CallConnected) {
            print("Call Connected Successfully");
            // Navigator.of(context).pop();
            _stopCallingSound();
            Future.delayed(const Duration(seconds: 2)).then(
              (_) => context.mounted ? Navigator.of(context).pop() : null,
            );
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => const WhatsAppCallScreen(),
            //   ),
            // );
          }
          if (state is UnableSendCall) {
            _stopCallingSound();
            Future.delayed(const Duration(seconds: 3)).then(
              (_) => context.mounted ? Navigator.of(context).pop() : null,
            );
          }

          if (state is DeclinedCall) {
            _stopCallingSound();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => DeclinedCallScreen(
                    receiver: widget.receiver,
                  ),
                ));
          }

          if (state is FakeCallConnected) {
            _stopCallingSound();
            _audioPlayer.dispose();
          }
        },
        builder: (context, state) {
          return Stack(children: [
            Image.asset(
              'assets/images/whatsapp_bacground.png',
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BuildAppBar(
                  receiver: widget.receiver,
                ),
                // Top section with contact details

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.receiver.profilePicture ??
                              'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    // add Please subscribe to join the call!
                    if (state is FakeCallConnected)
                      const Text(
                        'Please subscribe to join the call!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),

                // Bottom call control buttons
                BuildBottomBtns(
                  currentContext: context,
                  callData: CallData(
                      isCaller: true,
                      isRealCall: false.toString(),
                      callerName: widget.sender.fullName ?? "unknown",
                      callerImage: widget.sender.profilePicture ?? "",
                      receiverId: widget.receiver.id ?? "",
                      receiverName: widget.receiver.fullName ?? "unknown",
                      receiverImage: widget.receiver.profilePicture ?? "",
                      rtcToken: "",
                      channel: "",
                      serviceType: "",
                      zegoAppId: "",
                      zegoAppSign: "",
                      zegoRoomId: "",
                      agoraAppId: "",
                      uid: "",
                      fcmToken: widget.receiver.firebaseToken!
                          .trim()
                          .trimLeft()
                          .trimRight()
                          .toString(),
                      callType: "",
                      channelId: "",
                      permission: "",
                      expiresAt: ""),
                  onMorePressed: () {},
                ),
              ],
            ),
          ]);
        },
      ),
    );
  }
}
