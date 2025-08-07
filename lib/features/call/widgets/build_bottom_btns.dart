import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/enums/call_enums_manager.dart';
import '../../../core/utils/logging_service.dart';
import '../domain/entities/call_data.dart';
import '../presentation/controller/call_controller/call_cubit.dart';
import '../presentation/controller/call_controller/call_state.dart';
import 'call_control_button.dart';
import 'minimized_call_overlay.dart';
import '../../../helpers/call_helpers/call_helper/call_with_notification_helper.dart';
import '../../../main.dart';
import '../../../res/style/app_colors.dart';
import '../../../service_locator/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/call_timer_service.dart';

class BuildBottomBtns extends StatelessWidget {
  final HasCall? state;
  final BuildContext currentContext;
  final CallData? callData;
  final dynamic onMorePressed;
  BuildBottomBtns(
      {super.key, this.state, this.callData, required this.onMorePressed, required this.currentContext});

  final CallTimerService _timerService = CallTimerService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
          vertical: MediaQuery.of(context).size.height * 0.02),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.04,
          left: MediaQuery.of(context).size.width * 0.04,
          right: MediaQuery.of(context).size.width * 0.04),
      decoration: BoxDecoration(
        color: const Color(0xFF11191C),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CallControlButton(
              icon: Icons.more_horiz_rounded,
              onPressed: () {
                print("Click to More");
                _showMoreBottomSheetDialog(currentContext);
              }),
          _fixedWidth(),
          CallControlButton(
            icon: state?.isVideoEnabled ?? false
                ? Icons.videocam
                : Icons.videocam_off,
            onPressed: () async {
              LoggingService.info("🎥 VIDEO BUTTON CLICKED!");
              LoggingService.info("📊 Current video state: ${state?.isVideoEnabled}");
              LoggingService.info("🏢 Engine: ${state?.engine != null}");
              LoggingService.info("☁️ ZegoCloud: ${state?.isZegoCloud}");
              
              if (state?.engine != null || state?.isZegoCloud == true) {
                LoggingService.info("✅ Conditions met, checking camera permission...");
                
                // Check camera permission
                final permissionStatus = await Permission.camera.status;
                LoggingService.info("📷 Camera permission status: $permissionStatus");
                
                if (permissionStatus != PermissionStatus.granted) {
                  LoggingService.info("🔐 Requesting camera permission...");
                  final requestResult = await Permission.camera.request();
                  LoggingService.info("📷 Permission request result: $requestResult");
                  if (requestResult != PermissionStatus.granted) {
                    LoggingService.warning("❌ Camera permission denied, aborting");
                    return; // Don't proceed if permission denied
                  }
                }
                
                LoggingService.info("🚀 Calling toggleVideoSimple()...");
                context.read<CallCubit>().toggleVideoSimple(); // Use simple implementation first
                LoggingService.info("✅ toggleVideoSimple() called");
              } else {
                LoggingService.warning("❌ Conditions not met - engine: ${state?.engine != null}, zegoCloud: ${state?.isZegoCloud}");
              }
            },
            backgroundColor: state?.isVideoEnabled ?? false
                ? Colors.green
                : Colors.transparent,
            iconColor: Colors.white,
          ),
          _fixedWidth(),
          CallControlButton(
            icon:
                state?.isSpeaker ?? false ? Icons.volume_up : Icons.volume_down,
            onPressed: () {
              if (state?.engine != null || state?.isZegoCloud == true) {
                context.read<CallCubit>().toggleSpeaker();
              }
            },
          ),
          _fixedWidth(),
          CallControlButton(
            icon: state?.isMute ?? false
                ? Icons.mic_off_rounded
                : Icons.mic_rounded,
            iconColor: state?.isMute ?? false
                ? AppColors.PRIMARY_COLOR_DARK
                : Colors.black,
            backgroundColor: Colors.white,
            onPressed: () {
              print("click to Mute");
              if (state?.engine != null || state?.isZegoCloud == true) {
                context.read<CallCubit>().toggleMute();
              }
            },
          ),
          _fixedWidth(),
          CallControlButton(
            icon: Icons.call_end,
            onPressed: () async {
              print('Click to End Call');

              // Reset minimized state
              context.read<CallCubit>().endCall();

              // Explicitly hide overlay
              CallOverlayManager.hideOverlay();

              // Rest of your existing call end logic
              if (callData == null) {
                serviceLocator<CallWithNotificationHelper>()
                    .sendActionNotification(
                  callData!,
                  CallActions.callEnded,
                  reason: 'caller ended call while send call',
                );
                await Future.delayed(const Duration(milliseconds: 200));
                // Future.microtask(() {
                //   if (navigatorKey.currentState != null) {
                //     navigatorKey.currentState!.pop();
                //   }
                // });
                _timerService.resetTimer();
              } else {
                context.read<CallCubit>().endCall();
                Future.microtask(() {
                  if (navigatorKey.currentState != null) {
                    navigatorKey.currentState!.pop();
                  }
                });
                _timerService.resetTimer();
              }
            },
            backgroundColor: AppColors.PRIMARY_COLOR_DARK,
            iconColor: Colors.white,
          ),
        ],
      ),
    );
  }

  _showMoreBottomSheetDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding:
              const EdgeInsets.only(top: 18, bottom: 24, left: 16, right: 16),
          // height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
            color: const Color(0xFF161817),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFF2C2C2E),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 2),
                  Text('End-to-end encrypted',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              SizedBox(height: 17),
              Container(
                width: MediaQuery.of(context).size.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                child: Column(
                  children: [
                    _buildTaplistTile(
                        title: "Share Screen",
                        icon: Icons.mobile_screen_share_rounded,
                        onTap: (){

                        }),
                        SizedBox(height: 30),
                         _buildTaplistTile(
                        title: "Send message",
                        icon: Icons.message_rounded,
                        onTap: (){
                          
                        })
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaplistTile(
      {required String title,
      required IconData icon,
      required Function onTap}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500)),
          Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ],
      ),
    );
  }

  Widget _fixedWidth() {
    return const SizedBox(width: 10);
  }
}
