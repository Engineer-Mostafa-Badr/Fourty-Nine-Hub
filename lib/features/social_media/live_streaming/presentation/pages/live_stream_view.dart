// // ignore_for_file: public_member_api_docs, sort_constructors_first

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
// import 'package:fourtyninehub/core/extensions/context_extension.dart';
// import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
// import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
// import 'package:fourtyninehub/res/style/styles.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// // import 'package:fourtyninehub/common/widgets/stateless/dynamic/shared_bottom_navigator.dart';

// import '../../../../../secrets/controller/secrets_cubit.dart';
// import '../widgets/components/zego_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

// class LiveStreamView extends StatefulWidget {
//   final String liveID;
//   final bool isHost;

//   const LiveStreamView({
//     super.key,
//     required this.liveID,
//     required this.isHost,
//   });

//   @override
//   State<LiveStreamView> createState() => _LiveStreamViewState();
// }

// class _LiveStreamViewState extends State<LiveStreamView> {
//   final liveStateNotifier = ValueNotifier<ZegoLiveStreamingState>(
//     ZegoLiveStreamingState.idle,
//   );

//   @override
//   Widget build(BuildContext context) {
//     final hostConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host(
//       plugins: [ZegoUIKitSignalingPlugin()],
//     )..layout = ZegoLayout.gallery();

//     final audienceConfig = ZegoUIKitPrebuiltLiveStreamingConfig.audience(
//       plugins: [ZegoUIKitSignalingPlugin()],
//     )
//       ..inRoomMessage = ZegoLiveStreamingInRoomMessageConfig(
//           resendIcon: const Icon(
//         Icons.reply,
//         color: Colors.white,
//       ))
//       ..layout = ZegoLayout.gallery();

//     final userId = context.read<UserCubit>().state.data?.id ?? '';
//     print('live id is ${widget.liveID}');
//     if (userId.isEmpty ||
//         context.read<SecretsCubit>().state.secrets?.zegoAppId == null ||
//         context.read<SecretsCubit>().state.secrets?.zegoAppSign == null) {
//       return CustomScaffold(
//         body: Center(
//           child: Label(
//             text: context.isArabic ? 'حدث خطأ ما' : 'Something went wrong',
//             style: Styles.headerText(),
//           ),
//         ),
//       );
//     }
//     return SafeArea(
//       child: ZegoUIKitPrebuiltLiveStreaming(
//           appID: context.read<SecretsCubit>().state.secrets!.zegoAppId,
//           appSign: context.read<SecretsCubit>().state.secrets!.zegoAppSign,
//           userID: userId,
//           userName: context.read<UserCubit>().state.data?.fullName ?? '',
//           liveID: widget.liveID,
//           isLiveStream: true,
//           config: widget.isHost ? hostConfig : audienceConfig
//           // ..foreground = giftForeground()
//           ),
//     );
//   }
// }

// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/widgets/stateless/labels/label.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/widget/custom_scaffold.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/res/style/styles.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import '../../../../../secrets/controller/secrets_cubit.dart';
import '../../../../../secrets/controller/secrets_state.dart';
import '../widgets/components/zego_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LiveStreamView extends StatefulWidget {
  final String liveID;
  final bool isHost;

  const LiveStreamView({
    super.key,
    required this.liveID,
    required this.isHost,
  });

  @override
  State<LiveStreamView> createState() => _LiveStreamViewState();
}

class _LiveStreamViewState extends State<LiveStreamView> {
  final liveStateNotifier = ValueNotifier<ZegoLiveStreamingState>(
    ZegoLiveStreamingState.idle,
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SecretsCubit, SecretsState>(
      builder: (context, secretsState) {
        // حالة التحميل
        if (secretsState.isLoading) {
          return CustomScaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          );
        }

        // حالة الخطأ
        if (secretsState.isFailure) {
          return CustomScaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Label(
                    text: context.isArabic
                        ? 'فشل في تحميل الإعدادات'
                        : 'Failed to load settings',
                    style: Styles.headerText(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SecretsCubit>().getAllSecrets();
                    },
                    child: Text(context.isArabic ? 'إعادة المحاولة' : 'Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // التحقق من بيانات المستخدم والأسرار
        final userId = context.read<UserCubit>().state.data?.id ?? '';
        final secrets = secretsState.secrets;

        print('live id is ${widget.liveID}');
        print('user id is $userId');
        print('zego app id is ${secrets?.zegoAppId}');
        print('zego app sign is ${secrets?.zegoAppSign}');

        if (userId.isEmpty ||
            secrets?.zegoAppId == null ||
            secrets?.zegoAppSign == null) {
          return CustomScaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    size: 64,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  Label(
                    text: context.isArabic
                        ? 'حدث خطأ ما'
                        : 'Something went wrong',
                    style: Styles.headerText(),
                  ),
                  const SizedBox(height: 8),
                  Label(
                    text: context.isArabic
                        ? 'تأكد من تسجيل الدخول وإعدادات التطبيق'
                        : 'Please check login and app settings',
                    style: Styles.headerText(),
                  ),
                ],
              ),
            ),
          );
        }

        // إعداد التكوينات
        final hostConfig = ZegoUIKitPrebuiltLiveStreamingConfig.host(
          plugins: [ZegoUIKitSignalingPlugin()],
        )..layout = ZegoLayout.gallery();

        final audienceConfig = ZegoUIKitPrebuiltLiveStreamingConfig.audience(
          plugins: [ZegoUIKitSignalingPlugin()],
        )
          ..inRoomMessage = ZegoLiveStreamingInRoomMessageConfig(
              resendIcon: const Icon(
            Icons.reply,
            color: Colors.white,
          ))
          ..layout = ZegoLayout.gallery();

        // عرض البث المباشر
        return SafeArea(
          child: ZegoUIKitPrebuiltLiveStreaming(
            appID: secrets!.zegoAppId,
            appSign: secrets.zegoAppSign,
            userID: userId,
            userName: context.read<UserCubit>().state.data?.fullName ?? '',
            liveID: widget.liveID,
            isLiveStream: true,
            config: widget.isHost ? hostConfig : audienceConfig,
            // ..foreground = giftForeground()  
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    liveStateNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // تحميل الأسرار عند بداية الشاشة إذا لم تكن محملة
    final secretsState = context.read<SecretsCubit>().state;
    if (secretsState.isInitial || secretsState.secrets == null) {
      context.read<SecretsCubit>().getAllSecrets();
    }
  }
}
