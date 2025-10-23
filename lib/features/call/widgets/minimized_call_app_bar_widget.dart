import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../authentication/data/models/user_model.dart';
import '../presentation/controller/call_controller/call_cubit.dart';
import '../presentation/controller/minimized_cubit/minimize_cubit.dart';
import '../services/call_timer_service.dart';
import '../../../helpers/manage_vibration.dart';

class MinimizedCallAppBarWrapper extends StatelessWidget {
  final UserModel receiver;
  final bool showMinimizedCall;

  const MinimizedCallAppBarWrapper({
    super.key,
    required this.receiver,
    required this.showMinimizedCall,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MinimizeCubit, MinimizeState>(
      builder: (context, state) {
        final isMinimized = state is CallMinimized && state.isMinimized;
        return MinimizedCallAppBar(
          receiver: receiver,
          showMinimizedCall: showMinimizedCall,
          height: isMinimized && showMinimizedCall ? 120.0 : 56.0,
        );
      },
    );
  }
}

class MinimizedCallAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final UserModel receiver;
  final bool showMinimizedCall;
  final double height;

  const MinimizedCallAppBar({
    super.key,
    required this.receiver,
    required this.showMinimizedCall,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MinimizeCubit, MinimizeState>(
      builder: (context, minimizeState) {
        final isMinimized =
            minimizeState is CallMinimized && minimizeState.isMinimized;

        return AppBar(
          toolbarHeight: height,
          backgroundColor: Colors.green,
          elevation: 0,
          flexibleSpace: Column(
            children: [
              // Regular app bar content
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Chat',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Minimized call banner
              if (isMinimized && showMinimizedCall)
                Container(
                  height: 64,
                  color: Colors.green[700],
                  child: _buildMinimizedCallBanner(context),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);

  Widget _buildMinimizedCallBanner(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          ManageVibration.vibrate();
          // Navigate back to call screen
          context.read<MinimizeCubit>().maximizeCall();
          Navigator.pushNamed(context, '/call', arguments: receiver);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: receiver.profilePicture != null
                    ? NetworkImage(receiver.profilePicture!)
                    : null,
                child: receiver.profilePicture == null
                    ? Text(
                        receiver.fullName.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(color: Colors.white),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      receiver.fullName ?? 'Unknown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    ValueListenableBuilder<Duration>(
                      valueListenable: CallTimerService().duration,
                      builder: (context, duration, _) {
                        return Text(
                          CallTimerService().formatDuration(duration),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.videocam, color: Colors.white),
                    onPressed: () {
                      ManageVibration.vibrate();
                      // Toggle video
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.call_end, color: Colors.red),
                    onPressed: () {
                      ManageVibration.vibrate();
                      // context.read<CallCubit>().endCall();
                      context.read<MinimizeCubit>().endCall();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
